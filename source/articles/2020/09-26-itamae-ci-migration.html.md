---

title: "ItamaeのCIを travis-ci.org から travis-ci.com に移行しました"
date: 2020-09-26 18:28 JST
tags: 
- ruby
- programming
- itamae
- circleci
- github
---

![](2020/itamae-travis-ci-fail.png)

## 読む前に
タイトルに書いてあるように、travisの org から com に移行した、という話なのですが、そこに至るまでに様々な苦労をしたのでお願いだから最後まで読んでねぎらってください。

## そもそもの始まり
ItamaeのCIには、travis-ci.org を使用していました。

CIというものは、たまに落ちることがあります。その原因は内部のコードが悪い場合や外部要因である場合などが挙げられます。ItamaeのCIも、例によってたまに落ちることがありました。

![落ちているログ](2020/itamae-ci-fail-log.png)

たまに落ちることはよくて、落ちたCIを再度実行して通れば良いのです。しかし問題は、**「落ちたtestを再度実行することができない」** というところにありました。

いつからなのかは不明ですが、travis-ci.org では失敗したtestを再実行するUIが消えてしまっており、空commitを積むなどしなければ同じコードでのtestの再実行ができなくなっていました。

![再実行ができない様子](2020/itamae-travis-ci-fail.png)

この "More Options" 内の "Requests" は一見再buildのリクエストのように見えますがそのような挙動はしません。

これは非常につらい。ので、CIをtravis-ci.orgではない別の何かに乗り換えることにしました。

## Itamaeのテストについて

CIについて話す前に、Itamaeのtestにおける対象の組み合わせについて触れておきます。CIでは以下のような組み合わせに対してテストを行っています。

- Rubyのversion
    - 2.3からheadまでの6 versions
- JITの有無
    - 2.6以上のRuby(3 versions)に対して
- unitなのかintegrationなのか

unitなのかintegrationなのか、というのは、unitはItamae gemの実装に対してテストを行い、integrationは用意されているrecipeをDocker containerに適用して意図した状態にできているかを確認するテストとなっています。

(以前はDigitalOceanで起動したインスタンスに対してrecipeの適用を行っていました)


## 選択肢

さて、OSSなら無料で使用できるCIサービスというものはいくつかありますが、代表的なものに以下の2つが上げられると思います。

- GitHub Actions
- CircleCI

新しもの好きということもあり、まずGitHub Actionsを試してみることにしました。

## GitHub Actions

まずGitHub Actionsでのunit testは以下のようなYAMLで実行できます。

```yaml
name: "unit test on ubuntu"

on:
  push:
    branches: "*"
jobs:
  test:
    strategy:
      matrix:
        os: [ubuntu-16.04, ubuntu-18.04]
        ruby: [2.2, 2.3, 2.4, 2.5, 2.6, 2.7, head]
      fail-fast: false
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v2
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: ${{ matrix.ruby }}
      - run: bundle install
      - run: bundle exec rake spec:unit
```

簡単ですね。これで問題なくunit testはpassするようになります。

![GitHub Actionsでunit testが成功する様子](2020/itamae-unit-test-on-github-actions.png)

しかし、GitHub Actionsでは **integration testがどうしても成功しない**という問題に直面してしまいました。

![GitHub Actionsでintegration testがランダムに落ちる様子](2020/itamae-github-actions-integration-test.png)

### なぜintegration testが通らないのか
なぜ通らないのかの原因がわかればいいのですが、これが全くの不明でした。上記画像にあるように落ちているものもあれば通っているものもあり、全体的に不安定になっています。落ちている原因そのものはtmpディレクトリに書き込みができなくなって落ちているのですが、なぜそうなっているのかはわかりません。

友人に相談したところ、興味深い事実が明らかになりました。

![Slack log1](2020/itamae-github-actions-debugging-1.png)
![Slack log2](2020/itamae-github-actions-debugging-2.png)

**「straceをonにするとpassする」** のです。

straceは何をするツールなのかと言うと、システムコールをトレースするツールです。それを有効にしただけで通るようになる、つまり実行に対してオーバーヘッドがかかるとtmpへの書き込みが成功してtestが成功する、という現象が発生しているようなのです。

なぜこのような状況になっているのかの調査はちょっとハードルが高すぎるので、GitHub Actionsの採用は見送ることにしました。

(self-hosted runnerを使用することでGitHub Actionsで使用されているインスタンスに特有の問題なのかを調査することもできますが、そこまでの元気は出ませんでした)

## CircleCI
次に手を出したのはCircleCIです。CircleCIでは最近matrix jobを記述できるようになり、複数の条件を組み合わせたテストが書けるようになりました。

<https://circleci.com/blog/circleci-matrix-jobs>

とはいえ複雑なYAMLになってしまいました。

<details>
<summary>.circleci/config.yml を見る</summary>

<pre class="highlight yaml"><code>
version: 2.1
orbs:
  ruby: circleci/ruby@1.0.7

executors:
  docker:
    docker:
      - image: cimg/base:stable
  docker-1804:
    docker:
      - image: cimg/base:stable-18.04
  machine:
    machine:
      image: circleci/classic:201808-01

jobs:
  unit:
    parameters:
      ruby-version:
        type: string
      exec:
        type: executor
        default: ""
    executor: << parameters.exec >>
    steps:
      - checkout
      - ruby/install:
          version: << parameters.ruby-version >>
      - run: gem install bundler --version 1.17.3 --force
      - run: bundle install -j4
      - run: ruby -v
      - run: bundle exec rake spec:unit
  integration:
    parameters:
      ruby-version:
        type: string
    executor: machine
    # executor: docker
    steps:
      - checkout
      - setup_remote_docker:
          version: 18.06.0-ce
      - ruby/install:
          version: << parameters.ruby-version >>
      - run: gem install bundler --version 1.17.3 --force
      - run: bundle install -j4
      - run:
          command: |
            ruby -v
            export PATH=$HOME/.rvm/bin:$PATH
            ruby -v
      - run: bundle exec rake spec:integration:all
  unit-jit:
    parameters:
      ruby-version:
        type: string
    executor: docker
    steps:
      - checkout
      - ruby/install:
          version: << parameters.ruby-version >>
      - run: gem install bundler --version 1.17.3 --force
      - run: bundle install -j4
      - run: ruby -v
      - run: RUBYOPT=--jit bundle exec rake spec:unit
  integration-jit:
    parameters:
      ruby-version:
        type: string
    # executor: machine
    executor: docker
    steps:
      - checkout
      - setup_remote_docker:
          version: 18.06.0-ce
      - ruby/install:
          version: << parameters.ruby-version >>
      - run: gem install bundler --version 1.17.3 --force
      - run: bundle install -j4
      - run: ruby -v
      - run: RUBYOPT=--jit bundle exec rake spec:integration:all

workflows:
  version: 2
  all-test:
    jobs:
      - unit:
          exec:
            name: docker-1804
          matrix:
            parameters:
              ruby-version: ["2.3"]
      - unit:
          exec:
            name: docker
          matrix:
            parameters:
              ruby-version: ["2.4", "2.5", "2.6", "2.7"]
      - integration:
          matrix:
            parameters:
              ruby-version: ["2.3", "2.4", "2.5", "2.6", "2.7"]
  # all-test-with-jit:
  #   jobs:
      - unit-jit:
          matrix:
            parameters:
              ruby-version: ["2.6", "2.7"]
      - integration-jit:
          matrix:
            parameters:
              ruby-version: ["2.6", "2.7"]
</code></pre>
</details>

CircleCIでItamaeのtestを実行するにあたり、いくつかの壁に突き当たったので紹介します。

###  ruby/install-depsの挙動

CircleCIにはOrbという仕組みがあり、汎用的な手順ならYAMLに記述しなくてもOrbを導入することによって記述を省略できる仕組みがあります。

[Orb の概要 - CircleCI](https://circleci.com/docs/ja/2.0/orb-intro/)

Rubyの実行環境を用意するOrbとして、CircleCIが公式で用意しているのが `circleci/ruby` です。

- <https://circleci.com/orbs/registry/orb/circleci/ruby>
- <https://github.com/CircleCI-Public/ruby-orb>

このOrbですが、bundlerをインストールするのにGemfile.lockの存在をアテにしている部分があります。

<https://github.com/CircleCI-Public/ruby-orb/blob/5fee9e2ae8fc7a88cce9ce4d9da4c562ead614b1/src/commands/install-deps.yml#L34-L41>

Itamaeはgemであり、Gemfile.lockをリポジトリに含んではいません。ではこのOrbは使えないのかというとそうではなく、よく読むとわかるように `bundler-version` を渡すとGemfile.lockがなくても指定したversionのbundlerをインストールできるように見えます。
しかし既存のbundlerを上書いてしまってよいかの確認ダイアログが出るため、どちらにしろ上手く動きません。

![bundlerを上書きできない](2020/itamae-circleci-bundler-force-install.png)

結局、bundlerのinstallは手で `--force` を付与したコマンドを実行させることで回避しました。

### machine executorでRubyのversionが設定できない？

unit testはこれでうまくいくようになりましたが、dockerコマンドを使用する都合上、machine executorで実行しているintegration testでエラーが出るようになりました。それもJITを有効にしている場合のみ失敗します。

![--jitが無効](2020/itamae-circleci-invalid-option-jit.png)

エラーを見ると、`--jit` というオプションが不正というものでした。しかし、このスクリーンショットで使用しているRubyは2.6であり、`--jit` は有効なはずです。

不審に思い、Rubyのversionも出力するようにしたのが以下のスクリーンショットです。

![Rubyのversionが一致しない](2020/itamae-circleci-ruby-version-mismatch.png)

なんと、Ruby 2.6 をインストールしたはずなのに、使用されているのはRuby 2.3になっています。これはRVMのPATHをこねくりまわしてもどうしても解決することができませんでした。どうしてこんなことになるのでしょう。

### setup\_remote\_dockerではvolume mountが使用できない

二進も三進もいかないので、remote dockerを使用してみることにしました。これは、unit testで使用しているDocker executorであればRubyのversionが正しく設定できているので、その環境においてdockerコマンドを使用できるようにするための仕組みです。

> デプロイする Docker イメージを作成するには、セキュリティのために各ビルドに独立した環境を作成する特別な setup\_remote\_docker キーを使用する必要があります。 この環境はリモートで、完全に隔離され、Docker コマンドを実行するように構成されています。 ジョブで docker または docker-compose のコマンドが必要な場合は、.circleci/config.yml に setup\_remote\_docker ステップを追加します。
>
> [Docker コマンドの実行手順 - CircleCI](https://circleci.com/docs/ja/2.0/building-docker-images/#section=configuration)

しかし、やはりエラーになってしまいます。これはテストの過程においてItamaeのコードをまるっとdocker container側にvolume mountしている部分があるのですが、remote dockerがvolume mountをサポートしていないためにエラーになります。

> ジョブ空間からリモート Docker 内のコンテナにボリュームをマウントすること (およびその逆) はできません。
> <https://circleci.com/docs/ja/2.0/building-docker-images/#section=configuration>

(docker cpはできますが)

という様々な躓きがあり、CircleCIを使うのはあきらめようと考えました。
(あきらめるまでに60回以上CIを回しています)

## travis-ci は org から com へ移行できる
ではどこのCIを使おうか、となるのですが、そもそもtravis-ci.comへの統合が進められていることに気付きました。

2018年に、Travis CIはGitHub Appsとして導入できるようになり、OSSも `travis-ci.com` でCIを実行できるようになっています。

- [The Travis CI Blog: Announcing support for open source projects on travis-ci.com](https://blog.travis-ci.com/2018-05-02-open-source-projects-on-travis-ci-com-with-github-apps)
- [Beta - Migrating repositories to travis-ci.com - Travis CI](https://docs.travis-ci.com/user/migrate/open-source-repository-migration)

2020年の今でも `travis-ci.org` を使用しているので、試しに `travis-ci.com` に移行してみることにしました。

この移行はとても簡単で、 `travis-ci.com` にGitHub accountでログインしてMigrateボタンをクリックするだけです。

結果ですが、このように "Restart build" ボタンが出現しており、テストの再実行ができるようになりました！

![Restartができる様子](2020/itamae-on-travis-ci-com.png)

## まとめ
という諸々があり、ItamaeのCIは `travis-ci.com` に移行することになります。

これについて、[第53回情報科学若手の会](https://wakate.connpass.com/event/165723/)のLT枠で発表した資料を貼っておきます。

<iframe src="https://slide.rabbit-shocker.org/authors/unasuke/wakate2020/viewer.html"
        width="320" height="225"
        frameborder="0"
        marginwidth="0"
        marginheight="0"
        scrolling="no"
        style="border: 1px solid #ccc; border-width: 1px 1px 0; margin-bottom: 5px"
        allowfullscreen> </iframe>
<div style="margin-bottom: 5px">
  <a href="https://slide.rabbit-shocker.org/authors/unasuke/wakate2020/" title="wakate2020">wakate2020</a>
</div>
