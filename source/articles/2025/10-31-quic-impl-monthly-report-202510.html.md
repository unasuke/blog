---
title: "QUIC実装月報 2025年10月"
date: 2025-10-31 21:25 JST
tags: 
- quic
- tls
- quic-impl-monthly-report
---

![8月にハマってたことの解決diff(後述)](2025/quic-impl-monthly-report-202510-servername-ext-diff.png)

## 10月やったこと
9月はそもそも[Kaigi on Rails 2025だった](/2025/kaigionrails-2025/)ので何もできませんでしたが、今月もQUICのことは何もできていません。今月はKaigi on Rails 2025の後始末、各種事後イベントへの参加、11月1日から始まるIETF 124の予習で潰れちゃいました。

## 8月に行き詰まっていたことが解決した
ところで[8月の月報で行き詰まっている](/2025/quic-impl-monthly-report-202508/)という話をしました。この件は[thekuwayamaさん](https://thekuwayama.github.io/)にご指摘をいただき、`ServerName`拡張の取り扱いがおかしかったことが原因ということが判明しました。

<https://github.com/unasuke/raiha/commit/cbe054e9c03f44214a554603b906b07b08200b28>

冒頭の画像はそのdiffです。このあたり、明かに非効率なことをやっているのでなんとかしたいと思ってはいます。
