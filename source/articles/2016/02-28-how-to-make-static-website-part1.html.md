---
title: 静的Webサイトのつくりかた その1
date: 2016-02-28 10:25 JST
tags:
- howto
- Programming
- ruby
- middleman
---

![n0h0.com](2016/n0h0-com.png)

## はじめに
これからの一連の記事は、2016年2月27日に行われた[福井技術者の集い その5](http://fukuitech.connpass.com/event/24445/)での僕の発表した内容を、加筆ならびに修正し、よりわかりやすくまとめ直したものとなります。

## つくりかた記事リスト
- [静的Webサイトのつくりかた その1](/2016/how-to-make-static-website-part1/)
- [静的Webサイトのつくりかた その2](/2016/how-to-make-static-website-part2/)

## 静的Webサイトとは
これから作成する静的Webサイトとは、twitterやfacebookなどのような、アクセスに応じて配信するファイルが変化するようなものではなく、このブログのように、決まったhtml、css、JavaScriptのファイルを返す単純なWebサイトのことを指します。

## 静的Webサイトを作る道具
さて、静的Webサイトをつくるのに必要な道具は、極論を言ってしまえばテキストエディタ以外に必要ありません。

しかし、htmlの手書きは、閉じタグを忘れたりすることもあります。cssの手書きは、デザインによってはベンダープレフィックス(webブラウザによって異なるスタイルの書き分け)などを全て書き並べる必要が出てくることもあるでしょう。
デザインのうえでの共通部分(ヘッダーやフッターなど)も、全てコピーアンドペーストするのでしょうか？

そこで、静的Webサイトを作ってくれるツールを使って、作っていきます。

## 静的Webサイトジェネレーター
静的Webサイトを作ってくれるツールのことを、「静的Webサイトジェネレーター」と呼びます。
[Top Open-Source Static Site Generators - StaticGen](https://www.staticgen.com/)に主要な静的Webサイトジェネレーターが載っていますが、とにかく量が多いです。
一体どれを選べばよいのでしょう。

今回は、このブログでも使っている[middleman](https://middlemanapp.com/jp)を使用します。
採用の理由としては、

- Rubyで書かれている
- 僕に使用経験がある

などです。
同じくRubyで書かれている静的Webサイトジェネレーターに[jekyll](http://jekyllrb.com/)があります。こちらはGitHub pagesという簡単に静的Webサイトを作成できるGitHub上のサービスで採用されているツールです。

## middlemanで静的Webサイトをつくる
### Rubyの環境構築
middlemanはRubyで書かれているので、PCにRubyの実行環境がない場合は、環境を整えてやる必要があります。
Rubyの開発環境構築は、OSごとに書くとそれだけで記事が一つ出来上がるので、ここでは解説サイトへのリンクを掲載するのみに留めます。

- OS XまたはLinuxの場合 : [rbenv を利用した Ruby 環境の構築 ｜ Developers.IO](http://dev.classmethod.jp/server-side/language/build-ruby-environment-by-rbenv/)
- Windowsの場合 : [Rubyアソシエーション: インストール手順(Windows)](http://www.ruby.or.jp/ja/tech/install/ruby/install_win.html)

### middlemanをインストールする
middlemanのインストールには、`gem`というツールを使います。`gem`は、Rubyに標準で組み込まれているライブラリをインストールするコマンドです。
以下のコマンドを実行することで、`gem`を使用したmiddlemanのインストールが行われます。

```shell
$ gem install middleman
```

インストールはこれで終わりです。

### middlemanの初期化
さて、middlemanでは、各種ファイルの置き場所が決まっています。それらの準備をmiddlemanにしてもらうために、以下のコマンドを実行します。(例えば今回作るWebサイトの名前を、hogesiteとします。)

```shell
$ middleman init hogesite
```

このコマンドの実行により、今いるディレクトリに`hogesite`というディレクトリができ、その中に`source`などの幾つかのディレクトリができているはずです。

さて、これからはこの`hogesite`ディレクトリで作業をしていくので、ターミナル上でもcdしておきましょう。

```shell
$ cd hogesite
$ pwd
/home/user/src/hogesite #pathはどうでもよくて、大事なのはカレントディレクトリがhogesiteであるということです
```

gitなどのバージョン管理システムを使用している場合、この段階で一旦コミット等状態の保存をしておくと良いでしょう。

### middlemanの設定
middlemanは標準ではhtmlテンプレートエンジン(htmlを生成するためのファイルの形式)にerbを使用します。しかし、erbはほとんどhtmlのようなものです。また、cssも素のcssを書く必要があります。

htmlテンプレートエンジンにはslimを、altCSSにはscssを使います。これも、僕の個人的な趣味による選択です。

さて、slimとscssを使いたいのですが、そのためにはmiddlemanをインストールした時のように、外部ライブラリのインストールが必要となります。いちいち`gem install`しても良いのですが、それだとこのプロジェクトにはどの外部ライブラリが必要なのか？という情報がわからなくなってしまいます。

そこで、`bundler`を使用します。[Bundler](http://bundler.io/)は、あるプロジェクトの依存関係の記述、またライブラリ間の依存関係の解決を行ってくれる、これもRubyのライブラリです。

以下のコマンドを実行して、bundlerに依存関係を指定するためのファイル、`Gemfile`を生成します。

```shell
$ gem install bundler #すでに入っている場合もあります
$ bundle init         #コマンドの名前がbundlerでないことに注意してください
```

すると、次のようなGemfileが出来上がっていると思います。

```ruby
# A sample Gemfile
source "https://rubygems.org"

# gem "rails"
```

これをひとまず以下のように書き換えます。

```ruby
source "https://rubygems.org"

gem "middleman"
gem "middleman-livereload"

gem "slim"
gem "sass"
```

(`middleman-livereload`はあると便利、という理由で追加しました)

そして、以下のコマンドを実行します。

```shell
$ bundle install
```

これによって、bundlerが`Gemfile`から必要な外部ライブラリを読み取り、ライブラリの間で依存関係を解決してインストールを行い、実際にインストールされたライブラリの情報を`Gemfile.lock`に書き込みます。

そしたら、次のような設定を`config.rb`に記述します。先頭でも末尾でも構いません。

```ruby
set :slim, { format: :html, pretty: :false }
set :sass, { style: :expanded, syntax: :scss }
```

この設定の意味は、[slimの場合はここ](https://github.com/slim-template/slim/blob/master/README.jp.md#%E5%8F%AF%E8%83%BD%E3%81%AA%E3%82%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3)、[sassの場合はここ(英語)](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#options)を参照してください。

### ページを作っていく
さて、実際にページを作っていきたいのですが、その前にmiddlemanが最初に生成したerbをslimに変換してしまいます。
以下のコマンドを実行して、erb2slimというgemをインストールします。(Gemfileに記述する必要はありません。なぜなら、erbをslimに変換するためだけに使うからです。)

```shell
$ gem install erb2slim
```

初期状態では`index.html.erb`と`layouts/layout.erb`がerbファイルとして存在するはずなので、以下のコマンドで変換してしまいます。(`-d`オプションでerbファイルを削除しています)

```shell
$ erb2slim index.html.erb index.html.slim -d
$ erb2slim layouts/layout.erb layouts/layout.slim -d
```

あとは、あなたが好きなようにslimを書き、scssを書き、ページを作っていくだけです。

slimの記法は、[日本語による解説がここ](https://github.com/slim-template/slim/blob/master/README.jp.md)にあります。
scssの記法は、[英語による解説がここ](http://sass-lang.com/guide)にあります。(SassとSCSSを切り替えて表示することができます)

参考までに、僕がmiddlemanを使って作成した静的Webページのコードを以下に掲載します。

- [https://github.com/unasuke/n0h0](https://github.com/unasuke/n0h0) かんたん、1ページのみ
- [https://github.com/unasuke/blog](https://github.com/unasuke/blog) ちょっとふくざつ、このブログのコード

### 確認しつつ書いていく
さて、素晴らしいwebページを書いている途中に、「これって、ブラウザではどんなふうに見えるのだろう？」と思うことはあるはずです。そんな時は、以下のコマンドを実行してみてください。

```shell
$ bundle exec middleman server
```

このコマンドを実行し、ブラウザで`http://localhost:4567`にアクセスすると、実際にどのようなページになるのかをブラウザで確認することができます。(Ctrl+Cで終了します)

また、`middleman-livereload`をインストールした場合は、`config.rb`のどこかに次の設定を書いておけば、`bundle exec middleman server`を実行中にファイルを編集すると、自動的にブラウザが再読込してくれて便利です。

```ruby
configure :development do
  activate :livereload
end
```

### htmlに書き出す
作業も終わり、公開できるものが出来上がったとします。そしたら、次のコマンドを実行します。

```shell
$ bundle exec middleman build
```

このコマンドにより、html、css、JavaScriptが生成されます。このフォルダ以下のファイル群をサーバーに置いて、アクセスできるようにすれば静的Webサイトの出来上がりです。それはまた以降の記事で解説していきます。

### 公式ドキュメント
middlemanの公式ドキュメント(日本語)は以下のURLにあります。わからないことができたら都度見に行くと良いでしょう。

[Middleman: インストール](https://middlemanapp.com/jp/basics/install)

## 次回予告
次回は、ドメインを取ることと、サーバーを借りてssh接続するところまでやりたいと思います。
