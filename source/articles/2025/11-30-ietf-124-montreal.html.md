---
title: "IETF 124 Montreal個人的まとめ"
date: 2025-11-30 12:15 JST
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
- tiptop
- happy
- scone
---

![](2025/ietf-124-montreal.png)

## IETF 124
IETF 124はRubyWorld Conference 2025と被ったのでリアルタイムで参加してませんでした。なんなら今回はチケットも買ってないです。

それでは例によって以下は個人的な感想を無責任に書き散らかしたものです。内容の誤りなどについては責任を取りません。ちなみになんですが、WG及びBoFは <https://datatracker.ietf.org/meeting/124/agenda> で開催された順に記載しています。多分。

## ccwg
### Agenda
* <https://datatracker.ietf.org/meeting/124/session/ccwg>

途中でアラーム？火災報知器？が鳴っていた。

### Hackathon Update
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-ccwg-hackathon-updates-00>

[RFC 8290のFQ-CoDel](https://datatracker.ietf.org/doc/html/rfc8290)と[draft-tahiliani-tsvwg-fq-pie](https://datatracker.ietf.org/doc/draft-tahiliani-tsvwg-fq-pie/)との比較などについての報告。また、Congestion Control Evaluation Suiteについての設計を準備中なのでfeedback求むとのこと。テストの再現性や"マルチパス"という言葉が指す意味について明確にすべきだという話があったようで。

### BBRv3
* <https://datatracker.ietf.org/doc/draft-ietf-ccwg-bbr/04/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-ccwg-bbr-update-00>

03から04での変更はTCP特有の記述をやめたこと、ProbeRTTの頻度についてのexperimental considerationsの追加、あとこまかな編集。open issueとしてまだnon-TCP transportに対しての一般化が残っているのとか、テストケースについてどうするとかの話があった。Googleの他に、Cloudflareが実装を持っていて、picoquicでも実装したという話があった。そこからのデータを求む、状態なのかな。


### Circuit Breaker Assisted Congestion Control
* <https://datatracker.ietf.org/doc/draft-ietf-mboned-cbacc/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-ccwg-cbacc-00>

そもそもMBONED WGにおいて5年前からwg draftになっているdraft-ietf-mboned-cbaccというものがあり、マルチキャストネットワークの環境において不適切な振る舞いをする受信者によってネットワークを過負荷に陥らせる状況を解決するための提案？[RFC 8084](https://datatracker.ietf.org/doc/html/rfc8084#section-3.2.3)に記載されている "Circuit Breaker" を実装するものとしているが、RFC 8084の定義とどこまで挙動を揃えるかについてが議題のひとつのよう(RFC 8084の記載に従うべきだという会場での意見があった)。

### SCReAMv2
* <https://datatracker.ietf.org/doc/draft-johansson-ccwg-rfc8298bis-screamv2/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-ccwg-scream-v2-00>

そろそろwg draftになるのかもしれない。これも01から05にかけてtransport protocol agnosticな変更(など)が入った。やっぱQUICの影響なのかなー？CCWGがメディアの輻輳制御に向けて取り組むべきかどうか？という投票が行われ、続けてSCReAMがスタート地点として適切か？という投票が行われた。SCReAMが適切かどうかについて反対票が1票あり、反対の内容としては動画適応用のレイヤーと制御用のレイヤーが必要だというもの。ちなみにChrome Canaryに実装が入っており、WebRTCでのlogがスライドに載っている。メディアの輻輳制御が今アツい(のか？)。

### Network Delivery Time Control
* <https://datatracker.ietf.org/doc/draft-ageneau-ccwg-ndtc/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-ccwg-network-delivery-time-control-00>

Netflixからだ。クラウドゲーミングにおけるRate Adaptationが背景にある。帯域というよりは即時性に主眼を置いた輻輳制御アルゴリズムなのかな。

### SEARCH (a New Slow Start Algorithm for TCP and QUIC)
* <https://datatracker.ietf.org/doc/draft-chung-ccwg-search/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-ccwg-update-search-better-slow-start-for-tcp-and-quic-00>

SEARCHは122ぶり？06から07での変更は日付のみ。Hystart++とSEARCHの違いについて、両者は似ているので、何が違う点なのかを説明しないといけないという会話があった。

### Christian's Congestion Control Code (C4)
* <https://datatracker.ietf.org/doc/draft-huitema-ccwg-c4-design/>
* <https://datatracker.ietf.org/doc/draft-huitema-ccwg-c4-spec/>
* <https://datatracker.ietf.org/doc/draft-huitema-ccwg-c4-test/>

QUIC wgでもよく見かける方の提案。動画コンテンツの配信に対して設計されている輻輳制御アルゴリズム。今回は紹介だけで終わった？実装とフィードバックを求む、状態。

## webtrans
### Agenda
* <https://datatracker.ietf.org/meeting/124/session/webtrans>

chairが交代して1人から2人へ。WGLCが数週間後にされるかも？

### W3C WebTransport Update
* <https://w3c.github.io/webtransport/>

W3Cのロゴ、変わったね。資料にMDNのBrowser compatibilityの画像が貼られてたけど、modern browsersのなかではSafariだけがまだ未対応(設定から手動で有効にしないといけない)。 とりあえず自分の端末では有効にしてみたけど、手っとりばやく試せるページってどこかにあるんだろうか。

<https://developer.mozilla.org/en-US/docs/Web/API/WebTransport#browser_compatibility>

CONNECT requestに対してヘッダーを追加できるようにするか？というのが会場で出た議論で、それはW3C/WHATWGで決めようということになった？Authenticationに関しては許可してほしいという要望も。


### Hackathon Interop Results
SafariとFirefoxでのinteropの結果が報告されている。SafariではCloudflareのMoQ serverに対してセッションの確立、データ通信は行えるもののvideo streamingに関して問題あり。FirefoxではCloudflareのMoQ serverに対してvideo streamが機能した、と。Firefoxは今draft 14の実装が進んでいる。

### WebTransport Open Issues
* <https://datatracker.ietf.org/doc/draft-ietf-webtrans-overview/11/>
* <https://datatracker.ietf.org/doc/draft-ietf-webtrans-http3/14/>
* <https://datatracker.ietf.org/doc/draft-ietf-webtrans-http2/13/>

最新のdraftと現在openなissueについて、draft-ietf-webtrans-overview、draft-ietf-webtrans-http3とdraft-ietf-webtrans-http2のそれぞれ。overview-11では "export keying material" というoperationの新規追加に関してなど。webtrans-http3についてはDoSについての話、WT_MAX_SESSIONSの話などがあった。

## wish
### Agenda
* <https://datatracker.ietf.org/meeting/124/session/wish>

12月にinterim meetingが行われそう。last callもまだまだ見えてこない感じかな。とりあえずWHEPが今どんな状況なのかを見ているだけではあるので、議論の様子とかはまとめないことにしました。

## tls
### Agenda
* <https://datatracker.ietf.org/meeting/124/session/tls>

今回は2回構成。

### Well-Known ECH
* <https://datatracker.ietf.org/doc/draft-ietf-tls-wkech/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-tls-wkech-01>

draftのrepositoryがGitHubのtlswg orgに移動した。すべてのopen issueとコメントを解決したので、新しいバージョンを出してWGLCに進む予定。

### Extended Key Update
* <https://datatracker.ietf.org/doc/draft-ietf-tls-extended-key-update/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-tls-draft-ietf-tls-extended-key-update-06-00>

現在はさらなる実装とレビューを求めている状態。FATTによるレビューも進行中。

### Large Record Sizes for TLS and DTLS with Reduced Overhead
* <https://datatracker.ietf.org/doc/draft-ietf-tls-super-jumbo-record-limit/>

すべてのopen issueに対応済みで、実装作業中。WGLCに進むかどうかについて、WGLCになってから実装がでてくるのを待つのはどうか？という話があった。

### ML-KEM Post-Quantum Key Agreement for TLS 1.3
* <https://datatracker.ietf.org/doc/draft-ietf-tls-mlkem/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-tls-ml-kem-post-quantum-key-agreement-for-tls-13-00>

open issueがあったが解決？して "Decide to close the PR and go to WGLC" ということになった。

### A Password Authenticated Key Exchange Extension for TLS 1.3
* <https://datatracker.ietf.org/doc/draft-ietf-tls-pake/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-tls-draft-ietf-tls-pake-01>

wg draftとしてapproveされた。いくつかのopen issueはあるが、ほぼ全てに対応するpull reqが作成されている。パスワード認証を試行できる回数に制限があるべきというのは確かに。

### DE Reports
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-tls-tls-registries-update-00>

minutesやAgendaには "DE Reports" とあるけど、TLS Registries Updateのこと？色々なupdateについての共有。fun factとされているgit repositoryはどこのことなんだろうか。追加されたCipher Suiteの名前に登場するAsconについてはあとで見ておきたい。

* <https://ascon.isec.tugraz.at/>
    * > Ascon is a family of lightweight cryptographic algorithms designed to be efficient and easy to implement, even with added countermeasures against side-channel attacks.
* <https://github.com/ascon/ascon-c>

### The Datagram Transport Layer Security (DTLS) Protocol Version 1.3
* <https://datatracker.ietf.org/doc/draft-ietf-tls-rfc9147bis/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-tls-rfc9147bis-aka-dtls-00>

リプレイ検出についてのopen issueに対する議論が盛り上がってた？nvidiaがunencryptedなsequence numberを許可する拡張についての提案をしているっぽい。なんでだろう？反対する意見はなかった。既存のerrataをおさらいする流れ。

### PEM file format for ECH
* <https://datatracker.ietf.org/doc/draft-farrell-tls-pemesni/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-tls-pem-file-format-for-ech-01>

複数の鍵を扱いたい場合にどうするか、秘密鍵なしの設定ファイルは可能か、などの議論。

### Authenticated ECH Config Distribution and Rotation
* <https://datatracker.ietf.org/doc/draft-sullivan-tls-signed-ech-updates/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-tls-draft-sullivan-tls-signed-ech-updates-00-00>

Cloudfrareはこれに取り組んでいる(？)とのことだが、GoogleがECHのconfigを配布する際に直面した問題はこれでは解決できないという指摘。

### Service Affinity Solution based on Transport Layer Security (TLS)
* <https://datatracker.ietf.org/doc/draft-wang-tcpm-tcp-service-affinity-option/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-tls-service-affinity-solution-based-on-transport-layer-security-tls-00>

Expiredなdraft。この提案はTLSでやるべきことではないのでは？という指摘(application layerでやるべき？)。メーリスで議論しようという話になった。

## httpapi
* <https://datatracker.ietf.org/meeting/124/session/httpapi>

### link-hint
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-link-hint/>

editorialな変更のみ。もうすぐWGLC状態？

### patch-byterange
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-patch-byterange/>

変更なし。実装求む！状態。

### idempotency
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-idempotency-key-header/>

まだWGLCには進めない。いくつかのopen issueがあり、それについて作業が残っている状態。

### ratelimit-headers
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers/>

HTTPDIRのレビュー待ち状態。RateLimit-Policyヘッダーの値として指定するポリシー名をStringとして記載するべきなのかTokenとして記載すべきなのかのopen issueについての議論が行われていた。String優勢？

### HTTP Events Query
* <https://datatracker.ietf.org/doc/draft-gupta-httpapi-events-query/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-httpapi-events-query-00>
* <https://github.com/cxres/events-query-express-demo>

新しいdraft。`Uses the QUERY method to request notifications` とあるようにQUERY methodの活用。そもそも標準とすべき内容なのかについてより明確化しようという感じになった。

### authentication-link
* <https://datatracker.ietf.org/doc/draft-pot-authentication-link/>

このまま誰も取り組む人がいなければそのまま破棄される流れに……

## moq
### Agenda
* <https://datatracker.ietf.org/meeting/124/session/moq>

MoQに関しては、もう何もわから～ん状態ではあるのであまり深追いしないことにしました。業界の動向としては[yuki_uchidaさんのZenn scrap](https://zenn.dev/yuki_uchida/scraps/32256e09e3a4a5)が更新され続けていてとてもありがたいので皆さん読みましょう。

個人的に気になる動向としては <https://openmoq.org/> なるものができたこと。Roadmapでは現在Legal structure & governance in progressのためのCompany setupを進めているところらしい。

## webbotauth
### Agenda
* <https://datatracker.ietf.org/meeting/124/session/webbotauth>

いろいろと白熱して、WGとするには早かったかもしれない、別のBoFをやるべきだったかも、とchairが最後にまとめている。これからどうなるんだろう。

### WebBotAuth Architecture
* <https://datatracker.ietf.org/doc/draft-meunier-web-bot-auth-architecture/>

既にいくつかの実装がある。なんなら[Rubyもある](https://github.com/nomadium/linzer/blob/a2263804988528f54ef37dc1dbcbd3c499d735b4/spec/integration/cloudflare_example_research_spec.rb)。

ただ、Architecture文章なのにtest vectorがあるのはなぜか、なぜ署名が必要なのか、mTLSでいいのではないかなどの質問や意見があり、そもそも解決しようとしている課題は何なのかについて明確にすべきだという声が大きかった。

そんな感じだったのでchairが予定を変更し、問題の背景についておさらいする流れになった。

### Web Bot Auth Background and Context
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-webbotauth-background-00>

という流れがあり、前回(123)のスライドを再度見直すことに。改めて、インターネットはユーザーのためのものであり、匿名によるブラウジングを殺したくはない、Botの識別ではなく、高トラフィックをもたらすBotからの保護という観点で考えるべきだという意見があった。メールとスパムの問題に酷似しているので、そこから学べることがあるのでは？という指摘も。

### Mission-Critical Web Data Use Cases & Web Bot Auth Bot-Auth Implications
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-webbotauth-mission-critical-web-data-the-bot-auth-threat-01>

政治活動、Eコマース、旅行、不動産などの分野でWebスクレイピングは重要だが、Web Bot Authによって競合となる相手をblockすることが可能になるのでは(WalmartがAmazonをblockする、XがCCDH、デジタルヘイト対策センターをblockする、など)ないか、データ提供における差別を標準化することになるのではないかという懸念についての発表。人間がアクセスできる限りはBotも何かしらの方法を見つけて回避する、といういたちごっこになる。アクセス制御ではなく、認定する制度を設けるべきではという提案。

## scone
### Agenda
* <https://datatracker.ietf.org/meeting/124/session/scone>

そもそもsconeについてあまり知らなかったのだけど、Fastly Yamagoya Nightに参加してkazuhoさんの発表を聞き、そんなのがあるんだ～と興味が出たので見ています。

<iframe class="speakerdeck-iframe" frameborder="0" src="https://speakerdeck.com/player/a993491b858744079141c77907e2e631" title="SCONE - 動画配信の帯域を最適化する新プロトコル" allowfullscreen="true" style="border: 0px; background: padding-box padding-box rgba(0, 0, 0, 0.1); margin: 0px; padding: 0px; border-radius: 6px; box-shadow: rgba(0, 0, 0, 0.2) 0px 5px 40px; width: 100%; height: auto; aspect-ratio: 560 / 315;" data-ratio="1.7777777777777777"></iframe>

## Interop
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-scone-scone-hackathon-summary-00>

おいしそう。複数の実装間でInterop testが行われた結果の報告があった。ブラウザ上のdemo？ではSCONEを有効にした場合の動画視聴ではバッファリングが発生していない様子のデモがあったり、そのうちAndroid Facebook appのReelsで使われている様子の録画があった。SCONEが使われるとReelsでバッファリングしていない様子が紹介されている。その辺のやりとりがQUICの開発者が集まってるSlackに #scone-interop channelが作られていてやりとりされている。(デモの録画もSlackに上がってそうな見た目だったけど探しても見付からなかったな……)

before SCONE/after SCONEの条件は揃っているのか？という指摘もあったり。その辺厳密に揃えるのはむずかしそう。

###  draft-ietf-scone-protocol-03
* <https://datatracker.ietf.org/doc/draft-ietf-scone-protocol/03/>
* <https://github.com/ietf-wg-scone/scone>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-scone-what-is-a-scone-network-element-scone-00>

"network element" とは何か、というpull reqについての議論。現在のdraftにおいて定義されている機能は全て必須なのかどうか。最小限のnetwork elementが満たす機能としては何かというslideでの説明などなど。

他にも用語の統一などのpull reqのmergeなど。ライブでmergeされていく様子が見れた。

## Applicability & Manageability Considerations for SCONE
* <https://datatracker.ietf.org/doc/draft-mishra-scone-applicability-manageablity/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-scone-applicability-manageability-draft-02>

3GPP固有の内容が多いという意見があった。投票の結果、汎用的な部分(Section 3)までをWG draftとして採用する方向になった？

## httpbis
### Agenda
* <https://datatracker.ietf.org/meeting/124/session/httpbis>

<https://httpworkshop.org/> なんてものがあるんですねえ。2026年はスイスで開催とのこと。

### Template-Driven CONNECT for TCP
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-connect-tcp/>

CONNECTはHTTP/2やHTTP/3ではRFCに記載されているが、HTTP/1.1では規定がないのでどうする問題がある、と。

### Resumable Uploads for HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-resumable-upload/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-httpbis-resumable-uploads-00>

    WGLCになっていて、フィードバックを受けている。28のopen issues、6のopen pull reqがある状態。アップロードが完了したが、そのレスポンスを受け取れなかった場合に回復できない問題についてや、HEADリクエストについての規定があるがGETリクエストの場合がない、その場合にどうするか、などのopen issuesについて議論が行われた。

### HTTP Unencoded Digest
* <https://datatracker.ietf.org/doc/draft-pardue-httpbis-identity-digest/>

WGLCに進むことになった。

### Secondary Certificate Authentication of HTTP Servers
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-secondary-server-certs/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-httpbis-secondary-certificate-authentication-of-http-servers-00>

"Support sending Exported Authenticators in multiple frames over HTTP/2" のissueに関して、複雑さを増すだけということになりcloseで合意となった。editorialな変更を済ませてWGLCに進むことに。

### Cookies: HTTP State Management Mechanism
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-layered-cookies/>
* <https://datatracker.ietf.org/doc/draft-amarjotgill-origin-bound-cookies-protocol/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-httpbis-origin-bound-cookies-00>

draft-ietf-httpbis-layered-cookiesのメカニズムを更新して "Origin-Bound Cookies" としている。Cookieの識別にPort番号も含めるようにするPort Boundと、httpとhttpsを明確に区別するScheme Boundの2つの概念の導入(HTTPの文脈におけるOriginで識別する)。

すごく好意的な反応で、この提案をdraft-ietf-httpbis-layered-cookiesに取り込もうという流れに。

### Detecting Outdated Proxy Configuration
* <https://datatracker.ietf.org/doc/draft-rosomakho-httpbis-outdated-proxy-config/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-httpbis-detecting-outdated-proxy-configuration-00>

PAC/PvDによるプロキシ設定は全てpull型で、クライアントが定期的にフェッチするしかない問題を解決するもの。クライアントが `Proxy-Config` ヘッダーで設定のURLといつfetchしたかを送信すると、Proxyが `Proxy-Config-Stale` ヘッダーにbool値を入れて返してくれるというもの。絶対に欲しい！という声があった。adoption callがされる雰囲気。

### Unbound DATA frames in HTTP/3
* <https://datatracker.ietf.org/doc/draft-rosomakho-httpbis-h3-unbound-data/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-httpbis-unbound-data-frames-in-http3-00>

`UNBOUND_DATA` frameの送信後は全て `DATA` として扱うようにする提案？WebTransportでよくない？という意見があった。ちょっとこのままではなんとも、という感じだったのか、議論を続けましょうという感じに。

### HTTP/1.1 Request Smuggling Defense using Cryptographic Message Binding
* <https://datatracker.ietf.org/doc/draft-nygren-httpbis-http11-request-binding/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-httpbis-http-request-smuggling-defenses-00>

HTTP/1.1の実装間における差異を利用したRequest Smugglingが問題なっている。これについての防御が必要だと。`Bound-Request` ヘッダーと `Bound-Response` ヘッダーを利用して、番号の欠落、順序の不正をOrigin server側で検知したら中断するという提案？継続して議論を行うということに。

## tiptop
### Agenda
* <https://datatracker.ietf.org/meeting/124/session/tiptop>

時間切れでCoAP in SpaceとDNS over MoQについては議論できず。……DNS over MoQ？！？！

### Detailed Security Considerations in Deepspace
* <https://datatracker.ietf.org/doc/draft-ietf-tiptop-usecase/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-tiptop-detailed-security-considerations-for-deepspace-00>

deepspaceにおけるセキュリティの問題について。handshakeに時間がかかったり欠損することでsecureな通信路を確立できなかったり、そもそもパケロス、遅延がセキュリティに対して影響を及ぼす。MLSが解決策のひとつとして挙げられている。

### QUIC to the moon measurements
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-tiptop-quic-to-the-moon-measurements-00>

RTTに1～9秒、通信断がなし、または2～5秒、パケロス率が0～5%などの過酷な環境におけるQUICの性能評価。Quicheでは通信断が発生した場合にcrypto failが10%の確率で発生した、などの結果の報告。

### Hackaton Report
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-tiptop-ietf124-deep-spacetiptop-hackathon-experiment-report-00>

地球から月(2秒の遅延)、地球から火星(4分の遅延)への通信をシミュレーションした結果の報告。月環境(2秒のRTT)においてはDiscord、Apple Messages、Slackなどは動作した。QUICも動いた、YouTubeも問題なし、IMAPSはfetchできず、SSHはまあ動いたという感じ。実際の環境では通信断が発生した場合にはもっと長い時間通信できなくなるのではという指摘があった。

### Architecture for IP in Deep Space
* <https://datatracker.ietf.org/doc/draft-many-tiptop-ip-architecture/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-tiptop-architecture-for-ip-in-deep-space-01>

自分が理解できた範囲では、IPv6のみとするべきでは？という意見が挙がっていたことくらいか……

## happy
### Agenda
* <https://datatracker.ietf.org/meeting/124/session/happy>

### Happy Eyeballs Version 3
* <https://datatracker.ietf.org/doc/draft-ietf-happy-happyeyeballs-v3/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-happy-happy-eyeballs-v3-00>

ラブブ？"Generalize connection establishment" の結果として、TCP、QUICなどのトランスポートのhandshakeに限らず、TLS handshake(証明書の検証)まで含められるようになった。open issue/pull reqについての議論がめっちゃある。QUICの接続が遅かった場合でも接続に成功するのであればQUICのconnectionを保持しておいてそっちに切り替えるべきでは？いやそれはmultipathになってしまい、そしてhappy eyeballsはmultipathではないという指摘とか、色々な……

### HEv3 Configurable Values and How to Tune Them?
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-happy-hev3-configurable-values-and-how-to-tune-them-01>

draftで示されているHEv3の設定値についてどのように決めるべきなのかについて。その値がそうなった理由の明記や、その値が何によって(物理的な要因、政治的な要因、既存の慣習)決められているかを区別すべきだなどの意見があった。

### Happy Eyeballs Webtester
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-happy-happy-eyeballs-webtester-00>
* <https://www.happy-eyeballs.net/>

これはツールの紹介という感じか。ブラウザ上で試せるHappy Eyeballsのテスター。

## quic
### Agenda
* <https://datatracker.ietf.org/meeting/124/session/quic>

recahrterが完了し、"The fourth area of work" としてQUIC stream multiplexingが追加された。

### qlog
* <https://datatracker.ietf.org/doc/draft-ietf-quic-qlog-main-schema/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-quic-qlog-00>

未だにQLOGなのかQlogなのかqlogなのかの表記揺れが……(draftでは文頭にあるのに "qlog" なので全小文字が正しいのか？)。IETF 123以降では1回のinterim、draftの新しいversionのpublishがあった。WGLCに進むためには2つのissueがblockerになっている。qlog関連のツールとして、qlog-dancerというのが新規に実装されたのと、qvisのupdateが進行中。他にもqlogの定義がtsvwgやmoqのdraftでも使われはじめている。

qlogの適用範囲を拡大するissue, pull reqが現在openだが、それらの作業はやめて公開作業に進むべきだという議論。拡張性に関しては別draftにしてもいいのでは？という意見も。

### QUIC Ack Receive Timestamps
* <https://datatracker.ietf.org/doc/draft-ietf-quic-receive-ts/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-quic-quic-packet-receive-timestamps-00>

 wg draftになった。openなpull reqはない。timestamp情報をどう付与するかで意見が対立していそう。

### QUIC stream multiplexing
* <https://datatracker.ietf.org/doc/draft-opik-quic-qmux/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-quic-qmux-00>

quickyのPoCはh2oとのintegrateまで含めて1日、quic-goとのinteropもhackathonで動いたという報告。"Is this draft a suitable starting point for adoption to satisfy the WG’s new chartered work item." という投票に関してはYesが多数だった。Noの場合でも現在のdraftに編集を加えればよいという立場。

### New Server Preferred Address
* <https://datatracker.ietf.org/doc/draft-munizaga-quic-new-preferred-address/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-quic-new-preferred-address-00>

サーバー側が新しいIPアドレスにmigrateする方法を提供するもの。例えばp2pの状況ではclientとserverは区別できないから必要。p2p通信おいて有用であるため、作業を進めるべきだという意見があった。

### Exchanging CC data in QUIC
* <https://datatracker.ietf.org/doc/draft-yuan-quic-congestion-data/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-quic-exchanging-cc-data-in-quic-01>

TikTokではもう稼動している？異なる実装の間で微調整が入っている輻輳制御において、データを共有して有用なのかが疑問との指摘。

## masque
### Agenda
* <https://datatracker.ietf.org/meeting/124/session/masque>
* <https://github.com/ietf-wg-masque/wg-materials/pull/15>

minutesがない……3つのdraftがIESGへの提出準備完了、1つのdraftがWGLCに近付いている。Rechartering、ひいてはWGのsunsetについても取り上げられた。

### DNS and PREF64 Configuration for Proxying IP in HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-masque-connect-ip-dns/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-masque-dns-and-pref64-configuration-for-proxying-ip-in-http-00>

前回は "DNS Configuration for Proxying IP in HTTP" という名前だったけど、PREF64が追加されて今の名前に。今は実装を進めていて、interopに興味ある人を募集中という段階だと。

### Reusable templates and checksum offload for CONNECT-IP
* <https://datatracker.ietf.org/doc/draft-rosomakho-masque-connect-ip-optimizations/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-masque-reusable-templates-and-checksum-offload-for-connect-ip-00>

MTUの制限、checksum計算の負荷を軽減するために同じflowで何度も出てくる情報をstatic segmentとして定義、送信側はdynamicな情報を送信し、受信側ではstatic+dynamicで再構築。圧縮アルゴリズムではだめなのかという質問に関しては、channelが分かれている場合に適用できないのでだめだったと。

### ECN and DSCP support for HTTPS's Connect-UDP
* <https://datatracker.ietf.org/doc/draft-westerlund-masque-connect-udp-ecn-dscp/>
* <https://datatracker.ietf.org/meeting/124/materials/slides-124-masque-ecn-and-dscp-support-for-httpss-connect-udp-00>

ECN値をContext IDにエンコードするのか、DCSPとECNを合わせて1 byteにしてpayloadの前に付けるか。また、Request/Response headerにつけるかCapsuleとして送信するか。組み合わせ爆発の心配や、MTUを削ることに対する懸念などが挙げられた。メーリスで議論を続けるということに。

## まとめ
興味のあるwgがいくつもあってまとめるのが大変になってきたので、何かしら対策したいところ……
