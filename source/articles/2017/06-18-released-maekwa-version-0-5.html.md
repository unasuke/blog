---
title: "maekawaのversion 0.5をリリースしました"
date: 2017-06-18 19:00 JST
tags:
- golang
- Programming
- aws
---

<img src="/images/2017/maekawa-release-0-5-maekawa.png" alt="清楚前川" height="500px">

## Released! :tada:
- [Release version 0.5.0 · unasuke/maekawa](https://github.com/unasuke/maekawa/releases/tag/v0.5.0)
- [Release version 0.5.1 · unasuke/maekawa](https://github.com/unasuke/maekawa/releases/tag/v0.5.1)

上のみくにゃんはリリース記念に描きました。やる気の続く限り、maekawaのリリースごとにみくにゃんを描いていこうかと思います。

[「前川みく」/「うなすけ」のイラスト [pixiv]](https://www.pixiv.net/member_illust.php?mode=medium&illust_id=63449940)

## What's new?
### TargetのRoleArn指定対応
いつの日からか、TargetにもIAM Roleを指定できるようになっていたのでそれの対応をしました。

### Profile指定対応
cliで実行するときに、aws credentialのprofileを指定して実行できるようにしました。

### EcsParameters対応
今回のリリースのメインです。

[Amazon ECS Now Supports Time and Event-Based Task Scheduling](https://aws.amazon.com/jp/about-aws/whats-new/2017/06/amazon-ecs-now-supports-time-and-event-based-task-scheduling/)

spice lifeでは CloudWatch Eventsからecs taskを実行するのに、今まではlambdaを中間層として実行していました。

しかしTime and Event-Based Task Schedulingによって、中間層となるlambda functionが不要となり、直接ecs taskを実行できるようになりました。

今回のリリースで、maekawaからEcsParametersを取り扱えるようになりました。

### KinesisParameters対応
いつの日からか、Kinesisにも対応していたのでmaekawaでも取り扱えるよう対応しました。

## しなかった対応
InputTransformerとRunCommandPrametersには対応していませんし、今後するつもりもありません。

理由として、まずこの2つの機能をspice lifeで使っていないこと、そして実装が困難であることが理由です。

Golangを初めて触って作成した初めてのcli applicationなので、実装にまだ整理されていない部分があります。その上、言語知識がまだ不足しているので、複雑な構造の型への対応が今の僕には困難です。

なので実装予定はありません。

ただ、もちろんPullRequestを頂けるのならありがたく頂戴しますし、Amazon Wishlistなどの手段で圧を掛けてくだされば実装する気持ちになると思います。

## 今後の予定
outputをもうちょっとかっこよく(色とか差分とか)できたら1.0.0としてリリースしたいですが、いつになるかは未定です。
