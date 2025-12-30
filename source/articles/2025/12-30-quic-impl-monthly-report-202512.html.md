---
title: "QUIC実装月報 2025年12月"
date: 2025-12-30 16:00 JST
tags: 
- quic
- tls
- quic-impl-monthly-report
---

![OpenSSLのQUIC demoに対するコメントの追加 with VS Code](2025/quic-impl-monthly-report-202512-ossl-demo-with-comment.png)

## 12月やったこと
12月やったことの前に11月の月報を書いていない件についてですが、IETF 124のまとめを書いていたら11月が終わっていたので、仕方ない[^heavy-ietf]ですね。

そして12月にやっていたことですが、自分のQUIC実装についてはまたしても全く何も手をつけていません。

では何をしていたかというと、OpenSSL自体のQUIC APIについて色々調べていました。具体的には `demos/guide/` 以下と `demos/http3` 以下のファイル群であったり、<https://docs.openssl.org/master/man7/openssl-quic/> だったりを読んでいました。

Claude Codeにサンプルコードの解説を頼んだりしてもいて、それによって生成されたコードをgistに置いておきました。

<https://gist.github.com/unasuke/cadc6e9af0b2f5e2860fcdf3318bb517>

他にもやったことはあるのですが、それは1月の月報に回そうと思います。

[^heavy-ietf]: 省力化しようと企んでいることはあるのですが、次のIETFまでに形にできるかな……
