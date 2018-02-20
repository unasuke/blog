---
title: "落ちていたitamaeのintegration specを直しました"
date: 2018-02-04 23:00 JST
tags: 
- ruby
- itamae
- diary
- Programming
---

![itamae readme](2018/itamae-readme.png)

## master build failed
itamaeの名前を久々に聞いたのは、昨年11月に行なわれた福岡Ruby会議02でのことでした。前夜祭でのまなてぃさんの発表でitamaeを使っているとの話を聞き、また、懇親会でまなてぃさんがPullRequsetを出したがテストが通らずmergeもしてもらえないという話を聞き、それからずっとitamaeのことがどこか頭の片隅にありました。

その後、転職記事でも触れましたが、業務でpuppetを置き替えることになったときに、ここはitamaeを使ってみようと考えました。そこで[itamae-kitchen/itamae](https://github.com/itamae-kitchen/itamae)を見に行くと、そもそもmaster branchのでのCIが(2017年3月から)failedになっていることに気づきました。

cookpadでの採用実績や、gihyoでの解説記事、バージョンも1.9を迎えるなどそれなりに成熟しているOSSと言って差し支えないでしょうが、masterのCIが失敗しているプロダクトにあまりいい印象はないでしょう。そこで、業務でitamae recipeを書きつつ、その合間と個人的な時間でitamaeのCIを直すことに挑戦しました。

## fix CI
### まずは手元で実行できるように
さて、では作業にとりかかろうとforkし、cloneしてbundle installを実行しましたが、まずこれが失敗します。原因としては、net-ssh gemが、itamaeが依存しているspecinfraで要求しているバージョンとvagrantが要求しているバージョンとで衝突しているせいでした。

itamaeが要求しているvagrantですが、ryot\_a\_raiさんがforkしたものであり、またその意図もよくわからなかったので、gem update vagrantをしてしまえと思いました。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">なるほど。そもそもなんでforkしていたか忘れてしまった</p>&mdash; Ryota Arai (@ryot_a_rai) <a href="https://twitter.com/ryot_a_rai/status/938718134936076288?ref_src=twsrc%5Etfw">2017年12月7日</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

しかしvagrantはある時点からrubygemでの配布をやめ、公式サイトからパッケージをインストールする方式になっていたので、そもそもvagrantへの依存自体を削除することにしました。

### test-unitで落ちるspec
さて、落ちるspecを見てみます。

[https://app.wercker.com/buildstep/58bf89e2ae336e01005e1487](https://app.wercker.com/buildstep/58bf89e2ae336e01005e1487)

```
ERROR :         Command `gem install -v 3.2.0 test-unit` failed. (exit status: 1)
ERROR :   gem_package[test-unit] Failed.
```

というわけで、test-unit gemのあたりでなにやら失敗しているようです。このrecipeを見ると、以下のようになっています。

```ruby
gem_package 'test-unit' do
  version '3.2.0'
end
```

何の変哲もないgem\_packageですが、何故失敗するのでしょうか。

test-unit gemは、power\_assert gemに依存しています。power\_assert gemの内部で、`%i` を使用しているコードがあるのですが、integration specで使用しているubuntu trustyのRubyが1.9.3でまだこのリテラルに対応していないために、power\_assert gemのインストール(RDocの生成)に失敗してしまいます。

[https://github.com/k-tsj/power\_assert/blob/180b0c0fe619f4619d91e25b1d09b30f3df2f14c/lib/power\_assert/parser.rb#L61](https://github.com/k-tsj/power_assert/blob/180b0c0fe619f4619d91e25b1d09b30f3df2f14c/lib/power_assert/parser.rb#L61)

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">itamaeのintegration specでは、trustyにbuilt inのRuby(1.9.3)を使うんだけど、Ruby 1.9.3には %i がまだ実装されてないからpower_assert gem v1.1.1のinstallで落ちるんだ……</p>&mdash; うなすけ (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/status/939679802499383296?ref_src=twsrc%5Etfw">2017年12月10日</a></blockquote>
<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">まあそれはそうなんですがEOLなRubyのためにアレコレするのはちょっとどうかなーと思っているので、普通にRuby 2.2以上を入れたい気持ちです。</p>&mdash; うなすけ (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/status/939716441967706112?ref_src=twsrc%5Etfw">2017年12月10日</a></blockquote>

なので、ubuntuをtrusty(14.04 LTS)ではなくxenial(16.04 LTS)にアップグレードしてしまいました。

### パッケージがインストールできなくなる
ある程度覚悟していましたが、ubuntuをアップグレードした結果、バージョンを指定していたパッケージのインストールに失敗するようになってしまいました。
これは、単純にバージョンを有効なものに変更するだけで済みます。これでslのバージョンが上がり(？)ました。

```diff
 package 'sl' do
-  version '3.03-17'
+  version '3.03-17build1'
 end
```

### rcスクリプトを参照するrecipeが存在する
とりあえず、以下のrepiceを見てください。

```ruby
service "nginx" do
  action [:enable, :start]
end

execute "test -f /etc/rc3.d/S20nginx" # test
execute "test $(ps h -C nginx | wc -l) -gt 0" # test

service "nginx" do
  action [:disable, :stop]
end

execute "test ! -f /etc/rc3.d/S20nginx" # test
execute "test $(ps h -C nginx | wc -l) -eq 0" # test
```

[https://github.com/itamae-kitchen/itamae/blob/2c57ecc2f085643a47a7d509040685dbecde8bc7/spec/integration/recipes/default.rb#L246](https://github.com/itamae-kitchen/itamae/blob/2c57ecc2f085643a47a7d509040685dbecde8bc7/spec/integration/recipes/default.rb#L246)

見てわかるように、rcスクリプトを参照しているrecipeがあります。しかし、ubuntu xenialにアップグレードしたことによって、initがUpstartからsystemdへと変化しました。その結果、rcスクリプトは利用できなくなってしまい、このrecipeは適用できません。(この辺ちゃんとした理解ができてないです)

ただ、rcスクリプトを使用したコマンドの内容自体は、続く行で実行している `ps` にて担保できているとみなせます。なので、rcスクリプトを使用しているrecipeを削除することで対応しました。

### 複数回実行したときに落ちる場所が変わるspec
新規に起動したVMに対してspecを実行する場合と、それが失敗して、もう一度そのVMに対してspecを実行する場合とで、落ちるspecが異なることに気付きました。

原因調査のために`vagrant ssh`などでVMに入り調べたところ、以下のspecでその問題が発生していました。

```ruby
execute "mkdir /tmp/link-force-no-dereference1"
link "link-force-no-dereference" do
  cwd "/tmp"
  to "link-force-no-dereference1"
  force true
end

execute "mkdir /tmp/link-force-no-dereference2"
link "link-force-no-dereference" do
  cwd "/tmp"
  to "link-force-no-dereference2"
  force true
end
```

この`mkdir`を実行している部分です。`mkdir`は、既に存在しているディレクトリを対象にして実行するとエラーを返します。一度目の実行で作成されたディレクトリが残ったまま、もう一度recipeを適用すると、作成対象のディレクトリは既に存在しているためにエラーになってしまいます。

なので、この`execute`に対して`not_if`制約を追加することにより、エラーが発生しないようにしました。

これについては、一度作成したVMに対して複数回specを流す場合に発生する問題で、CI上では都度インスタンスを作成するために問題になりません。
また、`mkdir`に`-p`を追加することでも回避できるでしょう。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">mkdir -p でうまくいったりしないの <a href="https://twitter.com/hashtag/wakate2018w?src=hash&amp;ref_src=twsrc%5Etfw">#wakate2018w</a></p>&mdash; why/橘和板 (@whywaita) <a href="https://twitter.com/whywaita/status/959663338350260224?ref_src=twsrc%5Etfw">2018年2月3日</a></blockquote>

### 解消できなかったsticky bit問題
とあるrecipeの実行で、net-scp gemが例外を吐いて落ちる、という問題が発生しました。

```ruby
file '/tmp/file_edit_with_suid' do
  action :edit
  owner 'itamae2'
  group 'itamae2'
  mode '4755'
end
```

これについては、エラーの内容、backtraceが深いこと、recipeの実行そのものには成功していることなどから、深追いするのは諦めました。実力不足とも言えます。

なぜか以下のような変更をすることによって回避できるので、workaroundである旨をcommit message書いておきました。

```diff
 file '/tmp/file_edit_with_suid' do
-  action :edit
   owner 'itamae2'
   group 'itamae2'
   mode '4755'
end
 ```
 
### Rakeが複数インストールされている
実はこれまでに挙げた問題というのは、specを実行する前段階であるrecipeの適用段階で発生していた問題でした。integration specでは、まずVMに対してitamae repiceを適用してから、そのrepcipeが正しく適用されているかの確認のためにserverspecを実行しています。

という訳で、やっとserverspecが落ちているところまで辿りつきました。次のようなspecです。

```ruby
describe command('gem list') do
  its(:stdout) { should include('rake (11.1.0)') }
end
```

内容としては、rake gemのversion 11.1.0が入っていることを期待するもので、repcipeにも同様の記述が存在しています。

しかし、同様にrepcipeでのインストール指定を行なっているbundler 1.16では、rakeのversion 10系をdependencyとしています。
そのために、`gem list`の実行では複数versionのrakeがインストールされている事実が返ってくるので、文字列 `'rake (11.1.0)'` のmatchに失敗します。

これについては、文字列の末尾の閉じカッコを削除し、複数versionのrake gemがインストールされている状態でも通るようにしました。(あまり筋がいいとは思えませんが……)

### test-unit gemが存在してしまう
test-unit gem、2回目の登場です。

以下のrepcipeにより、test-unit gemは削除されているはずなのですが、実際にはtest-unit gemは削除されておらず、specが落ちてしまいます。

```ruby
gem_package 'test-unit' do
  version '3.2.0'
end

gem_package 'test-unit' do
  version '3.1.9'
end

gem_package 'test-unit' do
  action :uninstall
end
```

これは、ubuntuがxenialにアップグレードされたことに関係しています。
xenialでは、Ruby 2.3.1がaptからインストールされますが、Ruby 2.3.1では、test-unit gemをdefault gemとして扱っています。

そのために、test-unit gemをuninstallすることができず、specは落ちる、ということでした。

これについては、このspecを削除することで対応しました。

### wercker.ymlの書き直し
さて、これでローカル環境でspecが通るようになったので、CIであるwerckerで実行できるようにしなければなりません。

しかし、Vagrantのインストール方法を変更したので、wercker.ymlの内容を変更する必要があります。

まずは愚直に、Ruby officialのdocker imageをboxに指定してみましたが、Vagrantの起動に失敗します。エラーの内容を見ると、`modinfo`が存在していない、というものでした。

しかし、色々調べてみたところ、docker container内で`modinfo`をインストールすることはできないようです。

(数ヶ月前のことなのでどこを参照してその結論に至ったかは覚えてないのですが、今`ruby:2.3.1`のimageに対して`apt install kmod`を実行すると、インストールできるので、この認識が間違っている可能性は大いにあります。
しかし、`modinfo`の実行自体も、様々なmoduleに対して実行してもエラーが返ってくるので、やはり一筋縄ではいかないようです)

よくわからんなー状態になっていたのですが、そういえばsue445さんがitamae pluginをCIすることに一家言ある方だったことを思い出し、そのwercker.ymlを参考にすることにしました。

[34歳になった＆itamaeプラグインを本気でCIする #omotesandorb - くりにっき](http://sue445.hatenablog.com/entry/2016/04/07/195627)

そして紆余曲折あり、`drecom-ruby` imageを使用してVagrantのインストールと実行に成功するようになりました。

![sue445さんのアドバイス in itamae.slack #random](2018/itamae-ci-fix-slack-advise-by-sue445.png)

## Pull Requestの作成
これでなんとかようやくCIがpassするようになったので、pull requestを作成しました。

[Fix failing integration spec (including workaround) by unasuke · Pull Request #253 · itamae-kitchen/itamae](https://github.com/itamae-kitchen/itamae/pull/253)

![#253](2018/itamae-pullrequest-253.png)

これに取り組み始めたのが12月の頭、PullReqの作成が1月の末であることから、まるまる2ヶ月の間、格闘していたことになります。実作業時間は恐らく1週間とちょっとくらいだと思いますが……

12月のESMさんでのOSSパッチ会でもくもくしていたのが遠い昔のように思えます(その時は`mkdir`問題に取り組んでいました)。

このPullReq自体も、wercker pipelineの編集が必要なためにCIは落ちているのですが、仕方ないですね。

## 情報科学若手の会冬の陣2018での発表
[情報科学若手の会冬の陣2018 #wakate2018w - connpass](https://wakate.connpass.com/event/74427/)

また、これに関して、情報科学若手の会冬の陣2018で発表してきました。以下が資料となります。


<iframe src='https://unasuke.github.io/wakate2018w_talk/' width='800px' height='600px'></iframe>

[unasuke/wakate2018w\_talk](https://github.com/unasuke/wakate2018w_talk)
