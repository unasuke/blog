---
title: "Kaigi on Rails 2024 運営記"
date: 2024-10-29 01:30 JST
tags:
- kaigionrails
- ruby
- rails
- diary
---

![](2024/kaigionrails-2024-station-ad.jpg)

## 感謝
Kaigi on Rails 2024に参加していただいたみなさま、ありがとうございました。登壇者の皆様、Proposalを出してくださった皆様、協賛してくださった企業の皆様、そして一般参加者の皆様のご協力のおかげでKaigi on Rails 2024を終えることができました。今年もハイブリッド開催となりました。2年目そして2回目ではありますが、いかがだったでしょうか。

以下、手短にふりかえっていきます。

## インタビュー
まさかのFindyさんにインタビューをしていただけることになりました。

[コロナ禍・逆境からの立ち上げを経て、人気カンファレンスへ。Kaigi on Rails運営の裏側 - Findy Engineer Lab](https://findy-code.io/engineer-lab/kaigionrails)

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">10月25、26日に開催されるKaigi on Railsに取材しました！<br><br>コロナ禍・逆境からの立ち上げを経て、人気カンファレンスへ。Kaigi on Rails運営の裏側 <a href="https://t.co/8Cnl3nGu9n">https://t.co/8Cnl3nGu9n</a> <a href="https://twitter.com/hashtag/EngineerLab?src=hash&amp;ref_src=twsrc%5Etfw">#EngineerLab</a> <a href="https://twitter.com/hashtag/kaigionrails?src=hash&amp;ref_src=twsrc%5Etfw">#kaigionrails</a> <a href="https://twitter.com/findy_englab?ref_src=twsrc%5Etfw">@findy\_englab</a>より</p>&mdash; Findy Engineer Lab (@findy\_englab) <a href="https://twitter.com/findy_englab/status/1848869443348160722?ref_src=twsrc%5Etfw">October 22, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

いやはや、なんとまあ……まさかインタビューをされる側になるとは思いませんでした。

## conference-app
せっかくv8.0.0.beta1が出たばかりなのだし、[思いきってconference-appも v8.0.0.beta1 に上げてみました](https://github.com/kaigionrails/conference-app/pull/309)。また、[SidekiqからSolid Queue + Mission Control Jobsへの移行もしています](https://github.com/kaigionrails/conference-app/pull/283)。他にもRailsに関係しないところだと、HerokuからAWS App Runnerに乗せかえました。参加者の皆さんから見れる機能としてはあまり変化はしていませんが、裏側は色々と変わっていたのでした。

ただ、deploy後に放置しているとrequestがtimeoutするという現象が発生しており、ご迷惑をおかけしました。原因は謎[^timeout]です。空deployをすることで解決することはわかっているので、会期中は思いついたタイミングでこまめにdeployを行うようにしていました。

[^timeout]: 「これか？」というアタリはついているのですが……

せっかくなので、会期中のmetricsを出しておきます。

![conference-appの10/25～10/26のmetrics (request count, 2xx response count)](2024/kaigionrails-2024-conference-app-metrics-1.png)

![conference-appの10/25～10/26のmetrics (cpu utilization, memory utilization)](2024/kaigionrails-2024-conference-app-metrics-2.png)

リクエスト数が跳ねてるのがオープニングのタイミングですね。みんながスクリーン上のQRコードを読んだのがそれだと思います。

## オープニング
なんとオープニングの挨拶をすることになってしまいました。初日の一発目ということもあり、ハイテンションで元気良くを心掛けた結果、皆さんから「元気があってよかった」「高専の寮生の挨拶かよ」などと好評だったようでよかったです。

## 2025
とうとう今年はクロージングで来年の会場と日程を発表できましたね。「成長」を感じます。

スタッフはまだまだKaigi on Rails 2024の作業が残っているので気持ちが2024のままなのですが、今回参加していただいた皆さんの高まった気持ちをKaigi on Rails 2025がちゃんと受け止められるよう頑張っていきたいと思います。
