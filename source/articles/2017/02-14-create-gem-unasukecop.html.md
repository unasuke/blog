---
title: unasukecopというgemをつくりました
date: 2017-02-14 06:40 JST
tags:
- ruby
- gem
- Programming
---

![unasukecop](2017/unasukecop.png)

## リポジトリ
[https://github.com/unasuke/unasukecop](https://github.com/unasuke/unasukecop)

`config`以下にrubocopの定義があります。理由もコメントしてあります。

## つかいかた
おもむろに`Gemfile`に次のような行を追加します。

```ruby
gem 'unasukecop', require: false, group: :test
```

そしたら`bundle install`をして、`.rubocop.yml`に次のように書きます。

```yaml
inherit_gem:
  unasukecop:
    - "config/rubocop.yml"
    # - "config/rails.yml" # railsのCopを使いたい場合コメントを外す
```

すると僕の好みのrubocop設定がつかえます。誰得ですか。

## inspired by onkcop
元ネタです。

[onk/onkcop: OnkCop is a RuboCop configration gem.](https://github.com/onk/onkcop)

`init`コマンドの移植をしなかったのは、必要性を感じなかったからです。

## きっかけ
社内でrubocopを本格的に使っていくことになり、Copを調教するにあたって自分の好みを把握しておくべきかなと思ったので、やりました。

そのためにrubocopのCop定義を全部読みました。気づいたら翌朝になってました。

[Cops - RuboCop: The Ruby Linter that Serves and Protects](http://rubocop.readthedocs.io/en/latest/cops/)

## 所感
<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">命名規則に従うならunasukecopだけど語呂悪すぎではrubocop-unasukeとかのほうがいいのではと思っている</p>&mdash; うなすけ(ミートアップ) (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/status/831133393677004801">2017年2月13日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
