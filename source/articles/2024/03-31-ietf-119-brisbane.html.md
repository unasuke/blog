---
title: "IETF 119 Brisbaneにリモート参加しました"
date: 2024-03-31 20:00 JST
tags:
- ietf
- quic
- tls
- mls
---


![](2024/ietf119-tls-errata.png)

## IETF 119 Brisbane
IETF Meeting参加シリーズも4回目、リモート参加シリーズだと3回目になりますね。2024年3月のIETF Meeting 119はオーストラリアのブリスベンで開催されました。TZはUTC+10なので日本からリモート参加しやすかったです。

オーストラリアといえばカンガルーということで、参加者向けメーリングリストでは「カンガルーに遭遇した場合はどうすればいい？Internet Draftの共著者にならないか誘うべき？」などの会話が行われていました[^kangaroo]。

[^kangaroo]: <https://mailarchive.ietf.org/arch/msg/119attendees/JFhD7Oqm4dRjB4YwzxzXJDMbYUU/>

## 参加したセッション
前述したとおりブリスベンのTZはUTC+10なので、各種ミーティングがUTC+9の時間で生活している自分にとっては人道的な時間に開催されるのは助かりました。ただ、それはつまり日々の仕事などの日常生活とバッティングするということでもあり、どのみちフルで参加することはできませんでした。

あとやっぱりリスニングは壊滅的でした。本当にわからない。

それでは以下、常体です。

### Media Over QUIC (moq)
#### Agenda
<https://datatracker.ietf.org/meeting/119/session/moq>

#### Readout from Hackathon
MoQの6つある(？)実装のうち、5つはversion 3(draft-ietf-moq-transport-03)に対応したとのこと。具体的にどの実装が、みたいな情報が見あたらないけど……

#### Subscribe and Fetch (draft-ietf-moq-transport)
* <https://datatracker.ietf.org/doc/draft-ietf-moq-transport/>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-moq-subscribe-and-fetch-01>

[SUBSCRIBE](https://www.ietf.org/archive/id/draft-ietf-moq-transport-03.html#name-subscribe) が送信されるとき、実際には何が送信されるのか、subscriptionの重複が存在する場合にオブジェクトが何度送信されるかが不定、などなどの不明瞭および不正な点がissueとして挙げられていて、それを解消するために `FETCH` という仕組みを提案するもの。

> Fetch is a “StateFul” request, finds out about “non-available objects” in that range.

と述べられている。

そんなわけで今はここで議論が進められているのかな？

[Split SUBSCRIBE into SUBSCRIBE and FETCH by ianswett · Pull Request #421 · moq-wg/moq-transport](https://github.com/moq-wg/moq-transport/pull/421)

#### draft-ietf-moq-transport
* <https://datatracker.ietf.org/doc/html/draft-ietf-moq-transport-03>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-moq-draft-03-updates-00>

で、それとは別にdraft-ietf-moq-transport-03でのupdateの報告。いくつかのメッセージがmerge、追加されたり、曖昧な部分の明確化が行われた。今後の課題としては前述のSubscribeの問題の他に、Transmission、Object Model Details、Handshakeがあるとのこと。

#### draft-mzanaty-moq-loc-03
* <https://datatracker.ietf.org/doc/draft-mzanaty-moq-loc/>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-moq-low-overhead-container-00>

CMAFに代わるメディアフォーマットであるLOC(Low Overhead Container)を標準化するもの。WebCodecベースで、CMAFよりもオーバーヘッドが小さい。

03でなんと[MLSの仕組みを利用したE2EEへの参照](https://datatracker.ietf.org/doc/draft-jennings-moq-e2ee-mls/)が追加されたり、Audio/Video共に様々なパラメータや拡張が追加された。

"Separate packaging container format from MOQ Streaming Format?" に関して意見が分かれていたようだ。

#### draft-wilaw-moq-catalogformat
* <https://datatracker.ietf.org/doc/draft-wilaw-moq-catalogformat/>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-moq-sessa-common-catalog-format-draft-update-for-ietf119-00>

catalogのupdateにJSON Patchを使うようになったり、トラック名が相対的に、名前空間を継承するようになったりする変更がmergeされている。今openなものとしてIANAにcatalog fieldsを登録したり、trackに共通するfiledsを持てるroot objectを追加したりなどがある。

Call for Adoptionということは近いうちにWG draftになるのかな。

#### WARP draft Update (draft-law-moq-warpstreamingformat)
<https://datatracker.ietf.org/doc/draft-law-moq-warpstreamingformat/>

話されてた？議事録にも特に詳細がないので新しいtopicはなかったのかも。

#### Transport Issues (draft-ietf-moq-transport)
* <https://datatracker.ietf.org/doc/draft-ietf-moq-transport/>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-moq-transport-issues-00>

そしてMoQ Transportのissueについての議論。このへんちょっと議題の認識がごっちゃになってるかもしれない。GroupおよびTrackが終了するのはいつか、優先順位はどうするか、みたいな議論がもりあがっていた。次のIETF Meetingまでにinterim meetingをやろうという意見が投票多数。

#### Lessons from implementation
<https://datatracker.ietf.org/meeting/119/materials/slides-119-moq-simulcast-video-delivery-learnings-01>

サイマルキャスト、優先度、輻輳制御について。回線状況が不安定な場合の挙動について色々課題が出てきていて、FECについての研究やmoq WG以外のWGと連携することも提案されている？(BBRv3の改善とか)。

#### Bandwidth measurement in MOQ
<https://datatracker.ietf.org/meeting/119/materials/slides-119-moq-bandwidth-measurement-for-quic-00> (pptxです)

様々な映像ソースを使って帯域測定をした結果とのこと。Özyeğin University(なんて読むんだ、トルコのオジェギン大学？)の方からの発表。

帯域幅測定はクライアント側で行うことが可能。共有だけで特に議論とかはなかった……のかな？(録画を見てるけどたぶんない)

#### MoQ Secure Objects
* <https://datatracker.ietf.org/doc/draft-jennings-moq-secure-objects/>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-moq-sessb-secure-objects-00>

MoQでE2EEをやるための仕組みの提案。CMAFのほうにはCommon Encryption(cenc)というのがあるんだけど、それの代替というわけではなく、Low overhead containerのほうでcenc的なことを実現するためのもの(そのまま使うことができないので)。

新しい暗号を導入するのではなく既存のHKDFとAEADを使う。MLSやLOCとのeasy integraionを目指している。"Why focus on low bandwidth" に "Lyria is a 3kbps audio codec. Newer ML codecs are use even less bandwidth."(原文ママ) とあって、Lyra、あったな～～～となった。

[Lyra V2 - a better, faster, and more versatile speech codec | Google Open Source Blog](https://opensource.googleblog.com/2022/09/lyra-v2-a-better-faster-and-more-versatile-speech-codec.html)

質問でCGM-SSTなるものに言及があったけど、これだろうか。

<https://datatracker.ietf.org/doc/draft-mattsson-cfrg-aes-gcm-sst/>

そして内容がよく聞きとれなかったけど、議事録には "Maybe use GCM-SST? (Sure)" とあるのでこれを使うということ？

### WebTransport (webtrans)
もともとQUICに興味を持ち始めたきっかけがWebTransportだったのに、このWGを追うのを忘れていたな～、と。

#### Agenda
* <https://datatracker.ietf.org/meeting/119/session/webtrans>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-webtrans-ietf-119-webtrans-wg-slides-04>

#### W3C WebTransport Update
* <https://w3c.github.io/webtransport/>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-webtrans-ietf-119-webtrans-wg-slides-04>

WebTransportに関わる標準化はIETFとW3Cの両方で進められていて、W3CのほうはWeb browser APIとかを担当している(という理解をしている)。

W3CのほうでのWebTransportは、6月にAPIを安定させ、8月には複数の実装が存在している状態を予定しているっぽい？

めちゃくちゃ長い名前のオプションが追加されてる。

現時点でSafariのみが未実装。 <https://caniuse.com/mdn-api_webtransport>

#### draft-ietf-webtrans-http2
* <https://datatracker.ietf.org/doc/draft-ietf-webtrans-http2/>
* <https://datatracker.ietf.org/doc/html/draft-ietf-webtrans-http2-08>

118から 08が出て、`CLOSE_WEBTRANSPORT_SESSION`と`DRAIN_WEBTRANSPORT_SESSION`がHTTP/3のほうから追加されたり、いくかのcapsuleがrenameされて短くなった。

#### draft-ietf-webtrans-http3
<https://datatracker.ietf.org/doc/draft-ietf-webtrans-http3/>

<https://datatracker.ietf.org/doc/draft-ietf-quic-reliable-stream-reset/> への参照が追加されたり。Flow controlについてどうするかの議論がさかんだったかな？ただinterimは予定されなかった。


### QUIC (quic)
masque wgも追いかけたほうがいいのかなという気持ちもありつつ、もういっぱいいっぱいなので……

#### Agenda
* <https://datatracker.ietf.org/meeting/119/session/quic>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-quic-chairs-00>

FECについては発表だけ、Accurate ECNは時間切れになりました。

#### QLOG (draft-ietf-quic-qlog-h3-events)
* <https://datatracker.ietf.org/doc/draft-ietf-quic-qlog-h3-events/>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-quic-qlog-00>

Dune: Part Two観てないんですけど、観たほうがいいですかね。

118以降、QPACK関連のイベントが削除されたり、イベント名がちょっと変わったり、Multipathのサポートが入ったりした。今年末にはWGLCしたい、という雰囲気？

もっとMoQ wgと連携していこう(あとでメールしてほしい)、という話が出た。

#### Multipath QUIC (draft-ietf-quic-multipath)
* <https://datatracker.ietf.org/doc/draft-ietf-quic-multipath/>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-quic-multipath-quic-00>

Path IDをどうするか、interopの結果がどうだったかなど。Path IDについては292で提案されているExplicitなものと現在の06とのPros/Consがそれぞれ挙げられている。MPTCPというのがあるのか。

retire CID on all pathsについては賛否が分かれたのかな？

#### Ack Frequency (draft-ietf-quic-ack-frequency)
* <https://datatracker.ietf.org/doc/draft-ietf-quic-ack-frequency/>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-quic-ack-frequency-00>

いくつかの文章と変更と明確化、特に対応せずcloseしたものなど、前回からの変更についての報告。

2度目のWGLCを119が終わったあとにしたい。

#### QUIC security considerations
<https://datatracker.ietf.org/meeting/119/materials/slides-119-quic-honeybadger-and-his-friend-the-mongoose-00>

QUICに対するリソース枯渇攻撃についての共有。HTTP/2 Rapid Reset Attachに似ている？QUICサーバー側のactive_connection_id_limitを越えてNEW_CONNECTION_IDをはちゃめちゃに送りつけるという攻撃、なのだろうか。

<https://seemann.io/posts/2024-03-19-exploiting-quics-connection-id-management/>

この記事に詳しく記載されている。

#### QUIC on Streams (draft-kazuho-quic-quic-on-streams)
* <https://datatracker.ietf.org/doc/draft-kazuho-quic-quic-on-streams/>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-quic-quic-on-streams-00>

新キャラ。TCPとUDPでの二面待ちをしたり、新しい概念が導入されたときにTCPとUDPの両方に対応する必要があったりするので、TCP上でQUICを話せるようにしようというもの。QUIC on Streamsはあくまでもfallbackであって、TCPで発生し、QUICが解決したHOLBの問題はこっちでも頑張って解消しようとはしていない。……で、あってるのかなあ。

スケジュールだと5分という話だったけどまあ5分で終わるはずがなく。どっちかというとQUICを推し進めていくほうがいいのでは？という反対意見のほうが多かった……のか？

#### BDP frame (draft-kuhn-quic-bdpframe-extension)
* <https://datatracker.ietf.org/doc/draft-kuhn-quic-bdpframe-extension/>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-quic-bfp-frame-00>

BDPは"Bandwidth Delay Product"の略。輻輳制御に関するパラメータを両者間でやりとりして、Careful Resumeを実現するもの。もしかしたらCCWGでやることになるかも？QUIC WGがこれを進めていくかについては賛否が分かれた。

### Transport Layer Security (tls)
#### Agenda
* <https://datatracker.ietf.org/meeting/119/materials/agenda-119-tls-01>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-tls-chair-slides-00>

#### 8446bis/8447bis
* <https://datatracker.ietf.org/doc/draft-ietf-tls-rfc8446bis/>
* <https://datatracker.ietf.org/doc/draft-ietf-tls-rfc8447bis/>

Chairのところで止まっていて、報告されているエラッタを処理しなければいけない。なんかエラッタを草案のコメントとして使ってる人がいて？全部closeになるかも、という話をしていたかも。

#### ECH Update (draft-ietf-tls-esni)
* <https://datatracker.ietf.org/doc/draft-ietf-tls-esni/>

Encryptred Client Helloになってからも、Encrypted Server Name Indication時代の名残で `draft-ietf-tls-esni` なの、混乱しますよね。

これも今月いっぱいはIn WGLCという報告。

#### Registry Update
<https://datatracker.ietf.org/meeting/119/materials/slides-119-tls-tls-registry-updates-00>

IANAの人からの報告。rejectされたrequestはなし。Extensionがいくつか増える(スライドにあるのは4つ)。ALPNも作業中のものがCoAPの表記について？

#### TLS Hybrid Key Exchange (draft-ietf-tls-hybrid-design)
<https://datatracker.ietf.org/doc/draft-ietf-tls-hybrid-design/>

大幅には変わっていないが、Hybrid Groupsの数が2つに削減された( `X25519Kyber768Draft00` と `SecP256r1Kyber768Draft00` )。FIPSの認証と、共有鍵と合体させる(？)方法についてが残っている問題。

"Chrome announced today they are going to release an experimental version." って言ってて、どれだよ……となっている。

* <https://chromiumdash.appspot.com/releases?platform=Windows>
* <https://chromium.googlesource.com/chromium/src.git/+log/144c1c9bfe50c83a7304a43491a071f2befefdeb..5eeee11bd6072aa2b85a9c5236ddb944b11d0371?n=1000&pretty=fuller>
* <https://issues.chromium.org/issues/40910498>
* <https://chromestatus.com/feature/5257822742249472>
* <https://groups.google.com/a/chromium.org/g/blink-dev/c/6xfaov3Z4yo?pli=1>
* [X25519Kyber768: Post-Quantum Hybrid Algorithm Supported by Google Chrome | Medium](https://medium.com/@hwupathum/x25519kyber768-post-quantum-hybrid-algorithm-supported-by-google-chrome-1f8150aac059)
    * これは関連してそうなMediumの記事

一番「それっぽい」のはDev channel 2023-03-16の `124.0.6356.6`のリリース(上の2つめのリンク)で、"Enable PostQuantumKyber by default on desktop" っていうcommitが入ってる。でもこれAndroid……？3つめのリンクはそのcommitに関連付けられているChromiumのissue trackerにおけるチケット。diffの中身も「っぽい」んだよな。Firefoxのほうは "Firefox is shipping in nightly currently." とのことで。<https://bugzilla.mozilla.org/show_bug.cgi?id=1871629> から辿れそうだけど具体的なcommitまではわからなかった。

#### TLS Obsolete Key Exchange (draft-ietf-tls-deprecate-obsolete-kex)
* <https://datatracker.ietf.org/doc/draft-ietf-tls-deprecate-obsolete-kex/>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-tls-obsolete-key-exchange-00>

これ、 In WG Last CallになってるけどExpiredっていうStatusはアリなのか？(chairの作業で止まってる、とスライドにはある)

FFDHEについて、TLS 1.2では Discouragedに、TLS 1.3ではNot recommended(議事録ではOKとしか書いてないけど、でもrecommendedではないでしょう)となることになりそう。

Static DH Client Certificatesについても非推奨とされる流れ？

#### TLS Formal Analysis
<https://datatracker.ietf.org/meeting/119/materials/slides-119-tls-formal-analysis-triage-panel-00>

個人的には今回のTLS WGのミーティングで最も盛り上がった議題だと思う。8773bisがlast callするにあたり、いくつかのWGのメンバーから「その変更に対するformal analysis(形式的分析)が行なわれていない」という意見があったらしい。

つまりTriage panelを置き、TLS 1.3の標準に変更が入る際にはtriage panelに連絡し、そこで正式にformal analysisを行うかどうか判断するようにしようという提案っぽい。

"Not just Tamarin" というのは標準化界隈でよく使われる(らしい)セキュリテイプロトコルの検証ツールとのこと。

<https://tamarin-prover.com/>

で、not justなのでTamarinに限らず様々なツール、手法で検証をしようじゃないか、という。

賛成の声が多い感じ。学生を巻き込みたいという意見もあった。

#### Super Jumbo Record Limit (draft-mattsson-tls-super-jumbo-record-limit)
* <https://datatracker.ietf.org/doc/draft-mattsson-tls-super-jumbo-record-limit/>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-tls-large-record-sizes-for-tls-and-dtls-00>

_SUPER JUMBO_

TLSのrecord size limitを RFC 8449にて定められている2^14 バイトから 2^16 バイトまで拡張できるようにするもの。データセンターで有益という意見。性能指標についてどうなるのか、という疑問点が挙げられ、今後識者と協力してやっていく、ということに。


#### mTLS FLag (draft-jhoyla-req-mtls-flag)
* <https://datatracker.ietf.org/doc/draft-jhoyla-req-mtls-flag/>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-tls-tls-flag-request-mtls-00>

クローラー、Botが「自分は真正なクライアントですよ、ほら証明書がありますよ」をサーバーに知らせるためにmTLS readlyであることを送る仕組み。

実はもうここ <https://tls-flags.research.cloudflare.com/> で動いている。CとGoでの実装もあるみたいだけど資料には記載がない。でもGoは多分これ <https://github.com/cloudflare/go/pull/151>

"I would like to see enthusiasm." ということは、もっと協力なニーズがないと厳しいのか？

#### Extended Key Update (draft-tschofenig-tls-extended-key-update)
* <https://datatracker.ietf.org/doc/draft-tschofenig-tls-extended-key-update/>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-tls-extended-key-update-00> pptxです

長生きなTLS connectionにおいての鍵更新をなんとかしたいという話。TLS 1.2での再ネゴシエーションが脆弱であるということでTLS 1.3では削除されている仕組み。(ラムダノートさんの[「プロフェッショナルTLS＆PKI改題第2版」](https://www.lambdanote.com/collections/tls-pki-2)では「8.1 安全でない再ネゴシエーション」として記載があります)

これが、通信インフラやIoT機器などのコネクションが長生きする場面において通信内容をよりセキュアにするために有用であるという提案。仕組みではpost-quantumでも使われるKEMを使う？[RFC 9180](https://www.rfc-editor.org/rfc/rfc9180)を参照するとのこと。

設計が複雑になるのでは？という議論になった感じだろうか。

#### ML-KEM for TLS 1.3 (draft-connolly-tls-mlkem-key-agreement)
* <https://datatracker.ietf.org/doc/draft-connolly-tls-mlkem-key-agreement/>
* <https://datatracker.ietf.org/meeting/119/materials/slides-119-tls-ml-kem-for-tls-13-00>

耐量子での鍵確立をやるってことですね。Named Groupに `mlkem768(0x0768)` と `mlkem1024(0x1024)` を足す。ていうか、耐量子暗号って7年前には既に提案されていたんですね(早すぎるのでは？というFAQ)。

hybridでやるべきでは？という意見、RFCではなくコードポイントの定義だけでいいという意見、強く支持するという意見、これはひどいアイデアだという意見などなどなどがあり、一体どうなっちゃうの～～？


## まとめ
むずかしいですね。mls、httpbis、httpapi、ccwgについてもまとめたかったんですが、ギブです。
