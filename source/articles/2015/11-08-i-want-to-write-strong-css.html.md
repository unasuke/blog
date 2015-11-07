---
title: つよいCSSを書きたい
date: 2015-11-08 01:53 JST
tags:
- programming
- css
- diary
- poem
---

![読んだ本](2015/strong-css-books.jpg)

## What's "つよい"
<p data-height="500" data-theme-id="20567" data-slug-hash="OyEoKB" data-default-tab="css" data-user="unasuke" class='codepen'>See the Pen <a href='http://codepen.io/unasuke/pen/OyEoKB/'>verbose style sheet</a> by Yusuke Nakamura (<a href='http://codepen.io/unasuke'>@unasuke</a>) on <a href='http://codepen.io'>CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>
例えば上のようなCSSは、bootstrapも使っていない、Sassも使っていないので、次のように書き直せると思う。めんどいのでSlimも使う。

<p data-height="500" data-theme-id="20567" data-slug-hash="bVxBWO" data-default-tab="css" data-user="unasuke" class='codepen'>See the Pen <a href='http://codepen.io/unasuke/pen/bVxBWO/'>better style sheet</a> by Yusuke Nakamura (<a href='http://codepen.io/unasuke'>@unasuke</a>) on <a href='http://codepen.io'>CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>
さて、これも`.box`の中のclassにも`.box`が先頭についていて冗長、共通化できそうなものを切り出してこう書くとしたら。

<p data-height="500" data-theme-id="20567" data-slug-hash="gadLvd" data-default-tab="css" data-user="unasuke" class='codepen'>See the Pen <a href='http://codepen.io/unasuke/pen/gadLvd/'>more better style sheet</a> by Yusuke Nakamura (<a href='http://codepen.io/unasuke'>@unasuke</a>) on <a href='http://codepen.io'>CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>

さて3段階にわたってCSSを綺麗にしたつもりだが、まだまだ改善できるところがあるかもしれない。「つよいCSS」というのは、破綻しにくく、変更に強く、とにかくつよいCSSのことだ。

## CSSをもりもり書いたここ数週間
ここ数週間は、ひたすらCSSを(Sassを)もりもり書いていて、とにかく上に書いたようなことを意識しながら作業していた。途中で以下の本を買ってもらって読んだ。

<a rel="nofollow" href="http://www.amazon.co.jp/gp/product/4048660705/ref=as_li_ss_il?ie=UTF8&camp=247&creative=7399&creativeASIN=4048660705&linkCode=as2&tag=yusuke199403-22"><img border="0" src="https://ws-fe.amazon-adsystem.com/widgets/q?_encoding=UTF8&ASIN=4048660705&Format=_SL250_&ID=AsinImage&MarketPlace=JP&ServiceVersion=20070822&WS=1&tag=yusuke199403-22" ></a><img src="https://ir-jp.amazon-adsystem.com/e/ir?t=yusuke199403-22&l=as2&o=9&a=4048660705" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

<a rel="nofollow" href="http://www.amazon.co.jp/gp/product/4797384557/ref=as_li_ss_il?ie=UTF8&camp=247&creative=7399&creativeASIN=4797384557&linkCode=as2&tag=yusuke199403-22"><img border="0" src="https://ws-fe.amazon-adsystem.com/widgets/q?_encoding=UTF8&ASIN=4797384557&Format=_SL250_&ID=AsinImage&MarketPlace=JP&ServiceVersion=20070822&WS=1&tag=yusuke199403-22" ></a><img src="https://ir-jp.amazon-adsystem.com/e/ir?t=yusuke199403-22&l=as2&o=9&a=4797384557" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

作業の途中で読んだので、CSSの書き方がページによって変わってしまった(後でなんとかした)。とはいえまだ読みきれてはいないし、書き方を意識したとはいえど、まだまだな点も多い。

classの名前も悩む。どこからどこまでを1つのclassでまとめるべきか判断がつきにくい。複数のページで共通化できるのはどの要素だろうか。これはこのページ限定のスタイルだろうか。paddingであるべきかmarginであるべきか。そもそもこれはbootstrapで用意されているから書く必要はなかった。思い通りの値にならないと思ったらあっちのスタイルが適用されていた。こっちのグレーとそっちのグレーは違う色だった……

Photoshopとエディタとブラウザを何度も行ったり来たり、見比べたり、カラーコードをコピペしたり。とにかく大変だった。でも見やすくなったと思うし、キレイになった。

## CSSの設計
BEMやSMACSSなどのCSSの設計についての指針はある。だが、専属のフロントエンドエンジニアがいない現状では導入は難しい。bootstrapを使っておおまかにレイアウトし、それなりにページごとに分けたSassで無難な名前のclassでスタイルを書いている。何人もがCSSを書いているので、書き方に差異もある。最近書いていくぶんには破綻もあまりないけど、消しきれていない昔のCSSのために打ち消すスタイルもあったりなかったり。

## :muscle: CSS :muscle:
CSS難しい。いっぱい書けばできるようになるんだろうか。
