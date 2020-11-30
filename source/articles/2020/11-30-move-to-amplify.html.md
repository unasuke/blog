---

title: "このブログをS3 Static website hosting + CloudFrontからAWS Amplifyに移行しました"
date: 2020-11-30 19:08 JST
tags: 
- dialy
- aws
---

![amplify console](2020/amplify-console.png)

2017年からS3 Static website hostingとCloudFrontの組み合わせで運用してきたこのブログを、AWS Amplifyによる運用へと変更しました。

## 理由
### S3 syncが遅い
記事、画像が増えてくると、S3 syncに時間がかかるようになってきます。大体10分前後かかるということで、ちょっとなんとかしたいなと思っていました。また、deployに使用している middleman-s3_sync gem の開発が停滞しているように見えるのも脱S3 syncの要因のひとつです。良く言えば安定している、と言えなくもないし、嫌ならS3 syncによるdeployをやめればいいという話ではあるかもしれませんが……

### 管理が楽
大した管理をしていたわけでもないですが、S3とCloudFrontの2つのサービスによる構成から、Amplifyだけを見れば良くなるので少し楽になります。

### 裏側の構成は変化しない
<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">Amplifyも裏はCloudFront+S3っぽいし、何度か計測してると逆転することもあったので有意差はなさそう <a href="https://t.co/wa6hgje5PH">https://t.co/wa6hgje5PH</a></p>&mdash; うなすけ (@yu\_suke1994) <a href="https://twitter.com/yu_suke1994/status/1286568440665260034?ref_src=twsrc%5Etfw">July 24, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

という感じで、Amplify consoleでもCloudFrontのdistrinution URLがCNAMEとして指定する値と出てくるように、CloudFrontがリクエストを受けるという構成は変化しないことがわかっていました。なので大した影響はないだろうと判断しました。

## ハマり
### ダウンタイムが発生する
元々のCloudFrontで握っているTLS証明書との兼ね合いか、一度既存のCloudFrontのdistributionを削除(無効化ではだめだった)してからでないとAmplify console側で以前のものと同じドメインを設定させることができないようです。

[Switching Cloudfront+S3 => Amplify with custom domain requires downtime · Issue #22 · aws-amplify/amplify-console](https://github.com/aws-amplify/amplify-console/issues/22)

そのためにダウンタイムは必ず発生してしまいます。

それがどのくらいかかるかについてですが、ダウンタイムは体感では5分もなかったように思います。

(特に予告なくシレッと移行作業を行いました)
