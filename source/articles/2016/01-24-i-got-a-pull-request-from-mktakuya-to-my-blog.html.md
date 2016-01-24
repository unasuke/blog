---
title: mktakuyaからこのブログにプルリクが飛んできた話
date: 2016-01-24 02:06 JST
tags:
- diary
- github
---

![blog name](2016/pull-request-from-mktakuya-01.png)

## このブログはオープンソースです。
特に主張などはしていませんが、このブログは[unasuke/blog](https://github.com/unasuke/blog)にて生成に関する部分や画像など、全てのコードを公開しています。

[middlemanとh2oとVPSによるブログ構築](/2015/blog-with-middleman-and-h2o-and-vps-server/)にも書いたように、middlemanを使ってhtmlなどの生成をしています。

まだまだデザインの面でもいろいろしたいことはあり、外見が未完成ではあります。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr"><a href="https://twitter.com/yu_suke1994">@yu_suke1994</a> あとrss欲しいです</p>&mdash; あそなす (@asonas) <a href="https://twitter.com/asonas/status/669101121785303040">2015, 11月 24</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

## Pull Requestが飛んできた。
<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">うなすけさんのブログをfeedlyにぶち込んだらブログ名が&quot;Blog Name&quot;だったりURLが&quot;blog.url,com&quot;だったりしててアレだったのでPR送った。</p>&mdash; mktakuya (@mktakuya) <a href="https://twitter.com/mktakuya/status/689478037868404738">2016, 1月 19</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

というわけで、こういうPull Requestが飛んできました。

## ライセンスが決まってなかった。
その場でPull Requestをmergeしてもよかったといえばよかったのですが、生憎とこのブログにはライセンスを定めていませんでした。その状態で他人からのPull Requestを取り込んでしまうのはあまりに危険と言える(？)でしょう。

というわけで、このブログはMIT LICENSEの元で公開することになりました。 [Add license(MIT) · unasuke/blog@d418f1b](https://github.com/unasuke/blog/commit/d418f1b91392737038556caba8c7f7bf0966bf0d)

## merge it
無事しました。

![merge](2016/pull-request-from-mktakuya-02.png)

## このブログはプルリク募集中！
ではないです。

この記事にあるように、バグ修正とかは大歓迎ですが、見た目が大きく変わる変更や、新規記事の追加(！)はしてほしくないので……募集はしていません。

まあでもなんかあったらプルリクお待ちしております。
