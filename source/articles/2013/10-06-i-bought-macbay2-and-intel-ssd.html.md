---
title: Macbay2とSSDでMacBookPro延命措置
date: '2013-10-06'
tags:
- howto
- mac
---

## Macbay2とは
秋葉館が販売しているHDD(SSD)マウンタ。光学ドライブの場所にHDD(SSD)を設置できる。
[光学ドライブスペース用HDD/SSDマウンタ Macbay2 RGH25BAY2-001](http://www.akibakan.com/BCAK0062822/)

これを買ってSSDにOS Xをインストールし、延命を図ろうという作成。


画像が多いです。

## 作業
まずはSSDとMacbay2を用意。裏蓋を開ける。
![裏蓋](2013/macbay2-01.jpg)

各コネクタを外す。ついてきたヘラでやったほうがいいかもしれない。赤黒はヘラで持ち上げ、ただの黒い線は引っ張る。SATAケーブルはヘラでうえに持ち上げる。
![各コネクタを外す](2013/macbay2-02.jpg)
![各コネクタを](2013/macbay2-03.jpg)
![外す](2013/macbay2-04.jpg)

(多分)スピーカーを外す。ただ斜め上に持ち上がるだけで完全には外れない。無理に引っ張るとどこかしら断線する雰囲気。
![スピーカーを](2013/macbay2-05.jpg)
![外す](2013/macbay2-06.jpg)

光学ドライブを固定しているネジ3つを外す。
![ネジ](2013/macbay2-07.jpg)
![3つを](2013/macbay2-08.jpg)
![外す](2013/macbay2-09.jpg)

Macbay2にSSDを取り付け、光学ドライブから外した固定用の部品とケーブルをつける。SSDをもともとHDDがあった場所に入れる例もwebでよく目にするが、今HDDがある場所には衝撃を吸収する部品があるのでHDDは動かさない。
![いろいろ](2013/macbay2-10.jpg)
![つける](2013/macbay2-11.jpg)

光学ドライブと同じようにMacbay2を固定……と行きたかったが、ネジの長さが足りない。Macbay2に細工もしてみたがどうやら無理。Macbay2についてきたネジと、純正のネジの比較がこれ。
![左の小さいのが純正 右の大きいのがMacbay2付属](2013/macbay2-12.jpg)
左の小さいのが純正、右の大きいのがMacbay2付属

__こんなもんねじ込めるか馬鹿__
しかもついてきたのタッピングビスだしふざけてる。
しかたなくこうした。
![セロハンテープは危険。後が残るかも。これはクリアテープ。](2013/macbay2-13.jpg)
セロハンテープは危険。後が残るかも。これはクリアテープ。

上の写真では終わっているが、あらゆるネジや部品を元通りにして蓋をしめる。


## OS X Lion install battle
OS Xの再インストールはネットワーク経由で行う。起動時に「⌘+R」でインターネットリカバリを行う。
![OS X再インストール](2013/macbay2-14.jpg)

SSDを初期化してからOS Xをインストールすること。

あとはよしなに。

## ちなみに
僕のインストールの様子
<blockquote class="twitter-tweet"><p>まずはここから <a href="https://twitter.com/search?q=%23OSXinstallbuttle&src=hash">#OSXinstallbuttle</a> <a href="http://t.co/6AphdrwDox">pic.twitter.com/6AphdrwDox</a></p>&mdash; うなすけ(EXC_BAD_ACCESS) (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/statuses/386500671857360896">October 5, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<blockquote class="twitter-tweet"><p>主に日本語を使用します <a href="https://twitter.com/search?q=%23OSXinstallbuttle&src=hash">#OSXinstallbuttle</a> <a href="http://t.co/9YhzB69j3v">pic.twitter.com/9YhzB69j3v</a></p>&mdash; うなすけ(EXC_BAD_ACCESS) (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/statuses/386500959469187073">October 5, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<blockquote class="twitter-tweet"><p>まず消去しちゃいましょう <a href="https://twitter.com/search?q=%23OSXinstallbuttle&src=hash">#OSXinstallbuttle</a> <a href="http://t.co/QwbnxyiPUe">pic.twitter.com/QwbnxyiPUe</a></p>&mdash; うなすけ(EXC_BAD_ACCESS) (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/statuses/386501331365539841">October 5, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<blockquote class="twitter-tweet"><p>戸惑うな <a href="https://twitter.com/search?q=%23OSXinstallbuttle&src=hash">#OSXinstallbuttle</a> <a href="http://t.co/HSbinJXbJg">pic.twitter.com/HSbinJXbJg</a></p>&mdash; うなすけ(EXC_BAD_ACCESS) (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/statuses/386501623670792192">October 5, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<blockquote class="twitter-tweet"><p>凛々しい <a href="https://twitter.com/search?q=%23OSXinstallbuttle&src=hash">#OSXinstallbuttle</a> <a href="http://t.co/rMjQVuszXX">pic.twitter.com/rMjQVuszXX</a></p>&mdash; うなすけ(EXC_BAD_ACCESS) (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/statuses/386501813655990272">October 5, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<blockquote class="twitter-tweet"><p>お <a href="https://twitter.com/search?q=%23OSXinstallbuttle&src=hash">#OSXinstallbuttle</a> <a href="http://t.co/EKGV5xj9Z9">pic.twitter.com/EKGV5xj9Z9</a></p>&mdash; うなすけ(EXC_BAD_ACCESS) (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/statuses/386507471881138177">October 5, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<blockquote class="twitter-tweet"><p>きましたよ <a href="https://twitter.com/search?q=%23OSXinstallbuttle&src=hash">#OSXinstallbuttle</a> <a href="http://t.co/AuBrX81IjQ">pic.twitter.com/AuBrX81IjQ</a></p>&mdash; うなすけ(EXC_BAD_ACCESS) (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/statuses/386509027158401025">October 5, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<blockquote class="twitter-tweet"><p>はぁ…… <a href="https://twitter.com/search?q=%23OSXinstallbuttle&src=hash">#OSXinstallbuttle</a> <a href="http://t.co/BzXiKoLva3">pic.twitter.com/BzXiKoLva3</a></p>&mdash; うなすけ(EXC_BAD_ACCESS) (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/statuses/386518352815861761">October 5, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

2013-12-26 リンクURLを訂正
