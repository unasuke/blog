---
title: "middleman-somemojiというgemをつくりました"
date: 2017-05-17 11:18 JST
tags:
- programming
- ruby
- gem
- middleman
---

![somemoji](2017/somemoji-extract.png)

## つくりました :v: :v: :v: :v:
middlemanでemoji記法 `:example:` をemoji画像に置換するmiddleman pluginをつくりました。 :tada:

[unasuke/middleman-somemoji](https://github.com/unasuke/middleman-somemoji)

あ、middleman v4以降必須です。

## 動機
絵文字使いたかった、けどunicode emojiの入力ってけっこうしんどい、なのでGitHub風に絵文字を入力したかった。

できるならemojiのproviderも選べるようにしたかった…… そんな感じです。

## つかいかた
### bundle install
Gemfileに次の行を追加して、`bundle install`します。

```ruby
gem 'middleman-somemoji'
```

### somemojiを使ってemoji画像をひっぱってくる
```shell
$ bundle exec somemoji extract --provider=twemoji --destination=./source/images/emoji
```

このへんは本家 [r7kamura/somemoji](https://github.com/r7kamura/somemoji) を見に行ったほうがいいかもしれません。

### middlemanの設定でsomemojiを有効にする
```ruby
activate :somemoji,
  provider:    'twemoji',
  emojis_dir:  '/images/emoji'
```

上のコマンドそのまま実行すると設定はこんな風になります。

あと、`asset_hash`を使っているならemoji画像以下はhashを付けないようにしてください。

```ruby
# こんなふうに
activate :asset_hash, ignore: 'images/twemoji'
```

### emojiを入力する
:smile: :confetti_ball: :eyes: :star: :+1: :zzz: :sa: :metal:

## 既知の問題点
### preのなかも変換する
`<pre>`や`<code>`の中にあるemoji記法も否応なしに`<img>`タグに変換してしまうので、これを直したいです。見通しは立ってます。手を動かすだけです。

### asset_hash対応
これ必要かなぁ…… :question:

## よろしくお願いします
:pray: :pray: :pray: :pray: :pray: :pray: :pray: :pray: :pray: :pray: :pray: :pray: :pray: 
