---
title: 'やぎすけ Advent Calendar 2日目 Gemfileの整頓'
date: 2016-12-02 15:48 JST
tags:
- programming
- yac
- ruby
- rails
---

![pull request](2016/yac_day02_pullrequest.png)

## やぎすけ Advent Calendar 略してYAC
[やぎすけ Advent Calendar 2016 - Adventar](http://www.adventar.org/calendars/1800)

2日目です。目的とかそういうのはやぎにいがエモい記事を書いてくれました。

[やぎ小屋 | やぎすけ Advent Calendar 2016](https://blog.yagi2.com/2016/12/01/introduction-yagi-suke-advent-calendar-2016.html)

## imas\_api\_rails
さて、[yagi2/imas\_api\_rails](https://github.com/yagi2/imas_api_rails)というものを2人で密かにやっていっている訳です。

これはつい最近できたもので、色々`rails new`した時から変わっていないものがあります。その辺を2日目では俺流に書き換えていきます。

## Gemfile
### コメントの削除
[Remove comments · unasuke/imas\_api\_rails@8bfdca4](https://github.com/unasuke/imas_api_rails/commit/8bfdca47554259dfe0706ef34e3c755d0ad8942d)

いらないと思って消しました。

### 辞書順に
[Sorting · unasuke/imas\_api\_rails@fca1a36](https://github.com/unasuke/imas_api_rails/commit/fca1a363e5583d76827fff30d7e70749646aa4f8)

あからさまな`rails`はまあ置いとくとして、gemは基本的に名前の辞書順にやっていきましょう。やっていきましょうって、別に推奨されてるわけではないです。

### bundle update
[bundle update 20161202 · unasuke/imas\_api\_rails@637d0d7](https://github.com/unasuke/imas_api_rails/commit/637d0d7159ff82dca12775819372f22a5955e6f7)

嗜み。

## 参考にしているもの
[Raw Gemfile on Idobata (master - 5adeddb)](https://gist.github.com/kakutani/43b9f42197ab002fcdf8)

この辺の規則はidobataのGemfile styleに倣っています。全部守っているわけではないですが、このスタイルに近づけていくように心がけています。

例えば

> :developmentと:testの両方のグループで必要になるgemの記述

は今は守っていませんが、この記述量でそんな気にするほどでもないと思ったのでそうしています。
