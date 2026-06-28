---
title: "QUIC実装月報 2026年6月"
date: 2026-06-28 23:30 +0900
tags: 
- quic
- quic-impl-monthly-report
---

![carbuncleのtelemetry](2026/quic-impl-monthly-report-202606-carbuncle-telemetry.png)

<div lang="en">

Translated by AI (and reviewed by me) from handwritten Japanese text. (日本語が後に続きます)

## June's progress
While I hinted at working on QUIC implementation in our monthly report last month, I haven't actually made any progress on QUIC implementation this month. However, this was intentional - I've been working on something else instead.

There are three QUIC implementations that particularly interest me: Raiha, my own Pure Ruby implementation; ruby-quic, a binding for ngtcp2; and Samuel's implementations of protocol-quic and protocol-http3. I've been considering how best to test these implementations - how they actually function, what API interfaces they provide, and how they perform over extended periods of operation. The perfect test environment turned out to be a DNS full-service resolver. By supporting both DoQ and DoH3, it could serve as comprehensive testing ground for both QUIC and HTTP/3.

<https://github.com/unasuke/carbuncle>

Since I know absolutely nothing about DNS resolver, I've been accepting Claude Code's generated code without thoroughly reviewing it and proceeding with development. I started having Claude Code work on this mid-last month, and it's currently running on a Raspberry Pi at home, functioning perfectly for my daily personal name resolution needs and serving as my home's DNS full-service resolver. The screenshot at the beginning shows the results of enabling telemetry output. Currently, DoQ support isn't implemented yet[^dot], and I'm focusing on developing the basic resolver functionality. While I've made the code publicly available, I don't intend to promote widespread adoption at this time.

</div>

## 6月やったこと
さて先月の月報でやっていきそうな素振りを見せましたが、今月は特にQUICの実装に関しては動いていません。ですがこれは意図的で、別のものを作っています。

自分の関心があるQUIC実装は現時点で3つあります。Pure Ruby実装で自分が取り組んでいるRaiha、ngtcp2のbindingであるruby-quic、Samuel氏の実装しているprotocol-quic及びprotocol-http3です。これらの実装が実際にどう動くのか、どのようなAPIで使用できるのか、長時間運用してみてどうか、などのことを検証する方法について考えていました。そしてちょうどいいのがDNS full service resolverです。DoQ、DoH3に対応すれば、QUICとHTTP/3の両方についての検証環境となりえます。

<https://github.com/unasuke/carbuncle>

こればかりは本当に何もわからないので、Claude Codeの生成するコードをろくに確認もせずにacceptして開発を進めています。先月中旬からClaude Codeに開発させ始め、現在は自宅のRaspberry Pi上で動かしていて、日々の個人的な名前解決、宅内でのDNS full service resolverとしての運用に関しては問題なく稼動しています。冒頭のスクリーンショットは、telemetryを出力させた結果になります。まだDoQ対応はできておらず[^dot]、基本的なリゾルバとしての機能を満たせるように開発を進めています。とりあえずコードは公開はしていますが、広く使ってもらおうとは考えていません。

[^dot]: <span lang="en">Although DoT implementation is complete at this point, it hasn't been deployed for actual operation yet.</span> / 現時点ではDoTの実装が完了しているものの、まだ実運用には乗せていません。
