---
title: 複数アプリケーションから参照されるDBをridgepoleで管理する
date: '2015-06-10'
tags:
- howto
- programming
- ruby
---

![ridgepole](ridgepole-01.png)

## 忙しい人のためのまとめ

- Circle CIに、存在しないHostnameで秘密鍵を追加するのは諦めろ。
- データベースの変更はそれを独立で行えるようにした。具体的にはcap deployでridgepole applyできるようにした。

## tmixの現状

最近の大規模なwebサービスが、1つのアプリケーションとして動いているというのは珍しいだろう。[cookpad社がそうである](http://techlife.cookpad.com/entry/2014/09/08/093000)ように、[tmix](http://tmix.jp)も裏ではいくつかのRails Applicationが同時に動作している。
そしてそれらのRailsが見に行くデータベースはもちろん共通の1つである。


Railsは、そのアプリケーション内でschema.rbを用いてデータベースの定義を行っている。そしてRailsアプリケーションの数だけschema.rbが存在し、各アプリケーションの開発者が各々でschema.rbを好きに編集すると、conflictは避けられない。実際、tmixでもschema.rbを別リポジトリからコピーしてくるなんて作業はしょっちゅう行われていた。


この状況が好ましくないことは誰の目にも明らかであり、解決策としてのridgepoleの導入が必要だった。(参考 [クックパッドにおける最近のActiveRecord運用事情](http://techlife.cookpad.com/entry/2014/08/28/194147))

## ridgepoleの導入
### 現状の把握

ridgepoleを導入する前に、まずは現状を正しく把握する必要がある。


tmixは、メイン、画像生成、発注管理で3つのRails Applicationが動作している。それぞれはCircle CIによってGitHub Pushのタイミングでテストされ、production deploy時にはCircle CIからcapistranoを用いて本番環境にdeployされるようになっている。
環境は、development、staging、production、testの4つあり、それぞれにデータベースが存在する。

### 各リポジトリからschemaを適用させる(没案)

まず僕は、schemaを管理するためのリポジトリを作成し、それぞれのリポジトリがdeploy taskのなかでgit cloneを行い、ridgepole applyをさせれば良いと考えた。ridgepoleでは冪等性が保証されているので、schemafileの適用は何度走ってもよい。各アプリケーションがdeployされるたびに、データベースは更新される。


そのために、次のようなシェルスクリプトを作成し、circle.ymlで実行させるようにした。

```shell
cd ../
git clone git@github.com:spice-life/tmix-schema.git
cd tmix-schema
bundle install
bundle exec ridgepole -c ../tmix/config/database.yml --apply
```

当然のように、これはうまく動作しない。なぜなら、Circle CIでテストを行う環境は、その環境と結びついたリポジトリにしかアクセスできず、他のリポジトリをcloneする権限は持っていないからだ。(もちろんこの記事で出てくるリポジトリは大半がprivate)


そこで、いい方法はないものかとCircle CIのchatで聞いてみたところ、user keyを追加しろとの返答があった。しかし、それでは僕がアクセスできる全リポジトリへの権限が渡ってしまう。それに、サービスの運用が属人性の高いものになってしまう。これは良くない。
そのような返答をすると、今度はkey pairをCircle CIとGitHubに登録しろと言われた。これなら、権限が最小に抑えられて望ましい。
![circle ciでのchatの様子](ridgepole-02.png)


さて、SSH keyを登録するにしても、hostnameがgithub.comではいろいろと都合が悪い。そこで、hostanemeを"ridgepole"として登録し、git cloneするときには明示的にその鍵を使うようにした。具体的には以下のようにした。
 
```shell
cd ../
GIT_SSH=tmix-web/bin/git-ssh.sh git clone git@github.com:spice-life/tmix-schema.git
cd tmix-schema
bundle install
bundle exec ridgepole -c ../tmix/config/database.yml --apply
```

 
```shell
#!/bin/sh
exec ssh -oIdentityFile=~/.ssh/id_ridgepole "$@"
```

Circle CIで追加した鍵は、内部では`id_`をhostnameの前に付与して保存されるのでこのようにしている。


このようにしたことで、git cloneができるようになり、めでたしめでたし……と思っていると、おかしなことが起こり始めた。cap deploy時に次のようなエラーメッセージが表示されるようになったのである。

> ERROR: Repository not found.
> fatal: Could not read from remote repository.
>
> Please make sure you have the correct access rights
> and the repository exists.

もちろん追加した鍵のhostnameはridgepoleなので使われるはずはないのだが、鍵を削除するとdeployができるようになったので、仕方なく鍵を削除した。どうすれば良かったのだろう……


結局、user keyを追加するしか無い。そこで、chat deployを行うbotのuser keyを追加した。これで、git cloneができるようになり、ridgepole applyもできるようになった。


だが、この方針では、本番サーバーそれぞれがschemaリポジトリを保持することになり無駄であること、データベースの変更を単体で行えないなど問題点も多い。

### ridgepoleをcapistrano deployさせる

なので、schemaが存在するリポジトリをcap deployできるようにした。ただ、このためにサーバーを持つのも無駄なので、deploy先は既存アプリケーションのサーバーを間借りする形にした。


具体的には、以下の記述をdeploy.rbに追記した。
 
```ruby
namespace :deploy do
  after :published, :ridgepole do
    on roles(:db) do
      execute "cd #{fetch(:release_path)}; bundle exec ridgepole -E #{fetch(:stage)} -c database.yml --apply"
    end
  end
end
```

これでbundle exec cap hoge deployするとその環境のデータベースにridgepole applyができるようになった。

### テストについて

ridgepoleで読み込むschemafileについてsyatax errorがないか確認する簡単なテストを書いた。
 
```ruby
require "spec_helper"

describe "Schemafile" do
  it "should correct syntax" do
    `bundle exec ridgepole -c database.yml -E test --apply --dry-run`
    expect($?).to eq(0)
  end
end
```

schemafileについてはこれくらいでいいとして、問題は各アプリケーションのテストである。テスト時に、schema.rbを読み込んであれこれする動作をする場合、やめさせなければならない。Rspecを使用している場合、spec/rails_hepler.rbの
 
```ruby
ActiveRecord::Migration.maintain_test_schema!
```

この記述を削除する必要がある。


## 業務フローがどうなったか

ridgepoleの導入によって、業務の流れは次のようになった。

- schemaリポジトリをcloneし、Schemafileをいじる。lacalのデータベースに適用して開発をする。
- 変更内容が確定したらPullRequestを送り、test(syntax check)が通るか確認し、レビューしてもらう。
- masterにmergeされた段階でstagingのデータベースに自動でdeployされる。
- 各アプリケーションの変更を行い、staging deployなどで動作確認をする。(testはCircle CI上でschemaリポジトリをcloneして行う)
- 変更が確定したら、schemaをproduction deployした後、アプリケーションのproduction deployを行う


例えば共用の開発用データベースが存在する場合は、それに対しては手動でridgepole applyする必要がある。
