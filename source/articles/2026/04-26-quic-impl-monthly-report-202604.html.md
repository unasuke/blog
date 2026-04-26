---
title: "QUIC実装月報 2026年4月"
date: 2026-04-26 23:50 +0900
tags:
- quic
- quic-impl-monthly-report
---

![221個のpushできていない変更たち](2026/quic-impl-monthly-report-202604-local-commits.png)

## 4月やったこと
しれっと3月の月報を飛ばしていますが、これはまとまった進捗がなかったためです。というよりは3月はQUICの実装はそこそこにして、[draft-chamberの実装に勤しんでいました。](2026/ietf-125-shenzhen/)

というわけで3月から4月にかけてやっていたことについてですが、世には良い言葉があり、「完璧を目指すよりまず終わらせろ」というものです。過去の進捗報告記事でも[0からAIに書いてみてもらっている](/2025/quic-impl-monthly-report-202506/)と述べたように、昨今の開発においてはAI  empowered codingの波から逃れることはできません。というわけで、自分の変な意地は捨てて、これまでの実装の続きをClaude Codeに書いてもらっています。一応auto acceptにしてはおらず、全ての変更点を見て適用するかそうでないかを決めてはいます。が、rbsファイルだったり大規模な修正については完全にレビューできているかどうかは正直怪しいところです。

ただし野放図に開発を進めてられて期待と違ったものをつくられても困るので、RFC 8999からの4本のQUICに関する一連のRFCはリポジトリ内に置いてそれを適宜参照することと、既知の実装に対する interop testを作成してそれがpassするかどうかを確認するようにしています。

その結果、まだpushできていない生活としては `origin/main` から221個のcommitsが積まれており、quic-go、quicheとのinterop testも通過しはじめている、という状況ではあります。

## 技術書典20
さて、実装とは別に、定期的に行われる[ゲームリアルタイム通信プロトコル コミュニティ](https://github.com/TakeharaR/game-realtime-protocol)の一員としての顔も(大したことはできていませんが)あり、[技術書典20の新刊である「ゲームリアルタイム通信プロトコル コミュニティ 会合誌 Vol.1」](https://quic.booth.pm/items/8227811)に「IETF Meetingでどんな議論がされていたかを追いかける方法」という章を書いています。僕の章以外にも興味深い内容の章がたくさんある同人誌となっているので、ぜひお求めください。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">『ゲームリアルタイム通信プロトコル コミュニティ 会合誌 Vol.1』の頒布を開始しました！<br><br>ゲームにおけるリアルタイム通信に関連した技術について、実際の開発現場に携わってきたメンバーが、知見を持ち寄りまとめた合同誌です<br><br>Booth → <a href="https://t.co/lfb7n4vxMz">https://t.co/lfb7n4vxMz</a><a href="https://t.co/zjkUqkTVqg">https://t.co/zjkUqkTVqg</a></p>&mdash; 竹原涼 (@takehara3586) <a href="https://twitter.com/takehara3586/status/2045849416318562551?ref_src=twsrc%5Etfw">April 19, 2026</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

……というのを、技術書典20の期間中に宣伝できれば良かったのですが、RubyKaigi 2026関連の作業が始まってしまい、ロクに告知することが出来ずじまいでした。とはいっても頒布数はそこそこの数出ており、感謝の気持ちでいっぱいです。手に取っていただいた皆さま、竹原さんをはじめとする関係者各位には頭が上がりません。
