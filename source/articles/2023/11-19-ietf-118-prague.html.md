---
title: "IETF 118 Pragueにリモート参加しました"
date: 2023-11-19 17:40 JST
tags:
- ietf
- quic
- tls
- mls
---


![](2023/shimane-shinjiko.jpg)

## IETF 118 Prague
チェコの首都、プラハで開催されたIETF 118にリモートで参加したので、自分なりにまとめます。ただ今回、[RubyWorld Conference 2023](https://2023.rubyworld-conf.org/ja/)と日程が被ってしまったため、Meetecho(ライブで会議が行われる場所、Zoomの部屋みたいなイメージ)にはあまり入れずにYouTubeのアーカイブと議事録からのまとめとなります。英語の議論についていけないのでどのみちそうなるのですが……

写真はIETFとは全く関係ない、RubyWorld Conference 2023開催地である島根県は宍道湖の写真です。

例によって正確性の保証は一切いたしません。

## 参加したセッション
### QUIC

<https://datatracker.ietf.org/group/quic/about/>

* Agenda等
    * <https://datatracker.ietf.org/meeting/118/session/quic/>
* [draft-ietf-quic-ack-frequency-07: QUIC Acknowledgement Frequency](https://datatracker.ietf.org/doc/draft-ietf-quic-ack-frequency/)
    * WGLC (Working Group Last Call、RFCになる準備ができた段階)になって、11/27まで議論を受け付ける
* [Errata 7578 (RFC 9000)](https://www.rfc-editor.org/errata/eid7578)
    * RFC 9000、QUICのRFCに対するErrataについて。他のプロトコルの通信とQUICによる通信の多重化について？
    * RFC 9000を変更する(どう変更するかについても色々な案がある)か、[RFC 9443](https://datatracker.ietf.org/doc/rfc9443/)を変更するか(avtcore wgなので大変らしい？)という感じ。
    * 流れとしてはRFC 9000を変更して、"provide more info to implementers/leave risks up to them" という方向になりそう
* [draft-ietf-quic-multipath-06: Multipath Extension for QUIC](https://datatracker.ietf.org/doc/draft-ietf-quic-multipath/)
    * Path IDについての議論、そもそもそれを導入するかどうかで意見が分かれていて、今回の会議でも結論そのものは出なかった
        * [Proposal: Explicit path identification · Issue #179 · quicwg/multipath](https://github.com/quicwg/multipath/issues/179)
        * [separate Path IDs from Connection IDs · Issue #214 · quicwg/multipath](https://github.com/quicwg/multipath/issues/214)
        * Path IDとSequence IDをtupleとして扱うのはどうか？という案を進めていくことになったぽさ
* [draft-ietf-quic-reliable-stream-reset-03: Reliable QUIC Stream Resets](https://datatracker.ietf.org/doc/draft-ietf-quic-reliable-stream-reset/)
    * 資料PDFの1枚目の画像、何……
    * > We don’t make pretty protocols. We make protocols that work. Looks good = not a good reason to put it in a draft. Unless someone has a clear use case, strongly object to putting it in.
        * David Schinaziさんのこれ、良い
    * `STOP_SENDING_AT` はドラフトに含まれなくなりそう
* [draft-ietf-quic-qlog-main-schema-07: Main logging schema for qlog](https://datatracker.ietf.org/doc/draft-ietf-quic-qlog-main-schema/)
    * "This is the oppenheimer update" ってなんですか(わかるけど)(オッペンハイマー、日本で上映されるのかな)
    * ECN(Explicit Congestion Notification)についての情報が追加された
    * QPACKについてのログは記録されないようにしようという提案がある
* [draft-seemann-quic-address-discovery-00: QUIC Address Discovery](https://datatracker.ietf.org/doc/draft-seemann-quic-address-discovery/)
    * 下のNAT超えにも関わってくるdraft。STUNがその通信内容を暗号化しないので傍受ができる一方、QUICでやれば内容は暗号化できるのでより良い
* [draft-seemann-quic-nat-traversal-01: Using QUIC to traverse NATs](https://datatracker.ietf.org/doc/draft-seemann-quic-nat-traversal/)
    * NAT越えをQUICでやる話
* [draft-smith-quic-receive-ts-00: QUIC Extension for Reporting Packet Receive Timestamps](https://datatracker.ietf.org/doc/draft-smith-quic-receive-ts/)
    * 遅延を正確に計測することで帯域幅の計測がより正確になる、などのモチベーション
    * 興味がある人はもっと議論に参加してくれ、というおねがい
* [draft-kuhn-quic-bdpframe-extension-03: BDP_Frame Extension](https://datatracker.ietf.org/doc/draft-kuhn-quic-bdpframe-extension/)
    * 時間切れで触れられず
* [draft-michel-quic-fec-01: Forward Erasure Correction for QUIC loss recovery](https://datatracker.ietf.org/doc/draft-michel-quic-fec/)
    * これも時間切れで触れられず。MoQのほうでやるということに？

### Media Over QUIC (moq)
<https://datatracker.ietf.org/group/moq/about/>

今回もMedia Over QUICのSessionは2回ありました。議論の内容がメディア転送をやっていないとわからないようなものになってきて、いよいよ追うのに限界を感じています。

* Agenda等
    * <https://datatracker.ietf.org/meeting/118/session/moq/>
* [draft-ietf-moq-transport-01: Media over QUIC Transport](https://datatracker.ietf.org/doc/draft-ietf-moq-transport/)
    * よくMoQTと略されている
    * MoQのObject ModelをQUICにどうmappingするか
    * Subscriptionについて
        * 具体的には <https://www.ietf.org/archive/id/draft-ietf-moq-transport-01.html#name-subscribe_ok> とかの話で、ここのTrack Nameとして使える文字種をどうするか
            * <https://github.com/moq-wg/moq-transport/pull/329>
        * ひとつのendpointがあるtrackについてのsubscriptionを複数発行できるか？
            * <https://github.com/moq-wg/moq-transport/issues/269>
    * 等々…… :dizzy_face:
* Interop Readout
    * 具体的に何をしたのかうまく読み取れないけど、複数実装間でうまく通信できるかどうかHackathonで検証した、ということなのかな？
        * <https://wiki.ietf.org/en/meeting/118/hackathon#media-over-quic-moq>
        * 検証されたのは以下の実装……だと思う
            * <https://github.com/facebook/mvfst>
            * <https://github.com/kixelated/moq-rs>
            * <https://github.com/kixelated/moq-js>
            * <https://github.com/google/quiche>
            * <https://github.com/mengelbart/moqtransport>
            * <https://github.com/Quicr/libquicr>
        * 結果の表を見る限りではまだ相互運用性が高い状態とは言えなさそう
* [draft-wilaw-moq-catalogformat-01: Common Catalog Format for moq-transport](https://datatracker.ietf.org/doc/draft-wilaw-moq-catalogformat/)
    * JSON patchによる差分更新
        * そもそも [RFC 6902](https://datatracker.ietf.org/doc/rfc6902/) によってJSON Patchというものが標準化されているのか
            * 複雑そう……
        * CMAFの暗号化、DRMについて

### Transport Layer Security (tls)
<https://datatracker.ietf.org/group/tls/about/>

* Agenda等
    * <https://datatracker.ietf.org/meeting/118/session/tls/>
    * 8446bisを終わらせたい
        * Ready For Last Call!!
* [draft-ietf-tls-esni-17: TLS Encrypted Client Hello](https://datatracker.ietf.org/doc/draft-ietf-tls-esni/)
    * > The deployment considerations are hard to understand for a non-English speaker.
        * ウス……
        * https://github.com/tlswg/draft-ietf-tls-esni/pull/594 がその修正っぽい
    * ところで現時点でのEncrypted Client Helloの実装はこれだけあるそうです
        * https://github.com/tlswg/draft-ietf-tls-esni/wiki/Implementations
        * CloudflareはRustじゃなくてGoなのか、というかGo言語そのものをforkしてるのか
    * 色々なopen issueがあるけど、" ECH is complex." は……
        * > Proposed resolution: Leave as-is (close issue)
            * はい。
    * WGLCに向けて動き出しそう
* [draft-ietf-tls-rfc8447bis-05: IANA Registry Updates for TLS and DTLS](https://datatracker.ietf.org/doc/draft-ietf-tls-rfc8447bis/)
    * 推奨されない暗号スイートを更新
        * 例えばDES
* [draft-ietf-tls-ctls-09: Compact TLS 1.3](https://datatracker.ietf.org/doc/draft-ietf-tls-ctls/)
    * さらっと終わった
* [draft-thomson-tls-keylogfile-01: The SSLKEYLOGFILE Format for TLS](https://datatracker.ietf.org/doc/draft-thomson-tls-keylogfile/)
    * see also [TLSの復号に用いる SSLKEYLOGFILE のフォーマット提案仕様 - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2022/10/26/005331)
    * expiredだったけど、復活しそう！
* AuthKEM
    * 以下2つのdraftについて
        * [draft-celi-wiggers-tls-authkem-02: KEM-based Authentication for TLS 1.3](https://datatracker.ietf.org/doc/draft-celi-wiggers-tls-authkem/)
        * [draft-wiggers-tls-authkem-psk-00: KEM-based pre-shared-key handshakes for TLS 1.3](https://datatracker.ietf.org/doc/draft-wiggers-tls-authkem-psk/)
    * 耐量子暗号に適している？
    * 認証局がpost-quantumなroot証明書を持ってないじゃん、という指摘はなるほど
* [draft-rsalz-tls-tls12-frozen-02: TLS 1.2 is in Feature Freeze](https://datatracker.ietf.org/doc/draft-rsalz-tls-tls12-frozen/)
    * TLS 1.2の使用を非推奨にするものではなく、あくまでもアップデートされませんよ、という立場のdraftだという表明
* [draft-davidben-tls13-pkcs1-01: Legacy RSASSA-PKCS1-v1_5 codepoints for TLS 1.3](https://datatracker.ietf.org/doc/draft-davidben-tls13-pkcs1/)
    * TLS 1.3でCertificateVerifyにはRSASSA-PKCS1-v1\_5を使用できず、代わりにRSASSA-PSSが導入されたけど、古いハードウェアではまだRSASSA-PSSのサポートがされていないものが多いので、RSASSA-PKCS1-v1\_5を使用できるようにしようというもの
    * 賛成多数
* [draft-davidben-tls-key-share-prediction-00: TLS Key Share Prediction](https://datatracker.ietf.org/doc/draft-davidben-tls-key-share-prediction/)
    * TLS 1.3におけるnamed groupではsupported\_groupsとkey\_share拡張が使われるが、ここに曖昧さがあるので実装によって振る舞いが異なっている？そこをなんとかするdraft
    * DNS経由でsupported\_groupsあるいは何らかの暗号パラメータを渡す案もある(が、このdraftの範囲ではないかもしれない)？
    * もしかしたら8446bisが更新されるかも
* [draft-davidben-tls-trust-expr-01: TLS Trust Expressions](https://datatracker.ietf.org/doc/draft-davidben-tls-trust-expr/)
    * 説明が難しい……
    * あまり好印象ではない感じ。certificate_authorities拡張ではいけない理由が明確ではない？
* [draft-jhoyla-req-mtls-flag-00: TLS Flag - Request mTLS](https://datatracker.ietf.org/doc/draft-jhoyla-req-mtls-flag/)
    * スライドがCloudflareだ
    * crawlerが真正なものであるか識別するためにmTLSによるアクセスを要求したいけど、それだと人間が困る。なので「mTLS対応ですよ」とリクエスト時にサーバーに教える方法が欲しい、ということ。
    * 有用なのでは、という反応
* [draft-joseph-tls-turbotls-00: TurboTLS for faster connection establishment](https://datatracker.ietf.org/doc/draft-joseph-tls-turbotls/)
    * 時間切れで議論はなし

### Messaging Layer Security (mls)

<https://datatracker.ietf.org/group/mls/about/>

[RFC 9420: The Messaging Layer Security (MLS) Protocol](https://datatracker.ietf.org/doc/rfc9420/) が7月にRFCになったばかりですが、draft-ietf-mls-architecture-11がRFCになってくれたら、というかdraft-ietf-mls-extensions-03も結構重要な要素なので、要するにまだこれからという雰囲気を勝手に感じています。

そしてどちらかというとリソースがmimi(More Instant Messaging Interoperability)のほうに割かれてるのではないかということらしいです。しかしmimiのほうは追えておらず……

* Agenda等
    * <https://datatracker.ietf.org/meeting/118/session/mls/>
* [draft-ietf-mls-architecture-11: The Messaging Layer Security (MLS) Architecture](https://datatracker.ietf.org/doc/draft-ietf-mls-architecture/)
    * いくつかpull reqを閉じた、というくらいで特に話された内容はなし
* [draft-ietf-mls-extensions-03: The Messaging Layer Security (MLS) Extensions](https://datatracker.ietf.org/doc/draft-ietf-mls-extensions/)
    * Safe Extension threat model、この拡張は安全なのか？というのをどう保証するのか(ある拡張Aと拡張Bを組み合わせて使用した際にセキュリティ上脆弱になってしまうことはないのか？)
    * SelfRemove
        * 自身がある部屋から退出する操作についての定義
            * 現時点で退出の操作がアトミックではないという問題が未解決
    * 他にも色々

なんというか、mimiと合わせて見ていかないとだめそうです。

### Congestion Control Working Group (ccwg)

<https://datatracker.ietf.org/group/ccwg/about/>

* Agenda等
    * <https://datatracker.ietf.org/meeting/118/session/ccwg/>
* [draft-ietf-ccwg-rfc5033bis-02: Specifying New Congestion Control Algorithms](https://datatracker.ietf.org/doc/draft-ietf-ccwg-rfc5033bis/)
    * 輻輳制御アルゴリズムをIETFで標準化するにあたってのガイドライン。[RFC 5033](https://datatracker.ietf.org/doc/rfc5033/)を更新するもの。
* [draft-mathis-ccwg-safecc-00: Safe Congestion Control](https://datatracker.ietf.org/doc/draft-mathis-ccwg-safecc/)
    * 安全な輻輳制御アルゴリズムがどのように振る舞うべきかの文章？
        * `Freelance` ← かっこいい
* [draft-nishida-ccwg-standard-cc-analysis-01: Analysis for the Differences Between Standard Congestion Control Schemes](https://datatracker.ietf.org/doc/draft-nishida-ccwg-standard-cc-analysis/)
* Containing the Cambrian Explosion in QUIC Congestion Control
    * <https://dl.acm.org/doi/pdf/10.1145/3618257.3624811>
    * 特定のDraftの話ではなくて論文？
    * そもそも "Cambrian Explosion" っていうのは何だろう
        * <https://ja.wikipedia.org/wiki/カンブリア爆発>
    * QUIC実装で使われている複数の輻輳制御アルゴリズム(CUBIC, BBR, Reno等)を比較したもの？

### Building Blocks for HTTP APIs (httpapi)

<https://datatracker.ietf.org/group/httpapi/about/>

* Agenda等
    * <https://datatracker.ietf.org/meeting/118/session/httpapi/>
* [draft-ietf-httpapi-yaml-mediatypes-10: YAML Media Type](https://datatracker.ietf.org/doc/draft-ietf-httpapi-yaml-mediatypes/)
    * `application/yaml` を追加するもの
    * RFC Editor Queueにおいて EDIT 状態になっている
        * > Awaiting editing or being edited
* [draft-ietf-httpapi-link-template-02: The Link-Template HTTP Header Field](https://datatracker.ietf.org/doc/draft-ietf-httpapi-link-template/)
    * `Link-Template: "/{username}"; rel="https://example.org/rel/user"` みたいなheaderを使うことで、 `username` に値を挿入してURIを生成できる
        * 使いどころが文章からわからない……
    * 国際化をどうする、という問題が残っている
* [RFC 9457: Problem Details for HTTP APIs](https://datatracker.ietf.org/doc/rfc9457/)
    * RFCになったよ報告 :tada:
    * HTTP APIがmachine-readableなエラーを返すための仕様
        * `application/problem+json` とかで返す
* [draft-ietf-httpapi-api-catalog-00: api-catalog: A well-known URI to help discovery of APIs](https://datatracker.ietf.org/doc/draft-ietf-httpapi-api-catalog/)
    * とあるendpointがどのようなAPIを持っているかのを提供するための仕組み
    * 例えば `/.well-known/api-catalog` で提供する
    * GitHub repositoryが移動されることになった
* [draft-ietf-httpapi-patch-byterange-00: Byte Range PATCH](https://datatracker.ietf.org/doc/draft-ietf-httpapi-patch-byterange/)
    * PATCH requerstでbyterangeを指定することで特定のバイナリの一部のバイト列を更新できるようにする仕組み……？
    * `Content-Range` を使うことに対しての懸念、後方互換性は捨てて新しく設計してもいいのでは？という意見
* [draft-ietf-httpapi-link-hint-00: HTTP Link Hints](https://datatracker.ietf.org/doc/draft-ietf-httpapi-link-hint/)
    * あるendpointがどういうrequest、どういうcontent typeを受け取ることができるかのHintを提供できる仕組み？
    * "Pre-Defined HTTP Link Hints" として定義されている "formats" という言葉は変えてもいいんじゃないか、という議論
* [draft-ietf-httpapi-rest-api-mediatypes-04: REST API Media Types](https://datatracker.ietf.org/doc/draft-ietf-httpapi-rest-api-mediatypes/)
    * `application/openapi+yaml;version=3.1` みたいなのの定義
    * JSON schemaまわりで多くの問題が未解決
* [draft-ietf-httpapi-authentication-link-00: Link relationship types for authentication](https://datatracker.ietf.org/doc/draft-ietf-httpapi-authentication-link/)
    * expiredになっている。GitHub repoがないためにフィードバックを受けられないからでは？というので更新依頼を投げることになった
* [draft-ietf-httpapi-idempotency-key-header-04: The Idempotency-Key HTTP Header Field](https://datatracker.ietf.org/doc/draft-ietf-httpapi-idempotency-key-header/)
    * サーバーがidempotencyに対応してなくてもクライアントが送り付けられるようにしてもいいんでは？という提案
    * WGLCが迫っている
* [draft-ietf-httpapi-ratelimit-headers-07: RateLimit header fields for HTTP](https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers/)
    * クライアント側にRate Limitの情報を返すための仕組み
    * structured fieldを使うことでquotaの単位(リクエスト数なのかバイト数なのか)を明示したい
        * <https://github.com/ietf-wg-httpapi/ratelimit-headers/issues/128> かな？
* [draft-hha-relative-json-pointer-00: Relative JSON Pointers](https://datatracker.ietf.org/doc/draft-hha-relative-json-pointer/)
    * xpathみたいなののJSON版と思っていいのかな、xpathあんまり詳しくないけど……
        * "5.1.. Examples" がわかりやすい
    * JsonPathの人達と話すことになっている
        * <https://github.com/json-path/JsonPath>
        * 似てる……
* "Deprecation or Lifecycle?"
    * Linkが書いてなかったけど、[draft-ietf-httpapi-deprecation-header-02: The Deprecation HTTP Header Field](https://datatracker.ietf.org/doc/draft-ietf-httpapi-deprecation-header/) のことでいいだろうか？
        * [URLリソースの非推奨を示すDeprecationヘッダ - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2020/12/27/233402)
        * Lifecycle headerのほうがいいんじゃないかという意見が以前あったけど結局書かれていない
        * これかな？ <https://mailarchive.ietf.org/arch/msg/httpapi/hu9Tdckhf3GuZclbn4IWymlRK1c/>


### HTTP (httpbis)
<https://datatracker.ietf.org/group/httpbis/about/>

* Agenda等
    * <https://datatracker.ietf.org/meeting/118/session/httpbis/>
* [draft-ietf-httpbis-compression-dictionary-00: Compression Dictionary Transport](https://datatracker.ietf.org/doc/draft-ietf-httpbis-compression-dictionary/)
    * [Compression Dictionary Transport (Shared Brotli) によるコンテンツ圧縮の最適化 | blog.jxck.io](https://blog.jxck.io/entries/2023-07-29/compression-dictionary-transport.html) ですね
        * この記事が書かれた頃からの違いとして、individual draftからWG draftになっている
    * 圧縮アルゴリズム名の後ろにつく `-d` (例えば `br-d`) っていうのがDictionaryを表しているのかな？
    * `match` が `match-path`と、optionalな `match-search`, `match-dest` に分割された
* [draft-ietf-httpbis-rfc6265bis-13: Cookies: HTTP State Management Mechanism](https://datatracker.ietf.org/doc/draft-ietf-httpbis-rfc6265bis/)
    * [RFC 6265](https://datatracker.ietf.org/doc/rfc6265/) の改善
        * [Cookieの仕様改定版、RFC6265bisの議論 - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2017/04/26/080916) (2017年の記事)
        * [Cookie2 とは何か | blog.jxck.io](https://blog.jxck.io/entries/2023-08-19/cookie2.html) (2023年の記事)
        * 長生きなdraftですねえ
    * <https://github.com/httpwg/http-extensions/issues/2104> がどう決着するか次第という感じらしい
* [draft-ietf-httpbis-unprompted-auth-05: The Signature HTTP Authentication Scheme](https://datatracker.ietf.org/doc/draft-ietf-httpbis-unprompted-auth/)
    * Basic認証などでリソースに制限をかけることができるけど、そもそも制限のかかったリソースが存在することを秘匿したい。リソースの存在を知っている人がいきなり認証情報付きのリクエストを送信することでリソースを閲覧可能なようにしたい……というもの？
        * 例えばサーバーは認証に失敗した場合に401(Unauthorized)ではなく404(Not Found)を返さないとならない
    * これってもう動く実装があるんだろうか、WGLCまでには実装を1つ完成させたいという発言はあるけど
* [draft-ietf-httpbis-safe-method-w-body-03: The HTTP QUERY Method](https://datatracker.ietf.org/doc/draft-ietf-httpbis-safe-method-w-body/)
    * [新しいHTTPメソッド、QUERYメソッドの仕様 - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2021/11/09/231858)
    * 未解決の問題についてのレビューが主で、作業者の時間が取れずあまり進展はない
* [draft-ietf-httpbis-retrofit-06: Retrofit Structured Fields for HTTP](https://datatracker.ietf.org/doc/draft-ietf-httpbis-retrofit/)
    * そもそも[draft-ietf-httpbis-sfbis-04: Structured Field Values for HTTP](https://datatracker.ietf.org/doc/draft-ietf-httpbis-sfbis/) というのでHTTP headerの構造化を提案していて、これは既存のheaderのvalueを構造化して送るためにどうするか、というもの
        * 例えば `Date` を構造化して送信する場合は `SF-Date` で送信するとか
    * そろそろWGLC
* [draft-hewitt-ietf-qpack-static-table-version-02: The qpack_static_table_version TLS extension](https://datatracker.ietf.org/doc/draft-hewitt-ietf-qpack-static-table-version/)
    * QPACK初出以降で新しいheaderがいくつも増えたので、静的テーブルを更新してそのversionをネゴシエートできるようにしようというもの
        * QUIC wgじゃないの？とも思ったけど、HTTP/3のレイヤだから確かにhttpbisなのかも。
    * TLS extensionじゃなくてALPNやALPSでもいいのでは？という意見
        * ALPSっていうのがあるのか [draft-vvv-tls-alps-01](https://datatracker.ietf.org/doc/draft-vvv-tls-alps/)
            * [TLSハンドシェイク中にアプリケーション設定を送信可能にする提案仕様 (TLS ALPS) - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2020/06/29/015048)
            * expiredなので、復活させる時なのかも、という意見
        * それこそTLS wgにもっていく必要が出てくるかもしれない
    * 議論がもりあがっていた
* [draft-ietf-httpbis-resumable-upload-02: Resumable Uploads for HTTP](https://datatracker.ietf.org/doc/draft-ietf-httpbis-resumable-upload/)
    * 参照 [HTTPで再開可能なアップロードを可能にする提案仕様 - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2022/02/28/010418)
        * flano_yukiさんめちゃくちゃ書いててすごいな……
    * <https://tus.io/> が元になっている
        * > Members of the tus community helped significantly in the process of bringing this work to the IETF.
        * でもGitHubから見れるtus orgのメンバーは著者にはいないな
    * PATCHのためのContent-Typeをどうする問題
        * `application/octet-stream` なのか  `application/offset+octet-stream` なのか他の方法か
* [draft-ietf-httpbis-connect-tcp-01: Template-Driven HTTP CONNECT Proxying for TCP](https://datatracker.ietf.org/doc/draft-ietf-httpbis-connect-tcp/)
    * そもそもCONNECT methodを知りませんでした
        * [CONNECT - HTTP | MDN](https://developer.mozilla.org/ja/docs/Web/HTTP/Methods/CONNECT)
    * > As a result, classic HTTP CONNECT proxies cannot be deployed using virtual-hosting, nor can they apply the usual defenses against server port misdirection attacks
        * というのが問題意識らしい
    * 盛り上がってたみたいだけどいまいちピンとこない
* [draft-gupta-httpbis-per-resource-events-00: Per Resource Events](https://datatracker.ietf.org/doc/draft-gupta-httpbis-per-resource-events/)
    * あるリソースが更新されたときにクライアントがその通知を受け取ることができるというもの。Per Resource Events Protocolというものを定義する。
    * `Accept-Events` headerをクライアントが送信する
    * これどうやって通知を送るのかdraftを見てもちょっとよくわからない……
* [draft-toomim-httpbis-braid-http-03: Braid-HTTP: Synchronization for HTTP](https://datatracker.ietf.org/doc/draft-toomim-httpbis-braid-http/)
    * <https://github.com/braid-org/braid-spec>
    * > This is why web programming sucks
    * なかなか壮大な構想のように思える
        * `braid.org` が見れない

## まとめ
むずかしいですね。
