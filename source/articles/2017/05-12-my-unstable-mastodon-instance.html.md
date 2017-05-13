---
title: "mastodonインスタンス、立てたはいいけど不安定"
date: 2017-05-12 23:00 JST
tags:
- programming
- aws
- mastodon
---

![red mastodon](2017/red-mastodon.png)

(2017-05-13 10:53 誤字修正)

## 立てて2週間ほど
こちらになります → [lupinus.bouquet.blue](https://lupinus.bouquet.blue/about/)

## 赤い
やぎにいが一晩でやってくれました。
[dark pink color theme by yagi2 · Pull Request #3 · unasuke/mastodon](https://github.com/unasuke/mastodon/pull/3)

## 不安定とは
### 頻繁に500
ALBが頻繁に500を返すので、ログを見たらpumaが起動直後に死んでるのでインスタンスタイプをt2.mediumに上げたら安定しました。

__before__
![t2.micro](2017/mastodon-instance-t2micro.png)

__after__
![t2.medium](2017/mastodon-instance-t2medium.png)

### streamingが動かない
つらい。

![wss can't connect](2017/mastodon-wss-does-not-work.png)

nodeからpostgresへの接続がうまくいっていないのか、Missing access tokenで怒られている。

![DDoS](2017/mastodon-please-ddos-attach.png)
[https://lupinus.bouquet.blue/@unasuke/59](https://lupinus.bouquet.blue/@unasuke/59)

### 他インスタンスから(他インスタンスの)画像が取得できない
![mastodon rch](2017/mastodon-rch-avatar.png)

![mastodon pawoo](2017/mastodon-pawoo-app-image.png)

S3のACLはpublicにreadできるはずなのに、何故。

## 現状
以下、現状(t2.medium)です。

![mastodon metrics](2017/mastodon-metrics-2017-05-12-23-00.png)
