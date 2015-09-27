---
title: middlemanとh2oとVPSによるブログ構築
date: '2015-09-23'
tags:
- Programming
- middleman
- h2o
- howto
- linux
- ubuntu
- ruby
- mruby
---

![h2oのbuild](2015/blog-moved-build-h2o.jpg)

## wordpressからmiddlemanへ
wordpressからmiddlemanへの移行は、今まで(はてなダイアリーからtumblrへ、tumblrからwordpressへ)のお引越しとは違う、極めて大規模な物になることが予想されました。理由は、 __「記事の移行が発生する」__ からです。

むしろ何故いままでのブログ移転では記事の引っ越しをしていないか、という話ではあります。しかし、今回の移転は記事の移行が必要になる理由が2つありました。

### 維持費がかかる
wordpressはさくらのレンタルサーバー スタンダードを使って運営していました。これを残しておくとなると、月額515円の維持費が発生します。なので、新しいブログに移転するタイミングでサーバーを解約してしまいたかったのです。

### アクセス数の多い記事がある
Slackに関する記事、windowsとubuntuのdualbootに関する記事などは定期的なアクセスが発生しており、検索流入もそれなりにあるのでぜひとも残したいという気持ちがありました。

## 移行にあたって考慮した点
以前の記事を残しつつ、新しくブログを作るにあたって考慮したのが、以下の項目です。

### 以前のURLからアクセスできるようにする
ありがたいことに、記事へのリンクを記載していただいているwebページもありました。それらのリンクを変更することなく新しいブログへ誘導させたいと思いました。

### 記事はmarkdownで書く
wordpressの頃は、markdownモードがあるにも関わらず、直接htmlを書くか、あるいはmarkdownで書いてからhtmlに変換して編集エリアにペーストしていました。それをやめ、すべてmarkdownで書くことにしました。

### ブログの外見は自分で書く
すでに存在するテーマ等は使わず、自らSassを書いて一からデザインすることにしました。

### 最新の技術を取り入れていく
最新の技術を勉強する上で重要なのは、実際に使ってみることだと思っています。h2oの使用を決めたのも、この理由によります。

## ブログ移行
それでは、ブログ移行までの道のりを綴っていきます。

### 現状確認
worpressで運営していた`unasuke.com`は、78個の記事、309の画像、日ごとに100前後のアクセス数をもつブログでした。ドメインはお名前.comで取得したものをさくらに登録して使用していました。主な流入は検索によるものでした。使用しているwordpressのバージョンは4.2系、有効になっているプラグインは13個ありました。

### wordpressから、なにに移行するのか
静的サイト構築ツールはいくつも存在します。その多さは[Static Site Generators](https://staticsitegenerators.net/)を見ていただけると分かります。僕が候補として考えたのは、以下の5つです。

- [Octopress](http://octopress.org/)
- [Hugo :: A fast and modern static website engine](https://gohugo.io/)
- [Spina - Open source Ruby on Rails CMS](http://www.spinacms.com/) (これは静的サイト構築ツールではないですが、候補のうちには入っていました)
- [Jekyll • Simple, blog-aware, static sites](https://jekyllrb.com/)
- [Middleman: Hand-crafted frontend development](https://middlemanapp.com/)

Octopressは、その特徴的なfaviconで使用しているブログがすぐ分かります。あのfaviconが好きになれなくて使わないことにしました。Hugoは、記事生成のスピードが凄まじいと話題ですが、Goで書かれていることもあり、Goのエコシステムが未知なことと、今後の記事生成で不満が出てきたら乗り換え先として考えることにし、今回は使わないことにしました。SpinaはRails製CMSとのことで少し触ってみましたが、([unasuke/spina-test](https://github.com/unasuke/spina-test))ドキュメントが殆ど無いこと、そもそもCMSであることから使わないことにしました。最終的に残ったJekyllとmiddlemanでだいぶ悩みましたが、会社や所属するコミュニティでmiddlemanを使っていること、先輩にmiddlemanを勧められたことにより、middlemanを使用することに決定しました。

### さくらのレンタルサーバーから、なにに移行するのか
レンタルサーバーをやめ、自由度の高いVPSに移行することは決めていましたが、その先は3つ候補があると思っています。

- [Amazon Web Services](https://aws.amazon.com/jp/)
- [ConoHa](https://www.conoha.jp/)
- [VPS（仮想専用サーバ）｜さくらインターネット](http://vps.sakura.ad.jp/)

ConoHaは不安定であることが友人の使用例からわかっていたので使わないことにしました。AWSとさくらで迷いましたが、これまで使っている会社であること、信頼性に関して実績があることからさくらのVPSを使用することに決定しました。

### Apacheから、なにに移行するのか
これについても3つの選択肢がありました。

- [Apache](http://httpd.apache.org/)
- [nginx](http://nginx.org/en/)
- [H2O](https://h2o.examp1e.net/)

これについては、最新の技術を取り入れていくという目標があるので、迷わずh2oを使用することに決定しました。

### wordpressから記事と画像のエクスポート
記事の移行のために、wordpressから記事を移行する作業をしました。移行には[mdb/wp2middleman](https://github.com/mdb/wp2middleman)を使用しました。エクスポートしたXMLを、

```shell
% wp2mm wordpress.2015-07-25.xml
```

とし、すべての記事について手作業でmarkdownに変換しました。markdownに変換する、以下の様なオプションもありましたが、試したところ画像の処理がうまくいっておらず、やはり手作業は必要でした。

```shell
% wp2mm wordpress.2015-07-25.xml --body_to_markdown true
```

また、画像も撮影した時点のファイル名となっていたのを、意味のある名前に変更、年ごとにディレクトリを分割などの作業を行いました。

体感では、この作業が一番長く時間がかかったように思います。[markdownized · unasuke/blog@e0658de](https://github.com/unasuke/blog/commit/e0658de9739fbd9f36cae3ea197b07af88a723ef)

### middlemanの設定を整える
middlemanは素で使うのではなく、ブログ用の拡張である`middleman-blog`を適用させて使うことにしました。記事のURLをwordpressの頃とほとんど変えないなどの設定を`config.rb`に書いていきました。他にも、livereloadの設定や、layoutの設定などを整えていきました。[History for config.rb - unasuke/blog](https://github.com/unasuke/blog/commits/master/config.rb)

### サイトのデザインをしていく
デザインをする上で、以下の条件をつけました。

- 基本的に白と黒(に近い色)のみを使う
- Sassを使う
- 単位にはなるべく%を使う

これは、色が増えると調和を取るために考えなければいけないことが増えるのを避けるためと、画面サイズ、解像度になるべく依存しないようにするためです。Sassは慣れているし、bootstrapもSassに移行するとのことでAltCSSのデファクトスタンダードとなりつつある(ような気がする)からです。

また、会社のデザイナーさんに教わったことですが、白と黒(#fffと#000)の組み合わせはコントラストが強くて良くないそうなので、純粋な白、黒は使用しないことにしました。

結果的に現在のようなものになりましたが、これで決まったわけではなく、今後も修正は続けていきます。

### web fontをどうにかする
web fontも興味があったので使ってみることにしました。どのフォントを使うにせよ、サブセット化(使う文字だけ収録されたフォントファイルをつくる)は日本語を使う以上は避けられないと考えました。[3846masa/japont](https://github.com/3846masa/japont)を使って動的にfontを生成しようかとも考えましたが、とりあえずは[M+Web FONTS Subsetter](http://mplus.font-face.jp/#/)を使うことにしました。それにあたって、ブログ内で使われている文字を抽出する必要があり、以下の様なスクリプトを使って文字を抽出し、web fontを作成しました。
<script src="https://gist.github.com/unasuke/4bdffdae3246fbbfa744.js"></script>

### VPS serverの初期設定
server OSにはUbuntu 14.04 LTS amd64を選択しました。

まずはOSのインストール、SSHの設定、iptablesの設定を行いました。

```shell
% sudo vim /etc/ssh/sshd_config
% sudo service ssh restart
% sudo apt-get install iptables-persistent
% sudo invoke-rc.d iptables-persistent save
```

### h2oのビルド

以前の記事URLから、新しい記事のURLにリダイレクトさせるために、正規表現が必要になると考えました。具体的には、


```
# old url
http://unasuke.com/diary/2015/yapc-asia-tokyo-2015/

# new url
http://blog.unasuke.com/2015/yapc-asia-tokyo-2015/
```

このようになります。categoryがすべてtagに統一されたので、URLからcategoryを除いたものへとリダイレクトさせてやりたいのです。

まずは、h2oが素で正規表現を用いたroutingを行えるかどうか確認します。

```shell
# h2oのビルド
% sudo apt-get install locate git cmake build-essential checkinstall autoconf pkg-config libtool python-sphinx wget libcunit1-dev nettle-dev libyaml-dev libuv-dev
% sudo apt-get install unzip zlib1g-dev bison
% wget https://github.com/h2o/h2o/archive/v1.5.0-beta4.zip
% unzip v1.5.0-beta4
% cd h2o-1.5.0-beta4
% cmake -DWITH_BUNDLED_SSL=on .
% make
% sudo make install
% h2o -v
h2o version 1.5.0-beta4
OpenSSL: LibreSSL 2.2.2
```

はいりました。ひとまずexampleの設定を使って立ち上げてみましょう。

```shell
% pwd
/home/hoge/h2o-1.5.0-beta4
% h2o -c ~/h2o-1.5.0-beta4/examples/h2o/h2o.conf # conf内のpath指定があるので注意
```

これで8080番ポートにアクセスするといい感じになにか見れると思います。ちなみに、`example/h2o/h2o.conf`を以下のように書き換えると、URLにポートを指定せずに接続することができますが、h2oの起動に管理者権限が必要となります。

```yaml
# to find out the configuration commands, run: h2o --help
# 秘密鍵とかも消す
listen: 80
hosts:
  "127.0.0.1.xip.io:80":
    paths:
      /:
        file.dir: examples/doc_root
    access-log: /dev/stdout
```

では、このyamlでワイルドカードが使えるかどうか試してみます。

```yaml
# to find out the configuration commands, run: h2o --help
# 秘密鍵とかも消す
listen: 80
hosts:
  "127.0.0.1.xip.io:80":
    paths:
      /:
        file.dir: examples/doc_root
      "/test/test":
        file.dir: examples/doc_root
      "/*/test":
        file.dir: examples/doc_root
    access-log: /dev/stdout
```

この設定でh2oを立ち上げたところ、`/test/test`にはアクセスができましたが、`/hoge/test`にはアクセスできませんでした(not found)。なので、mrubyなどでなんとかしてやる必要があると感じました。

ひとまず、mrubyをインストールします。

```shell
% sudo apt-get install mruby libmruby-dev
```

mrubyのインストールができたら、h2oをmrubyを使えるようにしてもう一度buildします。

```shell
% cmake -DWITH_BUNDLED_SSL=on -DWITH_MRUBY=on .
% make
% sudo make install
% h2o -v
h2o version 1.5.0-beta4
OpenSSL: LibreSSL 2.2.2
mruby: YES
```

~~なにも考えずにh2oの最新版[Release H2O version 1.5.0-beta4 · h2o/h2o](https://github.com/h2o/h2o/releases/tag/v1.5.0-beta4)をbuildしたら、どうやらmruby拡張のAPIがRackベースのものに変更になったらしく、そのサンプルコードを動かしてみてもどういう動作をするのかが全く読めなかったので、Rack based APIに変わる前でvulnerability修正がされている[Release H2O version 1.4.5 · h2o/h2o](https://github.com/h2o/h2o/releases/tag/v1.4.5)を使うことにしました。~~

ひとまず`examples/h2o_mruby/h2o.conf`を以下のように変更します。

```yaml
# to find out the configuration commands, run: h2o --help

listen: 80
# host名はサーバーのドメインに設定してもよい
hosts:
  "127.0.0.1.xip.io:80":
    paths:
      /:
        mruby.handler-file: examples/h2o_mruby/hello.rb
    access-log: /dev/stdout
```

そしてアクセスすると、次のような文字列が返ってきます。

> hello from h2o_mruby. User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.99 Safari/537.36 New User-Agent:new-Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.99 Safari/537.36-h2o_mruby path:/ host:hoge method:GET query:

では、mrubyをつかって旧URLから新URLへのリダイレクトをさせるように、やっていきます。

まず、旧URLの形式ですが、次のようになっています。

> http://unasuke.com/#{カテゴリー(diary,howto,info,review,about-me)}/#{記事公開年(2013から2015)}/#{記事タイトルっぽい英文}/

これに一致する正規表現を以下のように作成しました。

```ruby
reg = Regexp.compile("(diary|howto|info|review|about-me)(/.*)")
```

さて、mrubyはrubyとは違い、組み込み向けなので正規表現は標準の状態では使用できません。mgemというmruby用のgemを組み込んでmrubyをコンパイルし直す必要があります。しかしh2oがbuildするmrubyには既に[mattn/mruby-onig-regexp](https://github.com/mattn/mruby-onig-regexp)が組み込まれているので、正規表現が使えます。(気付かずに自前でbuildしてた)

```ruby
class HelloApp
  def call(env)
    h = "hello"
    m = "from h2o_mruby"

    ua = env["HTTP_USER_AGENT"]
    new_ua = "new-#{ua}-h2o_mruby"
    path = env["PATH_INFO"]
    host = env["HTTP_HOST"]
    method = env["REQUEST_METHOD"]
    query = env["QUERY_STRING"]

    # この辺を追記
    reg = Regexp.compile("(diary|howto|info|review|about-me)(/.*)")
    result = "#{reg =~ path}\n $1=#{$1}\n $2=#{$2}\n"

    msg = "#{h} #{m}.\n User-Agent:#{ua}\n New User-Agent:#{new_ua}\n path:#{path}\n host:#{host}\n method:#{method}\n query:#{query}\n"

    [200,
     {
       "content-type" => "text/plain; charset=utf-8",
       "user-agent" => new_ua,
     },
     ["#{msg}\n\n#{result}"]
    ]

  end
end

HelloApp.new
```

![正規表現の結果](2015/blog-moved-mruby-regexp.jpg)

できました。これをドメインを見てリダイレクトさせるかどうか判断させ、さらに実際にリダイレクトさせればいいわけです。リダイレクトさせるには、301を返してやればいいので、このようになります。

```ruby
class HelloApp
  def call(env)
    path = env["PATH_INFO"]
    reg = Regexp.compile("(diary|howto|info|review|about-me)(/.*)")
    result = "#{reg =~ path}\n $1=#{$1}\n $2=#{$2}\n"

    [301,
      {
        "Location" => "https://blog.unasuke.com#{$2}"
      },
      []
    ]
  end
end

HelloApp.new
```

無駄な部分もありますが、実際にこれでリダイレクトができました。

このmrubyを使用した最終的なh2o設定ファイルは次のようになりました。

```yaml
listen: 80
listen:
  port: 443
  ssl:
    certificate-file: /hoge/path
    key-file: /hoge/path
hosts:
  "unasuke.com:80":
    paths:
      /:
        mruby.handler-file: /home/blog/redirect.rb
  "unasuke.com:443":
    paths:
      /:
        mruby.handler-file: /home/blog/redirect.rb
  "blog.unasuke.com:80":
    paths:
      /:
        redirect: https://blog.unasuke.com/
  "blog.unasuke.com:443":
    listen:
      port: 443
      ssl:
        certificate-file: /hoge/path
        key-file: /hoge/path
    paths:
      /:
        file.dir: /hoge/path
    access-log: /hoge/path

access-log: /hoge/path
error-log: /hoge/path
pid-file: /hoge/path
```

あとは、middlemanでbuildした記事を適当なディレクトリに配置してやれば完成となります。(疲れたのでまた後で書きます)

## 参考
### middleman
- [Middleman: 作業を効率化するフロントエンド開発ツール](https://middlemanapp.com/jp/)
- [WordPress から Middleman に移行しました :: log.chocolateboard](http://log.chocolateboard.net/middleman-blog-2015/)
- [初めてのMiddleman：rbenv, bundler 環境でMiddlemanを使ったHello World | Webデザイン、フロントエンド系の技術に関する備忘録 - whiskers](http://whiskers.nukos.kitchen/2015/02/02/middleman-hello-world.html)
- [MiddlemanとPureとその他もろもろでブログ作った : Query OK.](http://ikuwow.website/entry/blog-with-middleman/)
- [ikuwow/query_ok](https://github.com/ikuwow/query_ok)

### ubuntu
- [カスタムOSインストールガイド - Ubuntu 12.04/14.04｜さくらインターネット公式サポートサイト](https://help.sakura.ad.jp/app/answers/detail/a_id/2403/c/235)
- [SSH接続の設定変更方法｜さくらインターネット公式サポートサイト](https://help.sakura.ad.jp/app/answers/detail/a_id/2425)
- [iptablesの設定方法｜さくらインターネット公式サポートサイト](https://help.sakura.ad.jp/app/answers/detail/a_id/2423/c/235)
- [鍵交換方式によるssh接続](http://kazmax.zpp.jp/linux/lin_sshrsa.html)
- [コピペから脱出！iptablesの仕組みを理解して環境に合わせた設定をしよう | OXY NOTES](http://oxynotes.com/?p=6361)
- [さくらVPSにubuntu14.04入れて設定 - Qiita](http://qiita.com/mzuk/items/ca118114f94b1631afef)
- [聖杯を探して - Quest for Holy Grail - : Ubuntu 14.04でSSHの設定](http://holy-grail.blog.jp/archives/1008558891.html)
- [How To Set Up a Firewall Using Iptables on Ubuntu 14.04 | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-iptables-on-ubuntu-14-04)
- [iptablesの設定を保存し起動時に自動的に反映する＠Ubuntu 12.04 server | Mazn.net](http://www.mazn.net/blog/2013/11/02/1308.html)

### h2o
- [H2O](https://h2o.examp1e.net/index.html)
- [h2o/h2o](https://github.com/h2o/h2o)
- [HTTP/2サーバーh2oでサーバプッシュを試してみた | 69log](http://blog.kazu69.net/2015/08/05/try-http2-with-h2o-and-mruby/)
- [h2o + mruby セットアップメモ | harasou.github.io](http://harasou.github.io/2015/08/05/h2o-mruby-%E3%82%BB%E3%83%83%E3%83%88%E3%82%A2%E3%83%83%E3%83%97%E3%83%A1%E3%83%A2/)
- [H2Oとmrubyを使ってIPアドレスベースでアクセス制御しつつリバースプロキシとして動かしてWebサイトをHTTP/2化しよう - 人間とウェブの未来](http://hb.matsumoto-r.jp/entry/2015/07/31/220948)

### mruby
- [mruby/mruby](https://github.com/mruby/mruby)
- [人間とウェブの未来 - 今日からmrubyをはじめる人へ](http://blog.matsumoto-r.jp/?p=3310)
- [Big Sky :: mruby 向け gem コマンド「mgem」を使ってみた。](http://mattn.kaoriya.net/software/lang/ruby/20130104162957.htm)
- [mruby と mgem と rbenv と - Qiita](http://qiita.com/rrreeeyyy/items/aafdb0667e2fbb0caa5c)

### SSL
- [CSRの作成｜さくらインターネット公式サポートサイト](https://help.sakura.ad.jp/app/answers/detail/a_id/2441/)
- [ASCII.jp：え、1年間無料!? ならば僕らもさくらでSSLを導入だ！（前編）](http://ascii.jp/elem/000/001/031/1031771/)
- [H2Oの設定で手こずった点 | だらだらまってん](https://mattenn.fkgt.net/2015/08/h2o%E3%81%AE%E8%A8%AD%E5%AE%9A%E3%81%A7%E6%89%8B%E3%81%93%E3%81%9A%E3%81%A3%E3%81%9F%E7%82%B9/)
