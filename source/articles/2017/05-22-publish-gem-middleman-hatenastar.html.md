---
title: "middleman-hatenastarというgemをつくりました"
date: 2017-05-22 18:23 JST
tags:
- programming
- ruby
- gem
- middleman
---

![howto page](2017/hatenastar-howto-page.png)

## つくりました :star2: :star2: :star2:
<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr"><a href="https://twitter.com/yu_suke1994">@yu_suke1994</a> あなたとはてなスター、いますぐ設置 <a href="https://t.co/sihB5jvGDx">https://t.co/sihB5jvGDx</a></p>&mdash; あそなす (@asonas) <a href="https://twitter.com/asonas/status/864693025548550144">2017年5月17日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

ということがあり、つくりました。

[Tokyo Middleman Meetup#3 - connpass](https://tokyo-middleman-meetup.connpass.com/event/55477/) というイベントを開催したのですが、そこでのLTでlive cordingをして、日曜から清書してできあがり、という経緯があったりします。

## つかいかた
### はてなスターのトークンを取得する
[はてなスターをブログに設置するには - はてなスター日記](http://d.hatena.ne.jp/hatenastar/20070707)

を参考に、トークンを取得してください。

### middlemanの設定でhatenastarを有効にする

これは例です。詳しくは [はてなスターをブログに貼り付ける - はてなスター日記](http://d.hatena.ne.jp/hatenastar/20070707/1184453490) を読んでください。

```ruby
activate :hatenastar,
  token: 'your token',
  uri: 'h2 a',
  title: 'h2 a',
  container: 'h2',
  entry_node: 'section.article'
```

### layoutにhatenastar_tagを設置する
`<head>`のどこかで `= hatenastar_tag` を呼び出して完了です。

また、引数でconfig.rbの設定値を上書くこともできます。

```ruby
= hatenastar_tag(entry_node: 'div.article')
```

## 既知の問題点
### 複数要素に対応していない
エントリの複数指定、1エントリ内での複数スター表示にまだ対応できていません。pull requestを送ってくれてもいいんですよ :question:

## よろしくお願いします
とりあえずスター連打してください。
