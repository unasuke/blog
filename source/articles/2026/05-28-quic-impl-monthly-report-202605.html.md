---
title: "QUIC実装月報 2026年5月"
date: 2026-05-28 21:40 JST
tags: 
- quic
- quic-impl-monthly-report
---

![Claude Codeに手助けしてもらっている様子](2026/quic-impl-monthly-report-202605-powererd-by-claude-code.png)

<div lang="en">

Translated by AI (and reviewed by me) from handwritten Japanese text. (日本語が後に続きます)


## May's progress
As mentioned in the [April monthly report](/2026/quic-impl-monthly-report-202604/), I've been developing with significant AI assistance. While I didn't push any changes in April, I recently committed my local modifications.

Although I haven't completed full interop testing with quic-interop-runner, I have passed interop tests with both quic-go and quiche, reaching a stage where QUIC and HTTP/3 communication is now possible. I've also prepared sample scripts under [`/examples`](https://github.com/unasuke/raiha/tree/main/examples). We can already establish connections with several known HTTP/3 endpoints, including `cloudflare-quic.com`. I need to set aside dedicated time to thoroughly review the entire codebase at some point.
Now, regarding the Pure Ruby QUIC implementation discussed above - in practical use cases, no one would deliberately choose to use a potentially slower implementation when there are established, proven solutions available. Both in terms of interoperability and security, relying on such established implementations is superior.

With this in mind, I've also created a binding implementation for ngtcp2 and been advancing the development process (with AI assistance). Since I was able to acquire the exact namespace I wanted[^namespace], I feel a significant responsibility to build on this foundation. I'll continue enhancing the implementation's quality to serve as a viable option for those looking to perform QUIC communication in Ruby.

* <https://github.com/unasuke/quic-ruby>
* <https://rubygems.org/gems/quic>

This initiative began when I received encouragement from kazuho at RubyKaigi 2026 (or at least that's how I interpreted it?).

## protocol-quic, yet another QUIC implementation for Ruby

By the way, Mr. Samuel Williams as known as ioquatix is also working on making QUIC and HTTP/3 available from Ruby. He focuses on enriching the asynchronous I/O ecosystem and has released several projects under <https://github.com/socketry>, including falcon and protocol-http2.

 Inside these repositories, you'll find <https://github.com/socketry/protocol-quic>, a gem that uses ngtcp2 as its backend also. After encountering build issues in my environment during RubyKaigi 2026's post-event gathering at SmartHR, I consulted with them about these problems, and through various circumstances, I was added to the Maintainers Team for the Socketry organization.

Just a few days later, <https://github.com/socketry/protocol-http3>—which uses nghttp3 as its backend—was also released. Around this time, I collaborated with them at a coffee shop just before RubyKaigi 2026's post-event gathering at Pixiv, and we successfully incorporated some patches into the project.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Neat, it works. <a href="https://t.co/gdY9eoAIGh">pic.twitter.com/gdY9eoAIGh</a></p>&mdash; Samuel Williams (@ioquatix) <a href="https://twitter.com/ioquatix/status/2058809363914195275?ref_src=twsrc%5Etfw">May 25, 2026</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

I was able to discuss various things with Samuel regarding future Socketry-related projects, so I'll be actively working on them to the best of my ability.

</div>

## 5月やったこと
[先月の月報にも書いた](/2026/quic-impl-monthly-report-202604/)ように、実装の大部分をAIに支援してもらいながら開発を進めています。4月の時点ではpushしていませんでしたが、先日手元の変更をpushしました。

quic-interop-runnerでの完走こそしていませんが、quic-goやquicheとのinterop testは通過しており、ある程度の完成度でQUIC、HTTP/3による通信ができる段階までにはなっています。[`/examples` 以下にサンプルスクリプトも用意しました](https://github.com/unasuke/raiha/tree/main/examples)。`cloudflare-quic.com` など、いくつかの既知のHTTP/3 endpointに対して通信が可能なところまではできています。どこかで腰を据えて改めてコード全体を読む時間を作りたいです。

さて、これまでの話はPure RubyによるQUIC実装についてでしたが、実ユースケースにおいてはわざわざ遅い(であろう)実装を使いたい人というのはいないでしょうし、実績のある既知の実装に頼るほうが相互運用性の面でも、セキュリティの面でも優れています。

そんなわけで、ngtcp2のbinding gemとしての実装も作成し、実装を(これもAIと共に)進めています。名前空間についてはそのものズバリのものを取得できた[^namespace]ので、責任重大という感じがします。RubyでQUICによる通信を行いたい人の選択肢となれるように引き続き完成度を高めていきます。

* <https://github.com/unasuke/quic-ruby>
* <https://rubygems.org/gems/quic>

[^namespace]: I'm willing to relinquish it if necessary. / 何かあれば明け渡すつもりはあります

この取り組みはRubyKaigi 2026でkazuhoさんに背中を押された(と僕が勝手に思い込んだ？)ことがきっかけで始まりました。

## protocol-quic, yet another QUIC implementation for ruby

ところで、RubyからQUIC、HTTP/3を利用可能にするための活動はioquatixことSamuel Williams氏も取り組んでいます。彼は非同期I/Oのエコシステムを充実させることに注力しており、 <https://github.com/socketry> 以下で falcon や protocol-http2 などを公開しています。

それらのrepositoryの中にngtcp2を利用したgemである <https://github.com/socketry/protocol-quic> があるのですが、先日行われたSmartHR社でのRubyKaigi 2026アフターイベントにおいて自分の環境でbuildがうまくいかないことなどを相談した結果、色々あってSocketry orgのMaintainers Teamに加えていただきました。

またその数日後にnghttp3をbackendとする <https://github.com/socketry/protocol-http3> も公開されたのですが、こちらもピクシブ社でのRubyKaigi 2026アフターイベント直前の喫茶店において一緒に作業をし、patchを取り込んでもらいました。

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Neat, it works. <a href="https://t.co/gdY9eoAIGh">pic.twitter.com/gdY9eoAIGh</a></p>&mdash; Samuel Williams (@ioquatix) <a href="https://twitter.com/ioquatix/status/2058809363914195275?ref_src=twsrc%5Etfw">May 25, 2026</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Socketry関連でこれからやりたいこと、やるべきことについてはSamuel氏と色々話すことができたので、自分のできる範囲で手を動かしていきたいです。
