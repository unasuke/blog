---
title: 'やぎすけ Advent Calendar 16日目 testの追加'
date: 2016-12-16 00:00 JST
tags:
- programming
- advent_calendar
- yac
- ruby
- rails
---

![pull request](2016/yac_day16_pullrequest.png)

## やぎすけ Advent Calendar
[やぎすけ Advent Calendar 2016 - Adventar](http://www.adventar.org/calendars/1800)

16日目です。やっていきましょう。

## testを書く
さて、今のdevelopment branchではtestが落ちるので、直していきましょう。

### 不要なhttp methodを削る
[Remove unneed controller tests · unasuke/imas\_api\_rails@56d92f3](https://github.com/unasuke/imas_api_rails/commit/56d92f348f2e5090ef1eb77d11a5ac78d61a6431)

`GET`しかないので、それ以外は消します。

### fixtureにデータを登録
[Define character fixture · unasuke/imas\_api\_rails@3b78b84](https://github.com/unasuke/imas_api_rails/commit/3b78b846bc21bd7d48fe8d29b1ac70b8273663c2)

天海春香さん。

### testするurlの変更
[Fix test url · unasuke/imas\_api\_rails@874afe9](https://github.com/unasuke/imas_api_rails/commit/874afe9104443e0495193964e542322a14b90b17)

indexはまだなにもないので、allに対してテストするよう変更します。

### response.bodyも見る
[Check response body · unasuke/imas\_api\_rails@bb50504](https://github.com/unasuke/imas_api_rails/commit/bb5050466a1213abe8d7227fd8a4e14dc5c34e66)

response.bodyにちゃんとcharacterがはいっているか確認します。

### searchのtestを書く
[Add test characters#search without params · unasuke/imas\_api\_rails@a3bc2a5](https://github.com/unasuke/imas_api_rails/commit/a3bc2a56ac1f8df307c8e1cdad5e7e7a22a72f13)

searchにparamsがない場合のtestを追加しました。
