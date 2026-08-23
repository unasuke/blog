---
title: "IETF 126 Viennaの個人的まとめと、MCPサーバーへの機能追加"
date: 2026-08-23 12:30 +0900
tags: 
- ietf
- quic
- tls
- httpbis
- masque
- ccwg
- moq
- tiptop
- happy
- scone
- rails
---

![](2026/ietf-126-vienna.png)

## IETF 126
<https://datatracker.ietf.org/meeting/126/proceedings>

IETF 126は2026年7月18日〜24日にオーストラリア、ウィーンで開催されました。例によって以下は個人的な感想を無責任に書き散らかしたものです。内容の誤りなどについては責任を取りませんし、まとめもAIによって生成したものです。

WGの記載はscheduleの順です。

## happy
* <https://datatracker.ietf.org/meeting/126/session/happy/>
* [HAPPY WG at IETF 126 — 議事まとめ（スライド・録画文字起こしより） - Draft Chamber](https://draft-chamber.unasuke.dev/s/oQrrKjLEwHv1KBJivsyArDoM)

どこかの集まりで「HEv3を実装できてるところはまだないんじゃないか」とか発言した記憶がありますが、全然そんなことなかったですね。Firefox Nightlyではデフォルトで有効になっています。実装は <https://github.com/mozilla/happy-eyeballs> に。あと <https://www.happy-eyeballs.net> というものができています。

ChromiumのほうではOptimistic DNSというものに取り組んでいるとか。

[iOSで実装されている、期限切れDNSキャッシュを活用する Optimistic DNS について - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2026/06/04/220002)

## moq
* <https://datatracker.ietf.org/meeting/126/session/moq/>
* [IETF 126 moq WG 全3セッションまとめ（スライド・録画文字起こしより） - Draft Chamber](https://draft-chamber.unasuke.dev/s/evgz35Lkog3kG4Rq3QQMWC1z)

このセッション自体MoQで配信されたんだとか。

前回のまとめで言及するつもりで忘れていたんですが、 <https://buttondown.com/moqmonthly/archive/> というものがあって定期的にmoq関連の動きをまとめる動きがあるようです。が、あまり更新されない……

`moqt://`  というschemeが定義されるようですね。


## ccwg
* <https://datatracker.ietf.org/meeting/126/session/ccwg/>
* [IETF 126 CCWG セッションまとめ（スライド＋録画文字起こし）— Hackathon / BBR / SCReAMv2 / SEARCH / Firefox slow start 評価 / C4 / NDTC - Draft Chamber](https://draft-chamber.unasuke.dev/s/Z4rP8QSf3KqKgUracTqzweDL)

はい。(一応まとめてはみたものの何もわからんな……)

## tiptop
* <https://datatracker.ietf.org/meeting/126/session/tiptop/>
* [TIPTOP WG @ IETF 126 セッションまとめ — アドレス空間の2提案、QUIC プロファイル採択、CoAP と惑星間ホップ signaling - Draft Chamber](https://draft-chamber.unasuke.dev/s/HyXsskp3GftgNbpXF6hAjxEc)

アドレス空間をどうするか、という問題についての議論が多かったようだ。

## webbotauth
* <https://datatracker.ietf.org/meeting/126/session/webbotauth/>
* [IETF 126 Web Bot Auth WG セッションまとめ（識別ベース / 匿名認証 / Crawler Best Practices） - Draft Chamber](https://draft-chamber.unasuke.dev/s/QmeAf3YUrvZ7LVbryDFCCxVi)

"Crawler Best Practices" は読んでおいたほうがよさそう……

関連する話として、Cloudflare Walletsが発表されていましたね。

[Announcing Cloudflare Wallets: The programmable wallet for the agentic Internet | Cloudflare Blog](https://blog.cloudflare.com/wallets/)

## masque
* <https://datatracker.ietf.org/meeting/126/session/masque/>
* [IETF 126 MASQUE WG セッションまとめ（2026-07-22, Vienna） - Draft Chamber](https://draft-chamber.unasuke.dev/s/ucqrgm6BDTchgqHESDYoQpET)

recharterの話とか。proxy-dns-svcbについての話で盛り上がっていた様子。

## quic
* <https://datatracker.ietf.org/meeting/126/session/quic/>
* [IETF 126 QUIC WG セッションまとめ（2026-07-22, ウィーン） - Draft Chamber](https://draft-chamber.unasuke.dev/s/qcdtWpWUGoheJaZcp7bcSJnq)

QMuxの実装が結構行われている。qlogもそろそろWGLCになりそう。

## tls
* <https://datatracker.ietf.org/meeting/126/session/tls/>
* [TLS WG @ IETF 126（ウィーン、2026年7月23日・24日）議事要約 - Draft Chamber](https://draft-chamber.unasuke.dev/s/QJvdGwBgB2x7VtSA5JJ1YZzz)

TLSのmlは荒れてましたね……そういえばTLS 1.3のRFCとしてRFC 8446をObsoleteするRFC 9846が出ましたね。

<https://datatracker.ietf.org/doc/html/rfc9846>

## httpbis
* <https://datatracker.ietf.org/meeting/126/session/httpbis/>
* [HTTPBIS @ IETF 126 (Vienna, 2026-07-24) セッションまとめ - Draft Chamber](https://draft-chamber.unasuke.dev/s/i85nE5c5jaw3a14x1XX5Bf9i)

Oblivious HTTPについてどうするという話でどうするかという議論になっていそう。

## scone
* <https://datatracker.ietf.org/meeting/126/session/scone/>
* [IETF 126 SCONE WG 詳細まとめ：protocol は単独で IESG 送出、appman は8/12 PR 締切→10月 WGLC 完了目標、recharter/close は IETF 127 で判断 - Draft Chamber](https://draft-chamber.unasuke.dev/s/bA8zFjUJdbFAV5QHnpz6qtsV)

SCONEがそろそろRFCになりそう。

## AIのまとめページを共有可能にした
という感じでざっとIETF 126をおさらいしました。前回のまとめ記事でMCPサーバーを運用している話をしましたが、今回は各WGでの議論の様子をまとめた内容をAIに書いてもらったテキストとして共有できる仕組みを実装しました。そのせいもあってこっち側に書くことがあんまりなくなってしまいましたが。これはこれで。

一応真偽については裏を取る必要があるとは思っていますが、前々回同様に実際に読んでまとめるよりはるかに楽にサマリーを生成してくれるのはありがたいですね。そして読めているかについては……まあ……盲目的に信じることもできないので、隅々までは読めてないです。
