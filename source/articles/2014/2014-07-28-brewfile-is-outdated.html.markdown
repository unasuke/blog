---
title: Brewfileで管理するのはもうオワコン
date: '2014-07-28'
tags:
- homebrew
- info
- ruby
---

<a href="http://unasuke.com/wp/wp-content/uploads/2014/07/Bundle.png"><img src="http://unasuke.com/wp/wp-content/uploads/2014/07/Bundle.png" alt="Bundle" width="650" height="426" class="alignnone size-full wp-image-742" /></a>

<h2>Brewfileでパッケージ管理していたあの頃</h2>

以前、こんな記事を書いた。
<a href="http://unasuke.com/howto/2014/homebrew-and-brewfile-and-homebrew-cask/" title="Homebrewとbrewfileとhomebrew-caskでMacの環境構築" target="_blank">Homebrewとbrewfileとhomebrew-caskでMacの環境構築</a>
Brewfileを使えば、

<pre class="theme:classic font-size:17 line-height:19 lang:sh decode:true " >$ brew bundle Brewfile</pre>

これ一発で環境構築ができるという便利なコマンドだ。

<h2>今は もう うごかない その $ brew bundle</h2>

今、Homebrewで

<pre class="theme:classic font-size:17 line-height:19 lang:sh decode:true " >$ brew bundle Brewfile</pre>

すると、冒頭画像のように

<blockquote>
Warning: brew bundle is unsupported and will be replaced with another,
incompatible version at some point.
Please feel free volunteer to support it in a tap.
</blockquote>

と怒られてしまう。
<a href="https://github.com/Homebrew/homebrew/issues/30815" target="_blank">What? "Warning: brew bundle is unsupported ..." #30815</a>

<a href="http://unasuke.com/wp/wp-content/uploads/2014/07/Screen-Shot-2014-07-28-at-2.06.51-PM.png"><img src="http://unasuke.com/wp/wp-content/uploads/2014/07/Screen-Shot-2014-07-28-at-2.06.51-PM.png" alt="Screen Shot 2014-07-28 at 2.06.51 PM" width="570" height="175" class="alignnone size-full wp-image-743" /></a>

<h2>どうすればいいのか</h2>

方法としては、2つある。

<ol>
<li>警告にもあるように、同じような働きをするコマンドを作ってtapする</li>
<li>Brewfileをシェルスクリプト化する</li>
</ol>

1はちょっとハードル高い。
じゃあ、2かな。

Brewfileなんて、本質はbrewがないだけのシェルスクリプトみたいなものだ。ということで、こんなのを作った。

<pre class="font-size:17 line-height:19 lang:ruby decode:true " title="Brew2sh" >#!/usr/local/bin/ruby
File::open( ARGV[0] ) {|brewfile|
  print "#!/bin/sh"
  brewfile.each_line {|line|
    if line[0] == "#"|| line.size == 1 then
      print line
    else
      print "brew " + line
    end
  }
}</pre>

<a href="https://gist.github.com/unasuke/465d360e73a9718d8980" target="_blank">Gistにもあるよ</a>

こいつにBrewfileを渡せば、標準出力にシェルスクリプトとして出てくるので、適当な名前で保存して実行してやれば良い。

<pre class="theme:classic font-size:17 line-height:19 lang:sh decode:true " >$ Brew2sh Brewfile &gt; brewfile.sh
$ chmod +x brewfile.sh
$ ./brewfile.sh</pre>
