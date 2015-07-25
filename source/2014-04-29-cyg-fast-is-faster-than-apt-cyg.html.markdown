---
title: Cygwin使うならcyg-fastも
date: '2014-04-29'
tags:
- cyg-fast
- cygwin
- howto
- windows
---

<h2>Cygwinのパッケージ管理</h2>

Cygwinは、それにインストールするパッケージをsetup.exeによって管理するようになっています。パッケージをインストールしたいときにはいちいちsetup.exeを起動して、あの重いパッケージ一覧の中からインストールするパッケージを指定しなければいけません。
[caption id="attachment_625" align="alignnone" width="300"]<a href="http://unasuke.com/wp/wp-content/uploads/2014/04/cyg-07.png"><img src="http://unasuke.com/wp/wp-content/uploads/2014/04/cyg-07-300x219.png" alt="あの重い一覧" width="300" height="219" class="size-medium wp-image-625" /></a> あの重い一覧[/caption]

<h2>apt-cygの登場</h2>

そこで、aptの使い心地をCygwinにも！ということで開発されたのがapt-cygです。(憶測)
だがこのapt-cygは遅いらしい。(伝聞)

<h2>cyg-fastは速い</h2>

そんな遅い(要検証)apt-cygに代わって、lambdaliceさんによって開発されたのが<a href="https://github.com/lambdalice/cyg-fast" target="_blank">cyg-fast</a>です。名前にfastなんて入っているあたり、速さには自信があるように感じます。

<h2>cyg-fastのインストール</h2>

まずは、cyg-fastが動作するのに必要なパッケージをsetup.exeでインストールします。

<ul>
    <li>aria2c</li>
    <li>tar</li>
    <li>gawk</li>
</ul>

これらを検索してインストールする必要があります。setup.exeが必要なのはここまでです。もう捨てちゃいましょう。

次にgit cloneなりzipで落とすなりして本体を手に入れます。
<a href="https://github.com/lambdalice/cyg-fast" target="_blank">lambdalice/cyg-fast</a>

そしたら<code>cyg-fast</code>を<code>C:\cygwin\bin</code> (cygwinのインストールディレクトリ\bin)にコピーします。(もしくはPATHが通っているところにコピー)
最後に、実行権限を付与します。

<pre class="theme:classic lang:default highlight:0 decode:true " >$ chmod chmod +x /cygdrive/c/cygwin/bin/cyg-fast</pre>

<h2>cyg-fastの使い方</h2>

最初に起動したら、

<pre class="theme:classic lang:default highlight:0 decode:true " >$ cyg-fast build-deptree</pre>

を実行します。これにより依存関係のアレがソレされて速いっぽいです。
ただ、毎回聞いてくるので、rapidオプションをaliasしておくと良い(作者談)そうです。

<pre class="theme:classic lang:default highlight:0 decode:true " >$ alias cyg-fast='cyg-fast -r'</pre>

<h3>パッケージを探す</h3>

<pre class="theme:classic lang:default highlight:0 decode:true " >$ cyg-fast find ruby</pre>

<h3>パッケージの情報を見る</h3>

<pre class="theme:classic lang:default highlight:0 decode:true " >$ cyg-fast show ruby</pre>

<h3>パッケージをインストールする</h3>

<pre class="theme:classic lang:default highlight:0 decode:true " >$ cyg-fast install ruby</pre>

<h3>パッケージを削除する</h3>

<pre class="theme:classic lang:default highlight:0 decode:true " >$ cyg-fast remove ruby</pre>

使えるコマンドは引数なしで実行すると見れます。だいたいapt-cygと同じです。

<h2>本当にcyg-fastはapt-cygよりも速いのか？</h2>

計測してみましょう。どちらもデータベースは更新済みで、最新版を落とすのではなくキャッシュからの検索の時間を測りました。

まずはapt-cygでやってみます。

<pre class="theme:classic lang:default highlight:0 decode:true " >
$ time apt-cyg -u find ruby
Working directory is /setup
Mirror is ftp://mirror.mcs.anl.gov/pub/cygwin
gpg: WARNING: unsafe permissions on homedir `/setup/.apt-cyg'
gpg: WARNING: unsafe permissions on homedir `/setup/.apt-cyg'

Searching for installed packages matching ruby:

Searching for installable packages matching ruby:
ruby
ruby-caca
ruby-debuginfo
ruby-doc
ruby-json
ruby-minitest
ruby-rake
ruby-rdoc
ruby-tcltk
subversion-ruby
weechat-ruby

real    0m0.304s
user    0m0.090s
sys     0m0.197s
</pre>

次にcyg-fastはどうでしょう。

<pre class="theme:classic lang:default highlight:0 decode:true " >
$ time cyg-fast -r find ruby
Working directory is /setup
Mirror is ftp://mirror.mcs.anl.gov/pub/cygwin

Searching for installed packages matching ruby:

Searching for installable packages matching ruby:
ruby
ruby-caca
ruby-debuginfo
ruby-doc
ruby-json
ruby-minitest
ruby-rake
ruby-rdoc
ruby-tcltk
subversion-ruby
weechat-ruby

real    0m0.140s
user    0m0.000s
sys     0m0.151s
</pre>

約半分です。やっぱりcyg-fastは速いですね。
