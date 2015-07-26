---
title: lightline.vimの導入
date: '2013-08-26'
tags:
- howto
- vim
---

## でたよvim初心者が

どうも、[vim-airline](https://github.com/bling/vim-airline)の導入に手こずって放置する程度のvim力の持ち主ことうなすけです。
さて、Qiitaをチェックしているとまた良さげな[lightline.vim](https://github.com/itchyny/lightline.vim)なるものを見つけてまあ早速導入しました。そんな時間ないけど。
<br>

## どんな感じになるのか

例えばvim-airlineを導入直後だとこんな表示です。
![フォントがおかしい](lightline-install-01.png)
fontがおかしいっていうか。なんかスッキリしない。

まず[NeoBundle](https://github.com/Shougo/neobundle.vim)を導入する必要があったりしますがまあ今はそれについては置いといて。
こうして
![こうして](lightline-install-02.png)
`:NeoBundleClean`
して
`:NeoBundleInstall`
して
こうじゃ
![こうじゃ](lightline-install-03.png)
おお……なんかそれっぽい。

あとはカラースキームをsolarizedにしたいんだけどreadmeが英語の上にvim力低いのでよくわかりません。どなたか教えてください。見返りはないです。

## 追記と訂正

貼る画像間違えてた。あと、.vimrcにこう書けばsolarizedになる。焦ったらだめね。

```vim
NeoBundle 'itchyny/lightline.vim'

let g:lightline = {
    \ 'colorscheme' : 'solarized' ,
    \}
```

作者のitchynyさんありがとうございます。
