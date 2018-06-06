---
title: 'RubyKaigi 2018にhelperとして参加しました'
date: 2018-06-06 20:30 JST
tags: 
- diary
- ruby
---

![RubyKaigi 2018 Matz's keynote](2018/rubykaigi-2018.jpeg)


ここのところ毎年参加しているRubyKaigiですが、今回はhelperとして参加してきました。


<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">RubyKaigi 2018では当日の運営のお手伝いをしてくださる方を募集しています！ <a href="https://t.co/869qrPEr7Q">https://t.co/869qrPEr7Q</a> <a href="https://twitter.com/hashtag/rubykaigi?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigi</a></p>&mdash; RubyKaigi (@rubykaigi) <a href="https://twitter.com/rubykaigi/status/984418467494309889?ref_src=twsrc%5Etfw">2018年4月12日</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

helperとしての参加表明にも記入したのですが、当日はネットワーク班の一員として、参加者の皆様が会期中に快適にインターネットを使用することができるようがんばりました。

## ネットワーク班の主な仕事内容
作業内容については、昨年のsorahの記事に詳しいのでそちらを参照するほうがよいでしょう。大体同じです。

[RubyKaigi 2017 で Wi-Fi を吹いてきた #rubykaigi - diary.sorah](https://diary.sorah.jp/2017/09/25/rubykaigi2017-wifi)

前日と最終日に関しては、多少は体力勝負な部分があることは否定できません。会場内を歩きまわって、ケーブルを回収したり機器を運搬するのは、結構大変です。汗だくになりました。

## 感想
ネットワーク班で共有されていた、APへの接続数、インターネットへのトラフィック量などのダッシュボードを見ていると、人の動きが可視化されて、見ていてとても楽しかったです。

こういうイベントのスタッフとしての参加は、普段参加しているとわからないイベントの裏側で、何が起こっているのかがわかり、そしてそのイベント自体を自分達で支えているんだという実感が得られ、何とも言えない高揚感がありました。来年もネットワーク班の募集があれば、是非力になりたいと思いますが、どうなるでしょうね。あわよくばCFPが採択されることを願っていますが……

よくない点があるとすれば、helper参加する場合はシェアハウスでの共同宿泊はやめたほうがいいかな、と感じました。スタッフは集合時間が朝早く、みんなと起床・出発する時刻がずれるためです。次回もやんちゃハウスがあるとしても、おそらく僕はそっちには参加しないでしょう。


## 余談
以前bugs.ruby-lang.orgに登録して停滞(？)していた、僕が投げたpatchについてコミッターであるnaruseさんに直接現状を聞いてみたところ、翌日にはmergeされていました。

[Feature #14688: Net::HTTPResponse#value raises "Net::HTTPServerException" in 4xx response - Ruby trunk - Ruby Issue Tracking System](https://bugs.ruby-lang.org/issues/14688)

このまま何事もなければ2.6.0では僕の書いたコードが動くということになり感無量です。

RubyKaigiでは、Rubyのコミッターに直接合うことができるという非常に稀有なイベントであると思います(しかも目立つTシャツを着ている)。

これからも、やっていきです。
