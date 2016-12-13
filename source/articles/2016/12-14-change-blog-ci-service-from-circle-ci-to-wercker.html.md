---
title: "このblogのCIをCircle CIからwerckerに変更しました"
date: 2016-12-14 00:00 JST
tags:
- programming
- wercker
- middleman
- yac
- advent_calendar
---

![wercker](2016/wercker.png)

## やぎすけ Advent Calendar
[やぎすけ Advent Calendar 2016 - Adventar](http://www.adventar.org/calendars/1800)

14日目です。大半がやぎにいなのでプレッシャァ。

## Circle CIへの不満
__遅い__

無料のci serviceに言う文句じゃない気もしますが、とにかくtestがpassするまでの時間が長いと感じていました。

たとえばRubyの2.3.3など、わりと新しめのversionを使おうとすると毎回インストールを実行するので時間がかかります。

![インストールの様子](2016/wercker-circleci-build-environment.png)

## werckerなら速そう
そこでwerckerを選択しました。werckerはciを実行する環境がdocker containerの中になるので、適切なcontainerを
選んでやれば環境構築の手間は最低限で済みます。

## werckerでmiddlemanのbuild
こちらになります。

```yaml
box: ruby:2.3.3
init:
build:
  steps:
    - install-packages:
        packages: nodejs
    - bundle-install
    - script:
        name: middleman build
        code: bundle exec middleman build
deploy:
  steps:
    - install-packages:
        packages: nodejs rsync
    - bundle-install
    - add-ssh-key:
        host: unasuke.com
        keyname: deploy
    - add-to-known_hosts:
        hostname: unasuke.com
        fingerprint: $FINGERPRINT
    - script:
        name: middleman build
        code: bundle exec middleman build
    - script:
        name: middleman deploy
        code: bundle exec middleman deploy
```

master branchでciが実行された場合は、`deploy` pipelineが実行されるようにしています。

![workflow設定](2016/wercker-wercker-workflow.png)

## どのくらい速くなったのか
### build ci
deployが発生しない、通常のciが終わるまでに要した時間を適当に5つ抜き出してみました。

#### circle ci
- 02:53
- 03:19
- 02:59
- 04:45
- 03:12

だいたい3分間といったところ。

### wercker
- 01:04
- 00:57
- 01:01
- 00:59
- 01:03

ほぼ1分間という感じ。

### deploy ci
deployが発生する場合に、deploy終了までどれだけの時間を要したかを適当に5つ抜き出してみました。

### circle ci
- 03:20
- 03:36
- 04:14
- 02:56
- 02:50

これもだいたい3分から4分の間。1回だけ13:06かかったことがあり謎。

### wercker
- 2:21
- 2:26
- 2:47

werckerに移行してからあまりdeployしてないのでサンプルが少ないですが、早くなっています。

## 参考
- [MiddlemanのVPSへのデプロイにWerckerを使ってみた - Under Construction Always!](https://blog.d6rkaiz.com/archives/2015/07/22/middleman-deploy-using-wercker-to-vps/)
- [SSHサーバのRSA fingerprintの確認方法 | server-memo.net](http://www.server-memo.net/server-setting/ssh/rsa-fingerprint.html)
