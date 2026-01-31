---
title: "QUIC実装月報 2026年1月"
date: 2026-01-31 20:10 JST
tags: 
- quic
- quic-impl-monthly-report
---

![nghttp3-rubyを開いているVS Codeの画面](2026/quic-impl-monthly-report-202601-nghttp3-ruby.png)


## 1月やったこと
[先月の月報に](/2025/quic-impl-monthly-report-202512/)

> 他にもやったことはあるのですが、それは1月の月報に回そうと思います。

という訳で他にやっていたことというのは、nghttp3のRuby binding gemを作っていたのでした。

<https://github.com/unasuke/nghttp3-ruby>

Co-Authored-Byこそ付いていませんが、ほとんどをClaude Codeに実装してもらいました。一応変更には全て目を通していますが、C拡張ライブラリに習熟していないこと、ドキュメントは読んでいるもののnghttp3自体に詳しいかと言われると全然そんなことはないので使うのはおすすめしません。

おすすめしませんというか、nghttp3はQUICレイヤーを提供しないためにこのgem単体で使うことはできません。というのでQUIC自体はOpenSSLにやってもらう(もしくはngtcp2のbinding gemを実装する？などしてQUICレイヤーをどこかから持ってくる)必要があります。というので先月はOpenSSL自体のQUIC APIについて色々調べていたのでした。ちょこちょこAPIをruby binding側に足していったりしていますが、なかなかうまくはいっていません。

そして自分の実装については何もできていません。現状のコードをClaude Codeに分析させてどういう順で実装を進めていけばいいかのアドバイスを出力するくらいはさせていますが……
