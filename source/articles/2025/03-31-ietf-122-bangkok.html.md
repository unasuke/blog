---
title: "IETF 122 Bangkokにリモート参加しました"
date: 2025-03-31 18:40 JST
tags: 
- ietf
- quic
- tls
- httpbis
- httpapi
- masque
- ccwg
- moq
- wish
---

![](2025/ietf-122-bangkok.png)

## IETF 122
バンコクはUTC+7なのでTZ自体は参加しやすいんですが、日中は仕事があるので結局ほとんどリアルタイムでは聞けなかったという……

それでは例によって以下は個人的な感想を無責任に書き散らかしたものです。内容の誤りなどについては責任を取りません。

## moq
### Agenda
* <https://datatracker.ietf.org/meeting/122/session/moq>

今回のinteropではメディアに関するデモも追加、実施されたよう。

このmoq-wasmの中の方のscrapも参考になるのでは。

[Media over QuicTransport(MOQT)動向まとめ](https://zenn.dev/yuki_uchida/scraps/32256e09e3a4a5)

という訳で僕からは軽めに。全然わからないので……あと事前にagendaに記載されていた "Reducing time to first byte" は触れられてないような気がする。見落としているのかな。

### Changes since IETF 121 (draft-07)
* <https://datatracker.ietf.org/doc/html/draft-ietf-moq-transport-10>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-moq-moqt-changes-since-ietf121-00>

IETF 122以降、07から10での変更について。いっぱいある！07から08が一番変更が多くて、08から09ではそうでもなく、09から10は文書の位置が移動しただけ。エッジケースでの挙動が明確になったのがほとんど？

### PUBLISH and SUBSCRIBE to Tracks in a Namespace
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-moq-publish-and-subscribe-to-a-namespace-00>

ビデオ会議で、2人目が入ってきた場合に最初に部屋にいた人の挨拶がちゃんと2人目に届くようにしたい。そういう問題を解決するための議論なんだけど、そもそも今のmoqではそれが保証できないのか？どういう理屈で保証できないんだろう。スライドにはプロトコルを理解している人にはわかりそうな図が貼られている。

### Track Alias
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-moq-track-alias-00>

スライドにはQuestionがあるけど、録画を見た感じでは一気に"Track Alias Alternate Proposal"まで飛ばして議論が始まっていた。pull reqがまた作られる？

### MOQT QLOG
* <https://datatracker.ietf.org/doc/draft-pardue-moq-qlog-moq-events/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-moq-moqt-qlog-00>

QLOGでmoqのイベントも記録できるようにするもの。今回は紹介のみで時間切れかな？

### Interop report
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-moq-chair-slides-session-2-01>

全員が08まで実装が完了していて、10まで実装しているのが4人。08から10までの差は大きくないのでよい結果という結果。

### LOC update, call for Adoption?
* <https://datatracker.ietf.org/doc/draft-mzanaty-moq-loc/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-moq-loc-00>

aboptionへの賛否に関する投票が行なわれ、賛成多数でadoptionされる流れに。

### AUTH PR
* <https://wilaw.github.io/CAT-4-MOQT/draft-law-moq-cat4moqt.html>
    * まだdatatrackerから見れる場所がない気がする
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-moq-sessb-auth-for-moqt-ietf-122-v1-00>

MOQTにおける認証とアクセスコントロールについて。"Common Access Token (CTA-5007-A)" という既存の標準を使うのだとか。(見るのに住所とか入れないといけなくてやだなあ、となり見れていない)

<https://shop.cta.tech/products/cta-5007>

"Need to create new CWT claim" とminutesにあるのはなんのことかと思えばCBOR Web Tokenのことか。この仕様を策定している団体？にもう問い合わせをしていて、結果としてはCTAを使うことは問題なくて、ただし拡張する必要はなくてCWTの定義を追加すればいいだけ(IETF内で完結できる)ということらしい。どういうものを作らないといけないのかはスライドにあるとおり(多分9ページ)。

まだadoptionできる段階じゃないのでGitHubで揉んでいこうフェーズかな。

## ccwg
### Agenda
* <https://datatracker.ietf.org/meeting/122/session/ccwg>

[5033bisがRFC 9743 (Specifying New Congestion Control Algorithms)になった](https://datatracker.ietf.org/doc/rfc9743/)、[draft-ietf-ccwg-ratelimited-increase](https://datatracker.ietf.org/doc/draft-ietf-ccwg-ratelimited-increase/)ができた、GitHubの使い方について合意した(<https://github.com/ietf-wg-ccwg>)というのがIETF 121からのupdate。

HPCC++についてはagendaにあったけど時間が足りなくて取り上げられなかった。

### New Tools for Testing Congestion Control and Queue Management Algorithms
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-ccwg-chair-slides-02>
* <https://wiki.ietf.org/en/meeting/122/hackathon#testing-congestion-control-and-queue-management-mechanisms>
* <https://ccperf.net/>
* <https://nest.nitk.ac.in/>

agendaにあったhackathon updateっていうのは、これのことだろうか。新しい輻輳制御アルゴリズムのテストを行うツールの紹介？と結果について。ns-3上に実装されたccperfとNeSTというもの。ccperfではTCP BBRとFQ-CoDCelとFQ-PIEを、NeSTではTCP BBRをそれぞれテストしてグラフにしている。

NeSTは"a python wrapper on Linux network namespaces"とのこと。QUICのサポートについても取り組む予定とのことで、既にmerge requestは出ている。

<https://gitlab.com/nitk-nest/nest/-/merge_requests/306>

こういうツールがあれば輻輳制御アルゴリズムの変更を提案する人が自分達で全てのテストをしなくてよくなるので重要だ、という意見があった。

### BBRv3
* <https://datatracker.ietf.org/doc/draft-ietf-ccwg-bbr/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-ccwg-draft-ietf-ccwg-bbr-02-00>
* <https://github.com/ietf-wg-ccwg/draft-ietf-ccwg-bbr>

121から122で01から02になった。変更としては `BBRIsProbingBW()` の疑似コードの追加やいくつかの識別子のrenameなど。次やることはClarification、Simplification、RenoやCUBICとのより良い共存、パフォーマンスの向上、実ユースケースにおいてのパフォーマンスリグレッションの回避が挙げられてる。"Multiple deployments at scale in QUIC and TCP" や "Text both TCP and QUIC implementations can follow" などがRFC化にあたってのやるべきことのひとつに挙げられている？issueとしてはTCPでないtransportについての適応、ProbeRTTの間隔、inflight_shorttermの必要性などについて。

### Rate-limited senders
* <https://datatracker.ietf.org/doc/draft-ietf-ccwg-ratelimited-increase/00/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-ccwg-increase-of-the-congestion-window-when-the-sender-is-rate-limited-01>

前回から、投票によってwg draftになったもの。"rate-limited"が指すものについて明確にすべきだ、など文書の明確化についてが今後の課題。

### SEARCH
* <https://datatracker.ietf.org/doc/draft-chung-ccwg-search/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-ccwg-search-a-new-slow-start-algorithm-for-tcp-and-quic-updates-01>
* <https://search-ss.wpi.edu/>

SEARCHを実際に運用してみた結果の報告かな？HyStart、HyStart++、BBRとの比較のグラフがある。帯域がどう増加していくか、メモリ使用量はどうか、それらのテストはどのように行ったか。"Looking for volunteers to try it out!" という点については前回と変わらず。

## httpbis
### Agenda
* <https://datatracker.ietf.org/meeting/122/session/httpbis>

### QUERY Method
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-safe-method-w-body>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-httpbis-sessa-query-method-00>

Location headerに関する議論の決着がついたらWGLCに進むっぽい。

### Template-Driven CONNECT for TCP
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-connect-tcp/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-httpbis-connect-tcp-00>
* <https://github.com/httpwg/http-extensions/issues/3000>
* <https://github.com/httpwg/http-extensions/pull/2949>

00からの更新は、non-capsule modeが削除された。終了時の扱いについてどうするかの合意ができてないので、そこが議論のポイントだったぽい。まだまだGitHub issueでの議論が続くのかな。

### Security Considerations for Optimistic Use of HTTP Upgrade
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-optimistic-upgrade/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-httpbis-sessa-security-considerations-for-optimistic-protocol-transitions-in-http11-00>

GitHub上で `CONNECT.*HTTP\/1.1` を含むPythonのコードを検索したところ、最初の50件のうちの少なくとも4つの異なるclientがステータスコードのチェックをしていなかった(レスポンスは待ち続けていた)とのこと。

<https://httpwg.org/specs/rfc9110.html#CONNECT>

RFC 9110によれば、サーバーが拒否する場合に400を返すので、無条件に成功すると見做すものではない(それはそう)。

07において明確にHTTP/1.1に対しての推奨であると記載された。ある一文においてMAYをMUSTにするかSHOULDにするかの議論が決着したらWGLCに進むぽい。

### Resumable Uploads
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-resumable-upload>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-httpbis-sessa-resumable-uploads-00>

06においては記述の大幅な変更(editorial overhaul)、expiresがmax-ageになったりとか。media-typeで`application/partial-upload` を使う際、今はPATCHだけどPUTもしくはPOSTのほうがよいか？という議論があったがPATCHで進みそう？WGLCも近そう。

### Secondary Certificate Authentication of HTTP Servers
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-secondary-server-certs/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-httpbis-sessa-secondary-certificate-authentication-of-http-servers-00>

HTTPにおいて追加の証明書を使用した認証を行う方法について。耐量子暗号の証明書(という表現は正しいのか？)の場合はサイズが大きいために複数のフレームに分割せざるをえないという問題について、新しいストリームタイプを使う場合についての調査を行うことで落ち着いたよう。実装ボランティア募集中！

### No-Vary-Search
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-no-vary-search/>

スライドなし。サポートしているサイトは <https://chromestatus.com/metrics/feature/timeline/popularity/4425> で確認できる。これをクライアント側として実装しているブラウザはChromeのみ。WGLCに進みそうな感じがする……

### Incremental HTTP Messages
* <https://datatracker.ietf.org/doc/draft-kazuho-httpbis-incremental-http/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-httpbis-sessb-incremental-http-messages-00>

Comic Sansだなあ。シグナリングについて3つ(もしくはそれ以上)の状態を持つべきかどうか、クライアント側がincrementalいけるぜ状態をどうサーバーに伝えるか、サーバーに中間者がincrementalできるかを伝える方法はどうか、などが議論。シンプルであることがより良いという意見があり、tri-stateにはならなそう？

### HTTP Unencoded Digest
* <https://datatracker.ietf.org/doc/draft-pardue-httpbis-identity-digest/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-httpbis-sessb-unencoded-digest-00>

例えばgzippedされたresponseを返すとき、そのdigest値を `Repr-Digest` で返し、gzipする前の内容のdigest値を `Unencoded-Digest` で返すようにするもの。range requestとかHTTP Signatureでユースケースがあるということだけど、いまいちピンと来てない……名前に関してどうするかという議論がある。

### Delete-Cookie and HttpOnly Prefix
* <https://datatracker.ietf.org/doc/draft-deletecookie-weiss-http/>
* <https://datatracker.ietf.org/doc/draft-httponlyprefix-weiss-http/>
* [Cookieの安全性を高める "\_\_HttpOnly-"プレフィックスの提案仕様 - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2025/03/21/000347)

スライドなし。rfc6265bisが更新されることはないっぽい、が、rfc6265bisをさらに修正するための取り組みはあって、そっちには入る可能性がある？Shopifyの人だ！

### Cookies: HTTP State Management Mechanism
* <https://datatracker.ietf.org/doc/draft-annevk-johannhof-httpbis-cookies/>

スライドなし。rfc6265bisではない版のやつ。このwgでやるのが相応しいかどうかの質問で終わったか？

### HTTP Client Hints Reliability
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-httpbis-sessb-http-client-hints-reliability-01>
* <https://datatracker.ietf.org/doc/draft-victortan-httpbis-chr-critical-ch/>
* <https://datatracker.ietf.org/doc/draft-victortan-httpbis-chr-accept-ch-frame/>

Client Hintsは最初のリクエストではサーバーが何に対応しているか不明なので最適化できず、例えば何もかもを送信するとそれはそれでプライバシーの問題がある、と。そのためにCritical-CHヘッダやACCEPT_CH frameを提案している。多くの人がmic queueに並んだようで、質疑が多い。やりとりするデータが増えることによるパフォーマンスの低下が懸念されていたり。

## tls
### Agenda
* <https://datatracker.ietf.org/meeting/122/session/tls>

ECHのキャッチアップが足りなかった、というのが僕の感想です。

### Encrypted Client Hello, DNS Service Bindings
* <https://datatracker.ietf.org/doc/draft-ietf-tls-esni/>
* <https://datatracker.ietf.org/doc/draft-ietf-tls-svcb-ech/>

Last Callになって色々なレビューがあった。ECHに関してはDNSDIRからちょっとした質問が返ってきている。svcb-echのほうは同じくDNSDIRから "I think it's ready to go." が返ってきている。

### rfc8446bis and -rfc8447bis
* <https://datatracker.ietf.org/doc/draft-ietf-tls-rfc8446bis/>
* <https://datatracker.ietf.org/doc/draft-ietf-tls-rfc8447bis/>

これ(IETF 122)が終わったらLast Callするって！！

### SSLKEYLOGFILE
* <https://datatracker.ietf.org/doc/draft-ietf-tls-keylogfile/>
* <https://mailarchive.ietf.org/arch/msg/tls/9RmHTAh3SKNFFzTe08odzhzl0tc/>

IETFでやることか？というところに関して一悶着あったけど、結局は取り組みが継続されそう。一悶着あったというのは、これはメッセージ内容を復号できるのでよくない、いやいやデバッグ用のツールなので通信内容の漏洩にはならない、という議論。

### rfc8773bis FATT Report
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-tls-fatt-report-rfc8773bis-00>
* <https://datatracker.ietf.org/doc/draft-ietf-tls-8773bis/>

Formal Analysis Triage Team (FATT)による8773bis(External Pre-Shared Key)のレポート。果たしてPSKは量子耐性があるのか。ということで8773bisを複数の研究者にレビューしてもらった。研究者は暗号計算と記号解析の分野を研究対象としている人達で。全員がTLSに関する公開された成果がある。研究者は公開されているが、レビューコメントのどれが誰によるものかは公開されない。レビュワーに直接連絡はせず、リエゾンに対して質問やコメントを送ってほしいというお願い。

解析結果そのものは「8773bisは既存のTLSに対する脆弱性を導入するものではなく、追加の解析を行う必要もないだろう」「量子耐性については懸念事項がある」というもの。なので量子耐性に関する主張を削るか、または維持するのであればさらなる解析が必要ということに？

議論はそもそもTLS wgとして量子耐性についてどういう立場でいくべきか、という内容になっていそう。結果いくつかの投票が行われ、一番賛成票を集めたのは「TLS wgがセキュリティに関する主張を改訂するべき」という設問。

### Request mTLS
* <https://datatracker.ietf.org/doc/draft-jhoyla-req-mtls-flag/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-tls-request-mtls-00>

クライアント側からmTLSできますよをサーバーに伝えられるようにして、認証されたbotからのアクセスを許可したいというユースケース。侃々諤々？DANEで役立つかもしれないという話が出た。

### Trust Anchor IDs
* <https://datatracker.ietf.org/doc/draft-ietf-tls-trust-anchor-ids/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-tls-trust-anchor-ids-00>

`*No discussion*` 

### PAKEs
* <https://datatracker.ietf.org/doc/draft-bmw-tls-pake13/>
    * <https://datatracker.ietf.org/meeting/122/materials/slides-122-tls-tls-13-pake-authentication-extension-00>
* <https://datatracker.ietf.org/doc/draft-guo-pake-pha-tls/01/>
    * <https://datatracker.ietf.org/meeting/122/materials/slides-122-tls-post-handshake-authentication-via-pake-for-tls-13-01>

PAKE(Password Authenticated Key Exchange Extension for TLS 1.3) に関する2つのdraft。ユーザーがパスワードやPINを入力することでの認証、組み込み機器のセットアップ、ペアリング時のユースケースが提示されている。AirPlayやMiracastのときのPIN入力の画像がスライドに添付されている。

TLS wgとしてやることには賛成多数、やるならhandshakeでやるべきで、post-handshakeではないという結論になった。

###  Implicit ECH
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-tls-implicit-ech-00>

ロシアでECH(Encrypted ClientHello)がブロックされてる(されてた？)のか……ECHを使うクライアントが、ECHを使っていることがわかってしまうのでプライバシー的に問題だったり、ECHを解釈できないサーバーはどう振る舞うのが正しいのか、などの問題がある。提案されているのは、ECH configとouter SNI(これなんだっけ？)が一致しない場合にサーバーは中断してはならない、outer SNIは事実上の非推奨にするなど。

ECHが普通になれば目立たなくなるのでそうなっていくべきとか、確かにこれは懸念すべき事項で、ECHは遅らせたくないがこれにも取り組むべきだ、という意見があった。これはちょっと気にしておかないといけなそうだ。

### ECN public Names
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-tls-ech-public-names-00>

IETFでは初めて見る雰囲気のスライドだ。これECHのことがわかってないとわからないな……

議論自体の結論は、ECHが完了したらやろうという感じか。

### Anonymity sets in ECH
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-tls-anonymity-sets-in-ech-00>

これもECHのことがわかっていないと何もわからない 😇

既存のECHのワークを中断させるものではないとのこと。

### Identity Crisis in Attested TLS for Confidential Computing
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-tls-identity-crisis-00>

Remote Attestationということで、rats wgと関連のあること？スライドの内容も、minutesに書いてあることもよくわからない……

## httpapi
### Agenda
* <https://datatracker.ietf.org/meeting/122/session/httpapi>

### HTTP Link Hints
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-link-hint/>

updateがあったので確認してね、くらい？

### REST API Media Types
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-rest-api-mediatypes/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-httpapi-mediatype-registration-update-00>

OpenAPIのmedia typeが登録中？open issuesが2つ。次のIETF meetingまでにWGLCしたい。

### RateLimit header fields for HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-httpapi-rate-limiting-draft-update-00>

様々なフィードバックが得られた。<https://github.com/darrelmiller/ratelimiting> が C# での実装。フィードバック次第では次のIETFまでにWGLCになる？

### New JSON Schema
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-httpapi-a-new-json-schema-language-00>
* <https://github.com/clemensv/json-cs>

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">MSの jsonschema の拡張提案見た。<br>$defsで再利用する型を厳格化するの、理想はそうだけど運用で上手くいくとは思えない。<a href="https://twitter.com/search?q=%24offers&amp;src=ctag&amp;ref_src=twsrc%5Etfw">$offers</a> でallOfやif/then/else を拡張仕様で分離するのは、逆に実装の乱立を招く気がする<a href="https://twitter.com/search?q=%24import&amp;src=ctag&amp;ref_src=twsrc%5Etfw">$import</a> は外部参照解決を複雑化する<br><br>総じて反対<a href="https://t.co/szxUmN3yBJ">https://t.co/szxUmN3yBJ</a></p>&mdash; mizchi (@mizchi) <a href="https://twitter.com/mizchi/status/1902738256250433671?ref_src=twsrc%5Etfw">March 20, 2025</a></blockquote>

<blockquote class="twitter-tweet" data-conversation="none"><p lang="ja" dir="ltr">これC#の言語仕様が念頭にあるように見えるな。C#にうまくマッピングする水準に見える</p>&mdash; mizchi (@mizchi) <a href="https://twitter.com/mizchi/status/1902738856874799354?ref_src=twsrc%5Etfw">March 20, 2025</a></blockquote>

<blockquote class="twitter-tweet" data-conversation="none"><p lang="ja" dir="ltr">今の時代これやるんだったらせめて WASM の Canonical ABI とか Component Model も念頭においてほしい気がする</p>&mdash; mizchi (@mizchi) <a href="https://twitter.com/mizchi/status/1902739365056721145?ref_src=twsrc%5Etfw">March 20, 2025</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

提案しているClemensさんはMicrosoftでFabric Eventstreamなどのメッセージングサービスに関するリードアーキテクトの人らしい。<https://cloudevents.io/> にも関わっているのだそう。mizchiさんの言ってる「C#にうまくマッピングする水準に見える」についても、口頭でTypeScriptやJavaScript、C#、Javaへのマッピングができるように設計していると言っている、多分。

強い賛成や反対があったというよりは「とりあえずGitHub repositoryじゃなくてdraftにしてもってきてほしい」っていう結論になった感じかな？


### HTTP Problem Types for Digest Fields
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-digest-fields-problem-types/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-httpapi-http-problem-types-for-digest-fields-00>
* <https://github.com/ietf-wg-httpapi/digest-fields-problem-types/issues/3>

セキュリティ上の懸念事項(上記issue)があるのでSECDIRのレビューを受けたいという意見があった。

## quic
### Agenda
* <https://datatracker.ietf.org/meeting/122/session/quic>

qlogに関しては時間がなくて軽めに。qlogの拡張をRTP over QUIC(AVTCORE)、Careful Resume(TSVWG)、MOQT(MOQ)など他wgでやってるよ。

あと、 <https://github.com/quicwg/base-drafts/wiki> が停滞している状況について改善する流れがあり、今はstaging環境が <https://quicwg.org/staging.quicwg.github.io/> で見れるようになっている。

### Multipath Extension for QUIC
* <https://datatracker.ietf.org/doc/draft-ietf-quic-multipath/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-quic-multipath-quic-00>

11から13までの変更点は、`PATH_CIDS_BLOCKED` frameの追加、複数パスでのPTOにおけるガイダンス、0-RTTにおけるMP frameのエラーコードの修正、その他さまざまな明確化。draft13に対する相互運用性の確認についてもほぼ成功。

`PATH_CIDS_BLOCKED` frameって本当に必要？という議論に関しては、これはデバッグのために便利で、既に実装が存在するのでそのまま残すということになったのかな。次の版でWGLCになるかも。

Multipath QUICはアリババもう本番投入している？ホントに？

### QUIC Address Discovery
* <https://datatracker.ietf.org/doc/draft-ietf-quic-address-discovery/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-quic-quic-address-discovery-00>

wg draftになってますね。議事録では "Extension Negotiation" に関する質疑だけ記載されている。草案から "negotiation" という言葉を削除したと。

### QUIC Extended Acknowledgement for Reporting Packet Receive Timestamps
* <https://datatracker.ietf.org/doc/draft-smith-quic-receive-ts/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-quic-quic-packet-receive-timestamps-via-extended-ack-00>

「遅延を正確に計測することで帯域幅の計測がより正確になる、などのモチベーション」って118のまとめのときに書いてた。他にもAckの頻度を減らすことに関しても重要。ACK frameにいくつかのtimestampに関するfieldを追加した`ACK_RECEIVE_TIMESTAMPS` frameを使う。そもそも複数のoptional fieldを持てるようACK frameを拡張可能にするか。新しいframeを定義するか、常にtimestampを送信するようにするかという議論がある。

とりあえずdraft自体をquic wgとしてやっていくことは賛成多数だった。

### Extended Key Update for QUIC
* <https://datatracker.ietf.org/doc/draft-rosomakho-quic-extended-key-update/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-quic-extended-key-update-slides-00>

QUICのセッション中に鍵交換は1回行われる。これを `draft-ietf-tls-extended-key-update` をベースとして、CRYPTO streamでTLS 1.3のメッセージを送り新規の鍵交換をやる。long-lived sessionにおいて重要だと。具体的にはtelco signaling、IoT、MASQUE/VPNとかだと。

wgとしてこれに取り組むことに関しては賛成多数で可決。

### Source Buffer Management
* <https://datatracker.ietf.org/doc/draft-cheshire-sbm/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-quic-ietf-122-stuart-cheshire-source-buffer-management-00>
* <https://mailarchive.ietf.org/arch/browse/sbm/>

遅いネットワーク上でMacのscreen shareが重いという問題があった。ネットワークのバッファが溢れているんじゃ？という疑いがあり、実際は送信側のバッファにあったと。送信待ちのデータがめちゃくちゃ増えちゃっており、そのため `TCP_NOTSENT_LOWAT` が導入されてバッファの量が制限されるようになった。IETF 121のside meetingで、これはバイト数ではなくミリ秒単位の制御であるべきだという話があった。で、QUICはどうする、と。なんかメーリングリストもできてる。

各位この問題にどう対処してる？的な問い掛けのセッションってことだったのかな。IETF 123で何かしらの進捗がありそう。

### QMux Formerly QUIC on Streams
* <https://datatracker.ietf.org/doc/draft-kazuho-quic-quic-on-streams/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-quic-qmux-formerly-quic-on-streams-01>

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">QUIC on Streams（QoS）名前が不評すぎてウケる🤣 ネタに走った名前をつけたことについては反省してます…</p>&mdash; Kazuho Oku (@kazuho) <a href="https://twitter.com/kazuho/status/1901621014989242548?ref_src=twsrc%5Etfw">March 17, 2025</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

QoS、言われるまで気づかなかったな……

"This will require a recharter" ということで、recharterが行われるかもしれない。

## tiptop
### Agenda
* <https://datatracker.ietf.org/meeting/122/session/tiptop>

"Taking IP To Other Planets" の略で、惑星間通信のようなRTTがなっっっがい環境における通信では、既存のプロトコルをそのまま展開するのが難しくなるので、そのための拡張などについて議論するworking group。

唯一リアルタイムで聞けたセッション(祝日だった)。tiptopのミーティングは今回が初だったので、記念すべき1回目(？)に参加できたのはよかったです。

### IP in Deep Space: Key Characteristics, Use Cases, and Requirements
* <https://datatracker.ietf.org/doc/draft-many-tiptop-usecase/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-tiptop-1-use-cases-requirements-00>

そもそもtiptopで想定しているユースケースとはどんなものかについてのdraft(だと思う)。月や火星のような領域がテーマで、低軌道、中軌道、静止衛星くらいまでの地球と近い距離における通信においてはスコープ外。

通信のユースケースとしては、宇宙船などへのコマンド送信、テレメトリデータの送受信、リアルタイムメディア、一時的に通信できない場合の遅延、緊急メッセージ(救助要請とか)、科学的データ、メッセージングとか。

セキュリティやパケロスの問題についての質疑が行われていた。

### An Architecture for IP in Deep Space
* <https://datatracker.ietf.org/doc/draft-many-tiptop-ip-architecture/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-tiptop-2-an-architecture-for-ip-in-deep-space-00>

non-goalとして挙げられているのは、Webサーフィン、sshなどのterminal access、Facetime(などのビデオ通話？)、何かしらのインタラクティブ性が要求されるものとか。

IPv4やIPv6には変更は不要だろう。deep spaceにおいては、パケットを転送する先が存在しない場合があるので、転送可能になるまで長期間保持しておく必要があるだろうというのは確かに。UDPはそのまま使えるが、QUICはRTTが数百ミリ秒であるのが通常なので、デフォルトの構成だと宇宙には持っていけない。これに関してはシミュレーション環境において適切なパラメータのもとではQUICスタックが機能することが確認されている。TCPに関しては未調査。HTTPは、Cache-ControlやExpiresなど時間がかかわってくるheaderを使うのは適していない。などなどなど。

### QUIC Simulation Results and Profile
* <https://datatracker.ietf.org/doc/draft-many-tiptop-quic-profile/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-tiptop-ip-in-space-quic-profile-and-simulations-00>

で、そのQUICをdeep spaceにもっていく場合の話。RTTが7日間にも及ぶというのはすさまじい。長いRTTのために、`initial_rtt`、`max_idol_timeout`などのパラメータを調整したプロファイルの話が出ている。実験環境というのはこれ <https://github.com/aochagavia/quinn-workbench> かな。

### Key Exchange Customization for TIPTOP
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-tiptop-key-exchange-customization-for-tiptop-00>

スライドの副題が "Implementing MLS inside QUIC" となっていてリアルに声が出た。QUICはセキュアな通信路の確立のためにTLSを使うけど、同期的な通信を要求する。かといって0-RTTではFoward Secrecyが低下する。そもそも非同期的に通信を行うため(？)にはContinuous Key Agreement (CKA)を行う必要があり、TLSはCKAではない。ならMLSを使おう！という提案。その発想はなかった。

![提出されたスライドで、QUIC protocol stack内でMLSを使うことを示している図](2025/ietf-122-bangkok-tiptop-quic-mls.png)

MLS詳しいパーソンからの解説が待たれる……

QUIC wgにも持っていこうという話になった。TLS Extended Key Updateなら解決するのか？という点に関しては、それも依然として同期的なために根本解決ではないという返答。

### その他
他にも、このwgで文章をどう編集していくかについて、GitHubでは特定の国からアクセスできない問題があるのでGitHubに依存したワークフローを採用するのが正しいのか？であるとか、使用すべきフォントは何にすべきか、自転車小屋の屋根は何色に塗るのかなどの質疑応答があった。できたばかりのwgなのでこれから色々決まっていくんでしょう。

## webtrans
### Agenda
* <https://datatracker.ietf.org/meeting/122/session/webtrans>

2月に亡くなられたBernard Aboba氏への追悼があった。

W3C WebTransport Updateはほぼ完了、最終的には9月にW3C勧告として公開される予定。変更点はリダイレクトをネットワークエラーとして扱うようになったり、`stats.atSendCapacity`が追加されたりと色々。

### Forward and Reverse HTTP/3 over WebTransport
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-webtrans-http3-over-webtransport-00>

WebTransport上にHTTP/3を実装する……？反応としてはこれは独自のWGでやるべきだとか、webtrans wgのcharterでは対象としてないとか、結構攻めた提案という印象。

## wish
### Agenda
* <https://datatracker.ietf.org/meeting/122/session/wish>

う～～んminutesが淡白！

<https://datatracker.ietf.org/doc/draft-ietf-wish-whip> がAUTH48になってるという議事録が残ってるけど、今見ると  <https://datatracker.ietf.org/doc/rfc9725/> もうRFC 9725になってましたね。

このwgは閉じられるのか？に関しては、whepがまだあるということでもうちょっと残る？

## masque
### Agenda
* <https://datatracker.ietf.org/meeting/122/session/masque>

### Proxying Listener UDP in HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-masque-connect-udp-listen/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-masque-connect-udp-bind-ietf122-00>
* <https://github.com/google/quiche/tree/main/quiche/quic/masque>

リクエスト、レスポンスのヘッダに `connect-udp-bind` を使うことで、proxyのportをbindする。前回からの更新はeditorialなもののみ。実装はGoogle QUICHEがある、他の実装も探していて、実装しようと思っている人はいる。充分な相互運用性が確認できたらWGLCになりそう。

### QUIC-Aware Proxying Using HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-masque-quic-proxy/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-masque-quic-aware-proxying-00>

Googleが実装に対して積極的だけど時間がない、次のIETFでconnect-udpと合わせてinterop testをやろうという提案があった。でも残ってるissueをcloseできたら、そのテストの前にWGLCにする予定？

### Proxying Ethernet in HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-masque-connect-ethernet/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-masque-masque-connect-ethernet-at-ietf-122-00>

121からの変更点は配信できないEthernet frameに関しては、endpointはdropしなければならなくなったことと、輻輳制御によるパフォーマンスの懸念事項が追加された。相互運用のための実装募集中。WGLCしたいけど、その前にIEEEからレビューを受けるべきという意見。

### DNS Configuration for Proxying IP in HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-masque-connect-ip-dns/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-masque-slides-for-connect-ip-dns-draft-00>

これも相互運用性の確認のための実装を募集中か～。

### The MASQUE Proxy
* <https://datatracker.ietf.org/doc/draft-schinazi-masque-proxy/>
* <https://datatracker.ietf.org/meeting/122/materials/slides-122-masque-the-masque-proxy-00>

スライドの写真、良い……状況は謎だけど。MASQUEを使うとはどういうことなのか？について明らかにするための文書。Informationalだ。実際、このdraftはMLS architectureのdraftからリンクが貼られている(RFC 9750になる？)。

これが文書としてまとまってるのはいいことだけど、pearg(Privacy Enhancements and Assessments Research Group)の仕事かもしれないという意見。これに時間を割いて議論すべきか？という投票は賛成多数で可決された。

## IETF 127について
IETF 127は**現時点で**2026年11月14日からの開催が予定されています。

* <https://www.ietf.org/meeting/upcoming/>
    * <https://web.archive.org/web/20250320030224/https://www.ietf.org/meeting/upcoming/> (3/20時点でのweb archive)

しかし、現在の米国の状況から、本当にサンフランシスコで開催するのかどうか、そしてサンフランシスコで開催された場合に現地参加できるのかどうかという懸念が高まっています。

これについては今回のPlenaryでも話題に挙がっており、1:57:28以降がそれについての議論です(多分)。ここで発言しているトランスジェンダーの方は、ドイツ政府から「あなたのパスポートで米国に入国しようとすれば、パスポートの詐称とみなされるので逮捕されるだろう」というアドバイスを受けたと述べています。

<iframe width="560" height="315" src="https://www.youtube.com/embed/kxAZYmuSIfI?si=KeSdevgZCJn6gvo0&amp;start=7045" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

マジかよ……という感じですね。そしてIETF 127をサンフランシスコから別の場所で開催することを検討しているのか？という質問に対しての返答は「3/5時点では開催地の移動はしないことになっている。ただし再度議論は行われる」というものでした。財政的にも厳しいというのは、Kaigi on Railsの運営として大人数が集まる会議の場所を抑えることの難しさを知っているので十分理解できますが、しかし入国するだけで逮捕される可能性があるっていうのはちょっとなあ……

そしてこんなページができていました。

<https://boycott-ietf127.org>

<blockquote class="mastodon-embed" data-embed-url="https://glauca.space/@q/114195658008535827/embed" style="background: #FCF8FF; border-radius: 8px; border: 1px solid #C9C4DA; margin: 0; max-width: 540px; min-width: 270px; overflow: hidden; padding: 0;"> <a href="https://glauca.space/@q/114195658008535827" target="_blank" style="align-items: center; color: #1C1A25; display: flex; flex-direction: column; font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Oxygen, Ubuntu, Cantarell, 'Fira Sans', 'Droid Sans', 'Helvetica Neue', Roboto, sans-serif; font-size: 14px; justify-content: center; letter-spacing: 0.25px; line-height: 20px; padding: 24px; text-decoration: none;"> <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="32" height="32" viewBox="0 0 79 75"><path d="M74.7135 16.6043C73.6199 8.54587 66.5351 2.19527 58.1366 0.964691C56.7196 0.756754 51.351 0 38.9148 0H38.822C26.3824 0 23.7135 0.756754 22.2966 0.964691C14.1319 2.16118 6.67571 7.86752 4.86669 16.0214C3.99657 20.0369 3.90371 24.4888 4.06535 28.5726C4.29578 34.4289 4.34049 40.275 4.877 46.1075C5.24791 49.9817 5.89495 53.8251 6.81328 57.6088C8.53288 64.5968 15.4938 70.4122 22.3138 72.7848C29.6155 75.259 37.468 75.6697 44.9919 73.971C45.8196 73.7801 46.6381 73.5586 47.4475 73.3063C49.2737 72.7302 51.4164 72.086 52.9915 70.9542C53.0131 70.9384 53.0308 70.9178 53.0433 70.8942C53.0558 70.8706 53.0628 70.8445 53.0637 70.8179V65.1661C53.0634 65.1412 53.0574 65.1167 53.0462 65.0944C53.035 65.0721 53.0189 65.0525 52.9992 65.0371C52.9794 65.0218 52.9564 65.011 52.9318 65.0056C52.9073 65.0002 52.8819 65.0003 52.8574 65.0059C48.0369 66.1472 43.0971 66.7193 38.141 66.7103C29.6118 66.7103 27.3178 62.6981 26.6609 61.0278C26.1329 59.5842 25.7976 58.0784 25.6636 56.5486C25.6622 56.5229 25.667 56.4973 25.6775 56.4738C25.688 56.4502 25.7039 56.4295 25.724 56.4132C25.7441 56.397 25.7678 56.3856 25.7931 56.3801C25.8185 56.3746 25.8448 56.3751 25.8699 56.3816C30.6101 57.5151 35.4693 58.0873 40.3455 58.086C41.5183 58.086 42.6876 58.086 43.8604 58.0553C48.7647 57.919 53.9339 57.6701 58.7591 56.7361C58.8794 56.7123 58.9998 56.6918 59.103 56.6611C66.7139 55.2124 73.9569 50.665 74.6929 39.1501C74.7204 38.6967 74.7892 34.4016 74.7892 33.9312C74.7926 32.3325 75.3085 22.5901 74.7135 16.6043ZM62.9996 45.3371H54.9966V25.9069C54.9966 21.8163 53.277 19.7302 49.7793 19.7302C45.9343 19.7302 44.0083 22.1981 44.0083 27.0727V37.7082H36.0534V27.0727C36.0534 22.1981 34.124 19.7302 30.279 19.7302C26.8019 19.7302 25.0651 21.8163 25.0617 25.9069V45.3371H17.0656V25.3172C17.0656 21.2266 18.1191 17.9769 20.2262 15.568C22.3998 13.1648 25.2509 11.9308 28.7898 11.9308C32.8859 11.9308 35.9812 13.492 38.0447 16.6111L40.036 19.9245L42.0308 16.6111C44.0943 13.492 47.1896 11.9308 51.2788 11.9308C54.8143 11.9308 57.6654 13.1648 59.8459 15.568C61.9529 17.9746 63.0065 21.2243 63.0065 25.3172L62.9996 45.3371Z" fill="currentColor"/></svg> <div style="color: #787588; margin-top: 16px;">Post by @q@glauca.space</div> <div style="font-weight: 500;">View on Mastodon</div> </a> </blockquote> <script data-allowed-prefixes="https://glauca.space/" async src="https://glauca.space/embed.js"></script>

ページを作成したのは、Plenaryで質問していたMisellさんですね。

> The IETF Administration LLC has decided to continue to hold meetings in the US, in spite of significant threats to the safety of the community in traveling there. As an Internet community we strive to include everyone. Holding a meeting in the US is incompatible with our values. We call on the IETF community to refuse to travel to the 127th IETF meeting, to be held in San Francisco.

> IETF Administration LLCは、米国への移動におけるコミュニティの安全に対する重大な脅威があるにもかかわらず、引き続き米国でミーティングを開催することを決定した。インターネット・コミュニティとして、私たちはすべての人を包含するよう努めています。米国で会議を開催することは、私たちの価値観と相容れない。われわれは、サンフランシスコで開催される第127回IETF会合への渡航を拒否するよう、IETFコミュニティに呼びかける。
> (DeepL訳)

このページの "The US is dangerous" の項目を見れば、永住権を持っていようが拘留されうるという状況になっているのがわかります。なんなら、この声明に賛同、署名してリストに名前を載せるだけで入国拒否されても不思議ではないのかもしれません。

## まとめ
毎度前回からのupdateを記載していますが、これまでの経緯なんかを自分でも参照するのが面倒になってきたので自分向けでもいいからどこかにまとめておきたくなってきました。