---
title: "QUIC実装月報 2025年5月"
date: 2025-05-29 23:50 JST
tags: 
- quic
- tls
- quic-impl-monthly-report
---

![ロクにコミットをできていない様子](2025/quic-impl-monthly-report-202505-few-commits.png)

## 5月も手が動いていない
osyoyuという人にそそのかされ(？)、Alert protocolの実装より先にクライアントとしてHTTPSリクエストを送信、サーバーからのレスポンスを復号ということをできるようにしようとしています。何も異常が発生しなければAlert protocolを話す必要はないですし。

ただまたしても全然コードを書けていません。5月はちょっとプライベートの予定をいっぱい入れてしまいました。
