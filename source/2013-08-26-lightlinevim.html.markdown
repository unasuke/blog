---
title: lightline.vimの導入
date: '2013-08-26'
tags:
- howto
- vim
---

<h2>でたよvim初心者が</h2>

どうも、<a href="https://github.com/bling/vim-airline">vim-airline</a>の導入に手こずって放置する程度のvim力の持ち主ことうなすけです。
さて、Qiitaをチェックしているとまた良さげな<a href="https://github.com/itchyny/lightline.vim">lightline.vim</a>なるものを見つけてまあ早速導入しました。そんな時間ないけど。
<br>

<h2>どんな感じになるのか</h2>

例えばvim-airlineを導入直後だとこんな表示です。
[caption id="attachment_220" align="alignnone" width="300"]<a href="http://unasuke.com/wp/wp-content/uploads/2013/08/Screen-Shot-2013-08-26-at-20.31.32.png"><img src="http://unasuke.com/wp/wp-content/uploads/2013/08/Screen-Shot-2013-08-26-at-20.31.32-300x208.png" alt="fontが……" width="300" height="208" class="size-medium wp-image-220" /></a> fontが……[/caption]
fontがおかしいっていうか。なんかスッキリしない。

まず<a href="https://github.com/Shougo/neobundle.vim">NeoBundle</a>を導入する必要があったりしますがまあ今はそれについては置いといて。
こうして
[caption id="attachment_221" align="alignnone" width="300"]<a href="http://unasuke.com/wp/wp-content/uploads/2013/08/Screen-Shot-2013-08-26-at-20.32.24.png"><img src="http://unasuke.com/wp/wp-content/uploads/2013/08/Screen-Shot-2013-08-26-at-20.32.24-300x207.png" alt="こうする" width="300" height="207" class="size-medium wp-image-221" /></a> こうする[/caption]
<code>:NeoBundleClean</code>
して
<code>:NeoBundleInstall</code>
して
こうじゃ
[caption id="attachment_224" align="alignnone" width="300"]<a href="http://unasuke.com/wp/wp-content/uploads/2013/08/Screen-Shot-2013-08-26-at-20.38.27.png"><img src="http://unasuke.com/wp/wp-content/uploads/2013/08/Screen-Shot-2013-08-26-at-20.38.27-300x208.png" alt="まちがえてた" width="300" height="208" class="size-medium wp-image-224" /></a> まちがえてた[/caption]
おお……なんかそれっぽい。

あとはカラースキームをsolarizedにしたいんだけどreadmeが英語の上にvim力低いのでよくわかりません。どなたか教えてください。見返りはないです。

<h2>追記と訂正</h2>

貼る画像間違えてた。あと、.vimrcにこう書けばsolarizedになる。焦ったらだめね。

<pre class="lang:default decode:true " title=".vimrc" >NeoBundle 'itchyny/lightline.vim'

let g:lightline = {
    \ 'colorscheme' : 'solarized' ,
    \}

</pre>

作者のitchynyさんありがとうございます。
