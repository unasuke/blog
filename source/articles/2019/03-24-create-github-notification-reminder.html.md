---
title: "未読のGitHub notificationを定期的に通知させる"
date: 2019-03-24 18:51 JST
tags:
- Programming
- github
- ruby
- heroku
- slack
---

![botの様子](2019/github-notification-reminder.png)

## participating notification
皆さんは <https://github.com/notifications/participating> を普段どれだけ見ていますか。僕はこの機能をよく使うのですが、集中していたりすると見に行くのを忘れて、コメントされているのに返事をしそこねてしまったまま長い時間経ってしまうということがしばしばありました。

## 要件
### push型の通知であること
こっちからアクセスしに行かなくても、「未読がこれだけあるよ」と教えてほしいわけです。

### 即時的でないこと
とはいっても、コメントされて数秒で通知が来る、という即時性は求めていません。なぜなら、例えば社のリポジトリに関することであれば、GitHubのコメントやmergeをSlackに流しているからです。コメントの応酬はそっちで見れます。

<https://slack.github.com/>

ユースケースとしては、「出社してまず見る」とか、「集中してて気づかなかったけどあのpull reqにコメントついてるっぽい」だとか、そういうのを求めていました。

## GitHub notification reminderをつくった
<https://github.com/unasuke/github-notification-reminder>

これをheroku schedulerで定期的に叩くことによって、このように通知させています。

![botの様子](2019/github-notification-reminder.png)

Deploy to herokuボタンを作ったので同様の問題にお困りの方はご活用ください。

### 困っていること
GitHubのREST API v3でNotificationsを取得するendpointとresponseは以下URLの通りです。

<https://developer.github.com/v3/activity/notifications/#list-your-notifications>

ここで、通知の対象であるissueやpull requestの情報を見ようとすると、`subject.url` がそれっぽいなということになります。しかしよく見ると、domainが `api.github.com` になっています。例としてdocumentに載っている `https://api.github.com/repos/octokit/octokit.rb/issues/123` ですが、ここにweb browserからaccessすると、JSONが返ってきます。この中に、`html_url` として、human accessableなURLが入っています。

これ、しんどくないですか。いわゆるGraphQLが解決しようとした、RESTによるN+1の実例じゃないか！となりました。そしてGraphQL API v4にはまだNotification Objectは来ていないのですね。

この件、supportに投げたのですが、僕の英語力が未熟なのか、「 <https://developer.github.com/v3/pulls/#get-a-single-pull-request> を使うといいよ」と返事が来ました。そういうことなのでしょう。

ただ、get-a-single-pull-requestしようにも、responseの中にissueやpull requestのnumberが単体では含まれないので、二進も三進も。(このscriptではgsubでhtmlを組み立てています)


## こういう書き捨てのscriptのreadmeを頑張ることについて
よしいっちょブログに書くか〜となり、そんならREADME.mdを整備しておかないと「映え」ないなとなって、heroku appならdeploy to herokuボタン欲しいよなといろいろとmeta dataをつくっていて、正直面倒なんです。

じゃあなんで書くかというと、codeにcommentを書くように、あとで見る自分のためなんですね。未来の自分が環境構築するときに困らないように、という目的があるのかなと思いました。
