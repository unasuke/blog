---
title: "ruby-jpでwebsocket-client-simpleというgemの開発を引き取った経緯"
date: 2022-01-09 19:59 JST
tags:
- programming
- ruby
---

![](2022/websocket-client-simple-github.png)

## ただdeployしたかっただけなのに
僕のお手伝いしている、とある会社ではdeployをSlack botから行っていましたが、ある日そのbotが動かなくなっていました。Twitterでも少し話題になったので覚えていらっしゃる方もいると思います。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">Rubotyで動いてた煉獄さんがSlack RTM周りの変更で動かなくなってしまったためGitHub Actionsに載せ替えました。通知の責務に関しては、炭治郎が受け継ぎました <a href="https://t.co/nM4hvc5oTL">pic.twitter.com/nM4hvc5oTL</a></p>&mdash; 黒曜@Leaner Technologies (@kokuyouwind) <a href="https://twitter.com/kokuyouwind/status/1468072928885735427?ref_src=twsrc%5Etfw">December 7, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

このとき何が起こっていたのか。前述したとある会社では、Slack bot frameworkとしてRubotyを、Slackとの通信にはruboty-slack_rtm gemを使っていました。

* [r7kamura/ruboty: Ruby + Bot = Ruboty](https://github.com/r7kamura/ruboty)
* [rosylilly/ruboty-slack_rtm: Slack(real time api) adapter for ruboty.](https://github.com/rosylilly/ruboty-slack_rtm)

ではまず、こちらのSlack APIのChangelogをご覧ください。

> If you still use `rtm.connect` or `rtm.start` to connect to Slack, you'll notice that all WebSocket URLs now begin with `wss://wss-primary.slack.com`.
>
> https://api.slack.com/changelog#changelog_date_2021-11

以前はどのようなURLだったのかというのはわかりませんが、これに関連して、ruboty-slack_rtm gem側で以下のissueに記載のあるような問題が発生するようになりました。

[OpenSSL::SSL::SSLError: SSL_write at Heroku · Issue #46 · rosylilly/ruboty-slack_rtm](https://github.com/rosylilly/ruboty-slack_rtm/issues/46)

どうやらSlackがWebSocketに使用するURLにて、TLS証明書にSNIが導入されたようです。そして、ruboty-slack_rtm gemがWebSocketでの通信のために使用しているwebsocket-client-simple gemがSNIを考慮できていないため、WebSocketでの通信が行えなくなってしまっている、ということのようでした。

一旦はslack-ruby-client gemを使うことで凌ぐことができましたが、websocket-client-simple gemにSNI対応が入ってくれると助かります。

さて、そのようなPull requrstは複数作成されていましたが、ownerであるところのshokaiさんの反応はありませんでした。

* [setting the host name to work with SNI by skierkowski · Pull Request #20 · shokai/websocket-client-simple](https://github.com/shokai/websocket-client-simple/pull/20)
* [Added to use SNI by fuyuton · Pull Request #36 · shokai/websocket-client-simple](https://github.com/shokai/websocket-client-simple/pull/36)

そこで思い切って聞いてみました。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr"><a href="https://twitter.com/shokai?ref_src=twsrc%5Etfw">@shokai</a> 突然すみません、このpatchが取り込まれてほしいのですが、これをmergeするのに何か障害になっていることはあるのでしょうか？<a href="https://t.co/LPxcKEHizh">https://t.co/LPxcKEHizh</a></p>&mdash; うなすけ (@yu\_suke1994) <a href="https://twitter.com/yu_suke1994/status/1474220431192526848?ref_src=twsrc%5Etfw">December 24, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

すると、移管について前向きに検討していただけるとのことだったので、同様にRubotyを使っているruby-jp slackのGitHub organization下で管理するということになりました。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">他の人が管理してくれるなら全部移管したいです</p>&mdash; Sho Hashimoto (@shokai) <a href="https://twitter.com/shokai/status/1474253588516175872?ref_src=twsrc%5Etfw">December 24, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

それについて、ruby-jpで行った会話の流れ[^slack]が以下になります。

[^slack]: 発言の掲載については許可を得ています

![](2022/websocket-client-simple-slack-1.png)
![](2022/websocket-client-simple-slack-2.png)
![](2022/websocket-client-simple-slack-3.png)

## やったこと
さて、そんなこんなでruby-jp以下に `shokai/websocket-client-simple` をforkし、gemをpublishする権限をいただいてから行ったことを以下にまとめました。

<https://github.com/ruby-jp/websocket-client-simple>

### READMEの更新
まずは既存のrepositoryのREADMEを更新します。websocket-client-simple gemは歴史のあるrepositoryですから、 `shokai/websocket-client-simple` であるという共通認識があることでしょう。

そのため、「開発は `ruby-jp/websocket-client-simple` に移動したよ」ということをREADMEの上部、すぐ目に入る部分に記載するべきでしょう。(これは元々の `shokai/websocket-client-simple` に出す必用があります)

[Update README (repo moved notice) by unasuke · Pull Request #42 · shokai/websocket-client-simple](https://github.com/shokai/websocket-client-simple/pull/42)

merge後、既存のissue及びpull requestに対して「まだこの変更が必用なら `ruby-jp/websocket-client-simple` 側にお願いします」とコメントしました。

### CIをGitHub Actionsに & 定期的に実行されるように
次に、CIが長期間実行されていないので、テストが通るかどうかを確認する必用があります。テストはGitHub Actionsで実行することにしました。

[GitHub Actions by unasuke · Pull Request #1 · ruby-jp/websocket-client-simple](https://github.com/ruby-jp/websocket-client-simple/pull/1)

そして、CIが定期的に実行されるように設定しておきます。これにより、依存している別のgemの破壊的変更にすばやく気づくことができるようになります。

### コードは変更せずにリリース
CIは整備しましたが、ここまでロジックは変更していません。最低限必用とするRubyのバージョンも変更していません。この状態で「開発は `ruby-jp/websocket-client-simple` に移動したよ」というメッセージをgemのinstall時に出すような変更を行い patch releaseを行いました。

[Update gem metadata by unasuke · Pull Request #2 · ruby-jp/websocket-client-simple](https://github.com/ruby-jp/websocket-client-simple/pull/2)

このメッセージはそろそろ消そうかなと思います。`homepage_url` と `source_code_url` で事足りるためです。

### Ruby 2.6.5以上を必須としてリリース
このリリースまでが、いわゆるmigration pathとしてのリリースです。リリース時点でメンテナンスされている、EOLになっていないRuby versionを下限とする制限を行ったリリースをしました。

[Set minimum requied ruby version to 2.6.9 by unasuke · Pull Request #3 · ruby-jp/websocket-client-simple](https://github.com/ruby-jp/websocket-client-simple/pull/3)

### SNI対応を行ってリリース
さて本題のSNI対応です。これは元々のrepositoryにpull requestを出している方が2人いらっしゃいました。その変更を見て僕がコードを編集して出すということもできますが、それはお二人にリスペクトがないと感じたため、その二人からpull requestが来るのを待つことにしました。

そしたらそのうちの一人であるfuyutonさんからpull reqを頂いたので、これを無事mergeしてリリースを行いました。やった！！！

[Added to use SNI by fuyuton · Pull Request #6 · ruby-jp/websocket-client-simple](https://github.com/ruby-jp/websocket-client-simple/pull/6)

このあたりの変更を大晦日から年明けにかけてやっていました。いい年越しでした。

### ruboty-slack_rtm側でwebsocket-client-simpleの最新版を使うように変更してもらう
ここでめでたしめでたし……とはいかず、ruboty-slack_rtm gem側が要求しているwebsocket-client-simpleが低いままなので問題は解決していません。

そのため、ruboty-slack_rtm側でSNI対応を行ったバージョンである0.5.0以上に依存するように変更を行ない、これをmergeしていただきました。 

[Use websocket-client-simple gem v0.5.0 or greater by unasuke · Pull Request #47 · rosylilly/ruboty-slack_rtm](https://github.com/rosylilly/ruboty-slack_rtm/pull/47)

これにて職場でのSlack botもmonkey patchなしで動くようになり、chatopsが無事にできるようになりました。めでたしめでたし。


## 余談 gemのowner権限について
さてこの度、Twitterでコミュニケーションしてgemの権限を頂くということを行いました。ところで、このような「owner権限のリクエスト」という機能がrubygems.orgに入っています。この機能では、作者がownerを引き受けてくれる人の募集、もしくはあるgemに対してのowner権限のリクエスト(こっちはgemのdownload数などに制限がある)を行うことができます。

ただ、まだリリースアナウンスはされていないようです。

* [RFC for ownership transfer by vachhanihpavan · Pull Request #25 · rubygems/rfcs](https://github.com/rubygems/rfcs/pull/25)
* [Add support for ownership calls and requests by sonalkr132 · Pull Request #2748 · rubygems/rubygems.org](https://github.com/rubygems/rubygems.org/pull/2748)
* [Add blog post for rubygems adoptions by sonalkr132 · Pull Request #95 · rubygems/rubygems.github.io](https://github.com/rubygems/rubygems.github.io/pull/95)
