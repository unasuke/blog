---
title: "QUIC実装月報 2026年8月"
date: 2026-08-30 17:20 +0900
tags: 
- quic
- tls
- quic-impl-monthly-report
---

![carbuncle DoH query result](2026/quic-impl-monthly-report-202608-carbuncle-doh.png)

<div lang="en">

Translated by AI (and reviewed by me) from handwritten Japanese text. (日本語が後に続きます)

## July and August Achievements
I skipped the monthly report for July because I was completely occupied with tasks like reviewing proposals for Kaigi on Rails 2026, working on [Ferryman](/2026/ferryman-is-a-port-forwarding-helper-tool/), and the preparatory work surrounding Kaigi on Rails that led to its creation.

As for what I've been working on, I'm continuing to implement a DNS full-service resolver. For name resolution within my home network (using the Tailscale network), it's already at a stable, usable level with occasional name resolution failures that I'm addressing one by one through development (handled by Claude Code).

In addition to this, I've added DoH implementation alongside DoT to enable operation of our own TLS implementation. The screenshot above shows the results of a DoH query.

It's been quite some time now since I've done any work on QUIC at all.

## RubyKaigi 2026 follow up event
<https://rhc.connpass.com/event/392503/>

While I didn't talk at RubyKaigi 2026, I'll be speaking about 2026's achievements at the follow-up event. This will essentially serve as a summary of this monthly report. As of when I'm writing this blog post, there are still some available spots for in-person attendees, so anyone interested in learning about the progress made by people since RubyKaigi 2026 is welcome to attend.

</div>

## 7月、8月やったこと
7月の月報はサイレントにスキップしましたが、Kaigi on Rails 2026のproposalレビューとか、[Ferryman](/2026/ferryman-is-a-port-forwarding-helper-tool/)とか、それを作るきっかけとなったKaigi on Rails回りの準備作業をやっていたらそれどころじゃなかったのが原因です。

というわけでやっていたことですが、6月の月報にも書いていたDNS full service resolverの実装を進めています。自宅内(Tailscale network)内での名前解決については常用できるレベルで、たまに名前解決ができないケースがあるので都度修正、というふうに開発を(Claude Codeが)行っています。

それに追加し、自前のTLS実装の運用環境として動かせるように、DoTの実装に加え、DoHの実装を追加しました。冒頭のスクリーンショットはDoHでクエリしたときの結果です。

いよいよQUICのことをなにもしていない期間が長いですね。

## RubyKaigi 2026 follow upで発表します
<https://rhc.connpass.com/event/392503/>

今年もRubyKaigiで発表した訳ではないですがfollow up eventで2026年の成果について話します。基本的にはここの月報のまとめとなる予定です。ブログを書いている時点では現地参加の枠がまだ少し残っているので、RubyKaigi 2026以降の人々の進捗に興味のある方はぜひお越しください。
