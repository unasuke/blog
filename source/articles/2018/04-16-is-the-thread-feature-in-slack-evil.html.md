---
title: "SlackのThreadは邪悪かどうか"
date: 2018-04-16 21:58 JST
tags: 
- diary
- slack
---

![slackのthreadがどこかわからなかった場合](2018/slack-thread.png)

## SlackのThreadは便利
Slack、便利ですよね。見ない日はありません。

2017年にSlackに導入されたThread機能は、1つの話題に関する発言をまとめることができ、それが無かったころに比べて意見のふりかえりがとても容易になりました。

しかし、最近はそうでもないのかな、と思いはじめています。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">Slackのthread、邪悪な気がしてきた</p>&mdash; うなすけ (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/status/983961913628372999?ref_src=twsrc%5Etfw">2018年4月11日</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## 理由その1 中でどのような会話がされているのかわからない
ほぼこれに尽きます。

SlackのThreadは、それが存在することを見逃しやすいです。また内部でどのような会話がされているかを知るには、そのスレッド内で発言していないと(通知が来る状態になっていないと)わかりません。

あるThreadにどれだけ有用な情報が投稿されていようと、知っていたなら数秒で答えられるような問題に対して何十分も議論が続けられていようと、それが自分の気づいてないThreadでの会話であれば為す術がありません。

これは、[情報共有おじさん - ローファイ日記](http://udzura.hatenablog.jp/entry/2014/04/03/120015) のjune29さんによるはてブコメントの


> 「自分に届かなかった情報を、そういう情報があるだろうと想像して、あらためて取得しにいくコスト」は「届いた情報を無視するコスト」に比べて圧倒的に高いので、基本は届けておいて、各自が適宜で無視、が好き。

[http://b.hatena.ne.jp/entry/189105486/comment/june29](http://b.hatena.ne.jp/entry/189105486/comment/june29)

に僕の言いたいことが全てまとめられています。

辛うじて、”Also send to #channel" というチェックを入れれば、属するchannelにもう同時に投稿することはできます。しかし、これを常時ONにするというのはThreadの思想に反するので厳しいでしょう。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">SlackのThread、知らん間に話伸びてるのに気づかないことが多いからやっぱり好きじゃないな</p>&mdash; ゆーけー / Yuki AKAMATSU (@ukstudio) <a href="https://twitter.com/ukstudio/status/985776745763581952?ref_src=twsrc%5Etfw">2018年4月16日</a></blockquote>

## 理由その2 テキストによるコミニュケーションしかできない
SlackのThreadでは、画像やtext snippetの投稿ができません。たとえば障害対応でThreadでの会話が始まってしまったとき、アクセスログやスクリーンショットはThreadには投稿できないので、やっぱりchannelに戻って投稿するしかありません。

## 僕がどうしているか
### こまめに Also send to #channel する
ここにThreadがありますよ、ということをわかってもらうために、Thread内でもchannel全体に発信したほうがよい投稿に関しては"Also send to #channel"のチェックを入れて投稿しています。

### むしろ一時的なchannelを作る

> いずれ障害や問題は解決するので、その時点でそのチャンネルはアーカイブして社内 Wiki に簡単な概要を作成する。概要には当然チャットログへのリンクを貼っておく。

[最近ユビレジではじめた Slack チャンネルの新しい運用 - Diary](https://diary.app.ssig33.com/270)

始めからある程度の投稿がされることがわかっている議題に関しては、最近僕は積極的にこの運用をしていくことにしています。(例として障害対応などのインフラオペレーションログ)

## まとめ
とはいえThreadは便利なので、これからも確実に使われていくでしょう。Threadを使う人が、**このThreadの存在に気づいていない人がいる** ということに気を配ることができれば、不幸な情報の取り零しも僅かなものになっていくと思います。

