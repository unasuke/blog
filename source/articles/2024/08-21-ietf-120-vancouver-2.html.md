---
title: "IETF 120 Vancouverにリモート参加しました その2"
date: 2024-08-21 01:40 JST
tags:
- ietf
- httpbis
- httpapi
- masque
- webtrans
- ccwg
- moq
---

![](2024/ietf120-vancouver.png)

## IETF 120 Vancouver
前回の続きです。

前回 → [IETF 120 Vancouverにリモート参加しました](/2024/ietf-120-vancouver)

## 参加したセッション
例によって、以下常体と敬体が入り乱れます。

### httpbis
mozaic.fmの方々による復習がX上で行われていたので、そちらを参考してもらうほうがいいような気がしますが……一応自分でもまとめます。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">IETF120 復習 - Google ドキュメント<a href="https://t.co/M7tRiPAcik">https://t.co/M7tRiPAcik</a></p>&mdash; mozaicfm (@mozaicfm) <a href="https://twitter.com/mozaicfm/status/1817908131323945246?ref_src=twsrc%5Etfw">July 29, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

#### Agenda
<https://datatracker.ietf.org/meeting/120/session/httpbis>

#### Resumable Uploads
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-resumable-upload/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-httpbis-sessb-resumable-uploads-00>

再開可能なアップロード。[HTTPで再開可能なアップロードを可能にする提案仕様 - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2022/02/28/010418)

minutesによると大まかな議題は3つで、Upload-Limitはproxyとorigin serverのどちらによってセットされるのか、Upload size、サーバーからのdigestのリクエストについて。

#### QUERY
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-safe-method-w-body/>
* <https://github.com/httpwg/http-extensions/issues?q=is%3Aopen+is%3Aissue+label%3Asafe-method-w-body>

特に資料はなし、expired & archivedになってるけど……

"weather in Vancouver" という検索をした場合に返却されるのは現在の天気へのリンクか、これまでの天気をリストしてあるページへのリンクかという議題と、Cacheについての議題。質問した人はdraftのautherになるべきだろうという結論になっている。

#### Cache Group
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-cache-groups/>

openなissueがないのでReady for last callとのこと。実装が無い？というところが気になるけど、既存のコードとの互換性がある(？)のでいいのでは、ということになっている？

#### Communicating Proxy Configs in Provisioning Domains
* <https://datatracker.ietf.org/doc/draft-ietf-intarea-proxy-config/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-httpbis-pvd-proxy-discovery-00>
* <https://github.com/tfpauly/privacy-proxy/issues>

httpbisではなくintareaからのもの。Motivationとしてはモダンなproxy typeの探索、既存のシンプルなproxy設定との共存、PACファイル、WPADへの依存をなくす、とあるけどこれは何……？

* [プロキシー自動設定ファイル - HTTP | MDN](https://developer.mozilla.org/ja/docs/Web/HTTP/Proxy_servers_and_tunneling/Proxy_Auto-Configuration_PAC_file)
* [WPAD について | Japan Developer Support Internet Team Blog](https://jpdsi.github.io/blog/internet-explorer-microsoft-edge/wpad/)

なるほど。で、それらに依存しない方法として、[Provisioning Domain(PvD) JSON format](https://datatracker.ietf.org/doc/rfc8801/)に対してproxyのサポートを追加しようというもの。提案しているのはAppleの人とMicrosoftの人。Private Relayが関連している可能性がありそう。資料では、 `/.well-known/pvd` に対してGETすることを想定している。認証についてや、クライアント証明書についての設定がどうなるかについての疑問が出ている。

#### Security Considerations for Optimistic Use of HTTP Upgrade
<https://datatracker.ietf.org/doc/draft-schwartz-httpbis-optimistic-upgrade/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-httpbis-sessa-security-considerations-for-optimistic-upgrade-00>
* <https://github.com/httpwg/http-extensions/labels/optimistic-upgrade>

<https://http.dev/> というサイトがあるんですねえ。openなissueについての議論が行われた様子。

#### Secondary Certificate Authentication of HTTP servers
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-secondary-server-certs/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-httpbis-secondary-certificate-authentication-of-http-servers-00>

[HTTPレイヤで追加のサーバ証明書を送信する Secondary Certificate の仕様について - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2023/09/11/002454)

なるほど……議論としては証明書のサイズの問題に関すること以外はちょっとわからない。

#### The HTTP Wrap Up Capsule
* <https://datatracker.ietf.org/doc/draft-schinazi-httpbis-wrap-up/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-httpbis-the-http-wrap-up-capsule-00>

Privacy Proxy(Priovate Relayみたいなの？)においてlong-livingなstreamを終了したいが、ブラウザからはリクエストが処理されたかどうか不明な場合にはそのリクエストを再試行できない。クライアントがあるstreamにおけるリクエストを中断して別のstreamもしくはconnectionに対して新しいリクエストを送信できるように、proxyのような仲介者が実際の終了が行われる前にそろそろ終了する通知を送るようにできるのが最善。なので、proxyがそのconnectionで新規のリクエストを開始すべきでないと通知し、既存のリクエストの終了を可能にする WRAP_UP カプセルの提案。(abstractの要約)

GOAWAYではなく？という質問に対して、GOAWAYはproxy自体がいなくなることを表し、これはリクエストごとに対する通知になるという返答があった、くらいしか読み取れず。webtransportに似たような提案がある？

#### HTTP No-Vary-Search
* <https://datatracker.ietf.org/doc/draft-wicg-http-no-vary-search/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-httpbis-sessa-no-vary-search-00>
* <https://wicg.github.io/nav-speculation/no-vary-search.html>

`No-Vary-Search` というヘッダーで、URLのparamsに入っているものがレスポンスに影響するかどうかを知らせることができるようになる。なのでparamsのバリエーションによるキャッシュのうんぬんを制御できるってことだろうか。既にChromeにはサポートが入っているっぽい？call for adoptionされそう。

#### Revising Cookies
* <https://github.com/johannhof/draft-annevk-johannhof-httpbis-cookies>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-httpbis-sessa-cookies-future-00>

"Yet another cookie spec revision! But why?!"

[Cookieの改訂版仕様 rfc6265bis の変更点 - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2024/05/07/002720) 既にある6265bisではなぜいけないのか。それは "cookie store"の概念を明確に定義したいからだ、Webブラウザ以外のagent(例えばcurlとか？)がどのようにcookieを扱うかを定義するためだ、と。6265bisの編集者から好意的に受け止められている。

#### Versioning for HTTP Resources
* <https://datatracker.ietf.org/doc/draft-toomim-httpbis-versions/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-httpbis-versioning-for-http-resources-00>

あるリソースを共同編集している場合や、Gitリポジトリのホスティングなどにおいて、リソースのバージョンとその祖先についての情報をリクエストヘッダに付与することでなんかいろいろできるようにしようという提案。最終的に目指すところまでには4つの提案が必要と言ってて、これはその最初の1つらしい。す、すごい。もっと議論が必要というところで終わっている。

### httpapi
#### Agenda
<https://datatracker.ietf.org/meeting/120/session/httpapi>

スライドはほぼない感じ。大部分はChair slideに書いてあるのかな。

<https://datatracker.ietf.org/meeting/120/materials/slides-120-httpapi-chair-slides-00>

#### The Idempotency-Key HTTP Header Field
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-idempotency-key-header/>

まだまだ議論中という感じ。8月末までに合意が得られるようにしたいとのこと。

#### Link relationship types for authentication
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-authentication-link/>

SECDIRからの早期レビューを受けたとのこと。

#### HTTP Link Hints
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-link-hint/>

いくつかの未解決issueがあるが、それを話す人がいない。

#### Byte Range PATCH
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-patch-byterange/>

byterangeと言いつつ、単位がbyte以外のユースケースが出てきている……？あとgzipされている場合に展開されているほうなのか圧縮後のほうなのか、だとか。言及されているhttpbisの "bride" っていうのはこれかな？

<https://datatracker.ietf.org/doc/draft-toomim-httpbis-braid-http/>

Internet-Draftの冒頭がこんなことになってるのは初めて見た(是非見てみてほしい)。(あれ、これってVersioningのやつでは……？)

#### RateLimit header fields for HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers/>

以前のdraftからの更新点の共有とフィードバックくださいという報告かな。unit と scope が追加された。

#### REST API Media Types
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-rest-api-mediatypes/>

"openapi+json" や "openapi+yaml" をどうするかについて議論中。

#### HTTP Problem Types for Digest Fields
* <https://datatracker.ietf.org/doc/draft-kleidl-digest-fields-problem-types/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-httpapi-problem-types-introduction-00>

今回出てきた新しいinternet-draft。[RFC 9530 Digest Fields](https://datatracker.ietf.org/doc/rfc9530/)では`Content-Digest`や`Repr-Digest`などのヘッダを定義して内容および表現の完全性を保証する仕組みがあり、しかし完全性に関連するエラーを通知する方法の標準がないことを解決するためのもの。興味深い。他にもそういった、問題が発生したときにそれを通知する標準がないものはいくつかあるらしい。

### masque
#### Agenda
<https://datatracker.ietf.org/meeting/120/session/masque>

#### QUIC-Aware Proxying Using HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-masque-quic-proxy/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-masque-quic-aware-proxying-00>

そもそもは、[RFC 9208: Proxying UDP in HTTP](https://datatracker.ietf.org/doc/rfc9298/)を用いてQUICに最適化したProxyを可能にするためのドラフト。これどういうことをしたいのかちゃんと理解しておきたいな……

議題は「Preferred address migration」、「Limiting CID registrations」、「Client VCID length」の3つかな。それぞれ、再接続でいいのでは、制限に到達したらフロー制御を行う、同じかそれより長くする必要がある……という結論になったように見える。

#### Proxying Bound UDP in HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-masque-connect-udp-listen/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-masque-connect-udp-bind-00>

やりたいことは、1つのProxyに対するconenctionで複数のtargetsに対する接続を行うこと？例えばRFC 9208だとWebRTCでICEをしたい場合などがサポートされていない。
`connect-udp-bind` というheaderを付けることで使用を宣言する。

相互運用性がどうなのか、というのの確認段階に進んだみたい。

#### Proxying Ethernet in HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-masque-connect-ethernet/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-masque-connect-ethernet-00>

Ethernet framesをproxyするためのdraft。これが可能になると追加のencapsulationによるadditional MTU costが削減できるという利点がある？

VLAN tagging、Ethernet versionのサポート範囲、レイヤー分離と輻輳制御などについてのopen issueがあり、それらについての議論が行われた。実装はまだないのかな？実装したい人は教えてね、というログがあった。

#### DNS Configuration for Proxying IP in HTTP
* <https://datatracker.ietf.org/doc/draft-schinazi-masque-connect-ip-dns/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-masque-connect-ip-dns-config-00>

RFC 9208ではHTTP load balancersを介したVPNを構築できるが、DNSに関する構成情報を交換することができない。ので、[RFC 9297: HTTP Datagrams and the Capsule Protocol](https://datatracker.ietf.org/doc/rfc9297/)を用いてDNS configuration informationの通信を行えるようにするもの。どうやら名前解決そのものの通信は範囲外？

議事録を見る感じでは否定的な意見が多めのよう。

#### What's next for MASQUE
MASQUE自体について。現在どうデプロイされているかどうかなどなど。輻輳制御が入れ子になっている場合とかについての研究が必要など。

なんにせよ、ちょっとまだわかないことが多すぎました。

### webtrans
#### Agenda
<https://datatracker.ietf.org/meeting/120/session/webtrans>

chair slide(というかwg全体で1つの資料)のみ。

#### W3C WebTransport Update
IETF 119からのupdateとして、retransmissions and send orderについてのnote、相対URLのサポート、データグラムを優先するがストリームをブロックしないようにする(実装依存)挙動についてなどがあった。ブラウザのサポート状況は変わらずなのかな？Safari(WebKit)にはいくつかissueが作成されている？

あとはいくつか追加された統計情報についてそれが実用的なのか、不足しているものはないか、実装が可能かなどの議論もあった。

#### WebTransport over HTTP/2
* <https://datatracker.ietf.org/doc/draft-ietf-webtrans-http2/>

Key ExportersについてHTTP/3の場合と同様でいいのかの確認。"This is the first time key exporters would be available to Javascript in a browser." らしく、TLSを解釈する(復号できる)proxyが間に存在する場合に動作しないかも、という指摘があった。

Mozilla (Firefox)は6ヶ月以内にWebTransport over HTTP/2を実装するらしい。canisueによればWebTransportはFirefoxにおいて既に実装済みというステータスだけど、これはover HTTP/3ってことなのでしょう。Bugzillaは [1874097 - WebTransport over HTTP/2](https://bugzilla.mozilla.org/show_bug.cgi?id=1874097) かな。

相互運用性のテストが終わるまでdraftの更新はされないということになった模様。

#### WebTransport over HTTP/3
* <https://datatracker.ietf.org/doc/draft-ietf-webtrans-http3/>

"Data Recvd" について、懸念事項があるのでpull reqにコメントするという発言。"subprotocol"という単語の使用について"protocol" を使用するよう変更することが決まった(W3C updateの議題のときに)。

HTTP authenticationの使用可否については、禁止する理由がないということで使用できるという方向でまとまった。

DRAIN_WEBTRANSPORT_SESSIONについてはめっちゃ議論が長びいてて、さらに数回議論が行われそう。

> David thanks the academy, his family, and all the friends he made along the way. In lieu of flowers he requests PRs and comments.

:bouquet:

### ccwg
#### Agenda
<https://datatracker.ietf.org/meeting/120/session/ccwg>

#### Increase of the Congestion Window when the Sender Is Rate-Limited
* <https://datatracker.ietf.org/doc/draft-welzl-ccwg-ratelimited-increase/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-ccwg-increase-of-the-congestion-window-when-the-sender-is-rate-limited-00>

送信者のデータ送信がrate limitedな場合における輻輳ウィンドウの増加について……？この挙動について、十分な送信が行われていない場合には輻輳ウィンドウの増加に制限をかけるようにする提案。"Who thinks we should not do work on this topic" が0 votesなので、肯定的な反応。

#### BBR Congestion Control
* <https://datatracker.ietf.org/doc/draft-cardwell-ccwg-bbr/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-ccwg-bbrv3-ccwg-internet-draft-update-00>

GoogleとMetaの人によってInternet-Draftが作成されている！BBRv3がRFCになるかも。BBRはGoogle内部のtrafficとGoogleが提供するサービスで使用されている(YouTubeとかgoogle.comとか)。BBRv1とBBRv3でのA/Bテストが行われている。公平性についての発言がいくつかあったけど、ここで課題になっている公平性ってどういうことなんだろうか。

#### BBR Improvements for Real-Time connections
* <https://datatracker.ietf.org/doc/draft-huitema-ccwg-bbr-realtime/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-ccwg-bbr-improvements-for-real-time-connections-00>

これもできたてホヤホヤのdraft。BBRのstartupには2*RTT必要で、かつWi-Fi環境においては容易に停止及び悪化するなどなどなどの問題点がある。Real-Time接続、特にメディアに関することについてはmoq側との連携が必要では、という話も。

#### HPCC++: Enhanced High Precision Congestion Control
* <https://datatracker.ietf.org/doc/draft-miao-ccwg-hpcc/>
* <https://datatracker.ietf.org/doc/draft-miao-ccwg-hpcc-info/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-ccwg-hpcc-enhanced-high-precision-congestion-control-00> (pptx注意)

データセンターにおける通信は超低レイテンシと高い帯域幅がある。そのような環境に向けた新しい輻輳制御アルゴリズムとして提案されているのがHPCC++。そういう環境では正確なテレメトリが得やすいというのがあるのかな。ccwgでやるべきかどうか……という感じ？

#### SEARCH -- a New Slow Start Algorithm for TCP and QUIC
* <https://datatracker.ietf.org/doc/draft-chung-ccwg-search/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-ccwg-search-a-new-slow-start-algorithm-for-tcp-and-quic-01>

これもホヤホヤdraft。"Slow start Exit At Right CHokepoint" でSEARCH。特に無線ネットワークにおいて既存のTCP Cubic with HyStartはスロースタートからの脱出が早すぎる？ためにリンク使用率(とは何？)を低下させる。とはいえHystartがない場合はスロースタートの期間が長すぎ不要なパケロスが生まれる。ack済の配送に基づく輻輳制御をTCP senderが行うようにするSEARCHは既にLinux kernel v5.16 moduleとして実装されて評価済み。

* https://github.com/Project-Faster/tcp_ss_search
* https://github.com/Project-Faster/quicly/pull/2

主な著者の所属であるviasatはアメリカの通信事業者で、衛星通信事業が主っぽい。wgの反応としては前向きな感じ。

#### Prague Congestion Control
* <https://datatracker.ietf.org/doc/draft-briscoe-iccrg-prague-congestion-control/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-ccwg-prague-congestion-control-00>

> It is mainly based on experience with the reference Linux implementation of TCP Prague and the Apple implementation over QUIC, but it includes experience from other implementations where available.

とのことだけど、"TCP Prague"というのはなんだろう？<https://github.com/L4STeam/linux> がそれっぽいのだけど。地名のプラハに由来してるのかな？よくわからなかった。実装としてはTCP版がいくつかのLinux kernel versionsで(前述含む)、UDPのものが <https://github.com/L4STeam/udp_prague> にある。

実装から得られた知見を反映したdraftが欲しいというコメントで終わっている？

#### Rechartering
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-ccwg-recharter-02>

5033bisの取り組みが終わったことについての情報の反映、輻輳制御がいかに重要であるかの文言の追加、などなどなどについて。

minutesを読んでも着地点はよくわからないけど、まあ <https://datatracker.ietf.org/wg/ccwg/about/> の文章の更新がされるのでしょう。

#### CC Response While Application-Limited
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-ccwg-cc-response-while-application-limited-00>

時間切れとのことで触れられなかった。

### moq
#### Agenda
<https://datatracker.ietf.org/meeting/120/session/moq>

IETF 120が終わってからこの記事を書いてるあいだにもうinterimがひとつ、さらに予定としてもうひとつあって議論が活発だ……

あと、minutesに書かれている順にまとめているけど、2回目 → 1回目で書かれている？

####  WARP Streaming Format
* <https://datatracker.ietf.org/doc/draft-law-moq-warpstreamingformat/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-moq-warp-streaming-format-update-will-law-v1-00>

どのようなUpdatesがあったのか。CMAFに加えてLoCのパッケージもサポートされるようになった、タイムライントラックの提案、Chatの内容をどのようなフォーマットで送信するかなど。

着目している人数が少ないことに注意したほうがよいとのコメントがある。

#### Metrics/Logging
* <https://datatracker.ietf.org/doc/draft-jennings-moq-metrics/>
* <https://datatracker.ietf.org/doc/draft-jennings-moq-log/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-moq-metrics-and-logging-over-moq-00>

ホヤホヤ。Media over QUICのログやmetricをどうするかというdraft。QUICの上に乗るということでqlogかと思いきやデータモデルにはOpenTelemetryを使うらしい。好意的な反応。

#### "Peeps" an Extended MoQT Object Model
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-moq-peeps-extending-the-object-model-02>

"An Extended MoQT Object Model" として提案されているもの。PDFの5ページがつまりこれは何なのか、の説明なのかな。議論の様子を見るに好意的に受け入れられてる感じはする。

#### Track Switching in Media Over QUIC Transport
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-moq-track-switching-00>

挙げられている問題を解決するのにとるべき手段がこれなのか、という議論になったように読める。

#### MoQ Transport Issues
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-moq-moq-transport-issues-00>

"github.com/moq-wg/moq-transport" 上のissueについて。ここで議論されてることについては実装を知らないと理解できないことばかりに思えるのでパスで……

#### Livestreaming this meeting over MoQ
この会議の様子をMoQで配信してたらしい。配信するサイトはMetaの人の管理するドメイン上にあった。`short.gy` っていうURL短縮サービスがあるんだね。

#### The MoQ Journey
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-moq-the-moq-journey-00>

これはなんというか、これまでのMoQの軌跡まとめみたいなものかな。現状がどうなってるかわかっていいですね。

#### MoQ Transport-05 updates+priorities
* <https://datatracker.ietf.org/doc/draft-ietf-moq-transport/05/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-moq-overview-of-changes-in-04-and-05-and-the-new-moq-priorities-00>

MoQ Transportのdraftにおける03、04、05での更新まとめと、新しい優先度とグループの送信順番、次に送信するものは何かということについて。主に現状共有っぽい？minutesを見る限りではここではそんなに議論されてない印象。

#### Common Catalog Format
* <https://datatracker.ietf.org/doc/draft-ietf-moq-catalogformat/01/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-moq-catalog-format-update-ietf-120-00>

individual draftからwg draftになったのが6月のこと。新規のIANA registry "MoQ Streaming Format Type" が定義されたり、fieldやroot objectの追加、renameなどなど。
trackのformatについて、MIMEではなく文字列なのは何故か、IANA registryは必要か？などの議論があった。trackのtype属性について、任意でいいのでは？という話も出ていたが、相互運用性のためには取りうる値はどこかに定義があるべきだろう(それはcatalogではなくWARPかも？)という話があった。relative track prioritizationについては必須であるべきだという意見。Streaming formatに入る値はどのようなものであるべきかについては単なる文字列の識別子(バージョンは含まない)が格納されることで合意。

う〜ん、何ひとつピンとこないですね。やっぱり実装しないとわからない領域なのかも。実装する気はないけど……

#### MoQ Secure Objects
* <https://datatracker.ietf.org/doc/draft-jennings-moq-secure-objects/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-moq-secure-objects-00>

MoQ Transportにおけるend-to-end encryption。minutesからは、なぜSFrameにしないのか、いやSFrameは嫌だ(というより同じことのやりなおしになるのが嫌？)、などの意見が見られたけど、結論としてこの提案自体がどうなったのかについてははっきりしない印象。

<https://sora-e2ee.shiguredo.jp/sframe>

SFrameっていうのがあるんですね。

#### The Many Faces of SUBSCRIBE
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-moq-subscribe-implementation-issues-00>

`SUBSCRIBE` を実装して得られた知見についての共有。これはライブストリーミングを実装した人にはピンとくるんだろうか……ギブアップです。

## まとめ
なんもわからん。

これは再掲になるんですが、sylph01さんとIETFなど標準化活動について話した内容をPodcastとして公開しました。ぜひ聞いてください。そして文字起こしを買ってください。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">というわけでPodcast初出演です。ここにない範囲では、SMTPをやめろとは何か（メッセージングの未来とその課題について）、「真のIETF/RubyKaigiは廊下にある」とはどういうことか、あとふるさと納税のおすすめの柑橘について話しました。よろしくねよろしくね <a href="https://t.co/JvI2LwcIoe">https://t.co/JvI2LwcIoe</a></p>&mdash; sylph01 (@s01) <a href="https://twitter.com/s01/status/1815283152404808155?ref_src=twsrc%5Etfw">July 22, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
