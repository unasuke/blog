---
title: MacでC/C++を書いてコンパイルするなら？(授業の課題程度)
date: '2014-01-30'
tags:
- howto
- mac
- programming
---

<h2>コンパイラ</h2>

Macで使えるC/C++のコンパイラはgccとclangの2種類ある。どちらがどう優れているかは授業の課題軽度では比較できない。
あえておすすめするならAppleが力を入れているclangがいいのではないだろうか。

<h3>インストール</h3>

まずXcodeを立ち上げ、「Xcode」から「Preferences...」をクリックする。
<a href="http://unasuke.com/wp/wp-content/uploads/2014/01/1e284b968dac92dd1cd757b3e8c6cd7c.png"><img src="http://unasuke.com/wp/wp-content/uploads/2014/01/1e284b968dac92dd1cd757b3e8c6cd7c.png" alt="スクリーンショット 2014-01-30 12.23.33" width="512" height="452" class="alignnone size-full wp-image-442" /></a>

設定画面が開くので、「Downloads」から「Command Line Tools」をダウンロード&amp;インストールする。これでOK。
<a href="http://unasuke.com/wp/wp-content/uploads/2014/01/7dd4c3f74f006b34bb1d70d7adebd54e.png"><img src="http://unasuke.com/wp/wp-content/uploads/2014/01/7dd4c3f74f006b34bb1d70d7adebd54e.png" alt="名称未設定" width="749" height="460" class="alignnone size-full wp-image-443" /></a>

<h2>エディタ</h2>

<a href="http://blog.supermomonga.com/articles/vim/startdash-with-mac.html" target="_blank">Macを購入したら絶対に導入したい！私が3年間で厳選した超オススメアプリ10選！</a>
この記事に載っていないものでおすすめしたいのが<a href="http://www.mimikaki.net/" target="_blank">mi</a>である。
モードを設定すれば自動インデントもしてくれるし色分けもしてくれる。軽いのでささっと手軽なプロクラムを書くには向いているのではないだろうか。

<h2>コンパイルと実行</h2>

ここではclangのやり方で書くが、「clang」をそのまま「gcc」と書き換えても動く。
たとえばこんなコードを書いたとする。

<pre class="lang:c decode:true " title="Test.c" >#include&lt;stdio.h&gt;
int main( void )
{
    printf( "Hello World! );
    return 0;
}</pre>

これをコンパイルするには、

<pre class="lang:sh highlight:0 decode:true " >$ clang Test.c </pre>

とタイプする。
するとこんなエラーが出る。

<pre class="lang:sh highlight:0 decode:true " >$ clang Test.c 
Test.c:4:13: warning: missing terminating '"' character [-Winvalid-pp-token]
    printf( "Hello World! );
    ^
Test.c:4:13: error: expected expression
1 warning and 1 error generated.</pre>

これを繰り返して何も表示されなくなったらコンパイル成功である。

<pre class="lang:c decode:true " title="Test.c" >
#include&lt;stdio.h&gt;
int main( void )
{
    printf( "Hello World!\n" );
    return 0;
}</pre>

実行するには、

<pre class="lang:sh highlight:0 decode:true " >$ ./a.out </pre>

と入力する。すると

<pre class="lang:sh highlight:0 decode:true " >
$ ./a.out 
Hello World!
$ </pre>

こうなる。
また、ここで-oオプションを使って、実行ファイルの名前を好きに設定できる。

<pre class="lang:sh highlight:0 decode:true " >$ clang Test.c -o Test
$ ./Test 
Hello World!
$ </pre>

C++をコンパイルするときは、コマンドを「clang++」(g++)に書き換える。
以上！
