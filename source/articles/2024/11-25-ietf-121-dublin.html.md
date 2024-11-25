---
title: "IETF 121 Dublinにリモート参加しました"
date: 2024-11-25 17:00 JST
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

![](2024/ietf121-dublin.png)

## IETF 121 Dublin
はい。今回はTZ的にはいわゆる仕事が終わった後に開始、というセッションが多く日本からのリモート参加も比較的しやすい回ではありましたが、Kaigi on Rails 2024のアフターイベントとか何やらとかでリアルタイム参加はひとつもできませんでした……

それでは例によって以下は個人的な感想を無責任に書き散らかしたものです。

## httpbis
### Agenda
* <https://datatracker.ietf.org/meeting/121/session/httpbis>

minutesがいつものHedgeDocじゃなくて <https://httpwg.org/wg-materials/ietf121/minutes.html> になっているのはなにゆえ……？

### Resumable Uploads
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-resumable-upload/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-httpbis-resumable-uploads-00>

05での更新はUpload-Lengthヘッダの追加など。次やることは文書の整理、実装の最新draftへの追従、相互運用性のテスト、本番環境での運用経験を得ること。クライアント側実装はSwiftとObjective-C(というかiOS用のライブラリ)、JavaScript。サーバー側実装はSwift、Go、.NETの3つ。

ハッカソンにおいて相互運用性のテストが行われ、全ての実装が最新のdraftに追従、試験もたくさん成功したとのこと。

<https://wiki.ietf.org/en/meeting/121/hackathon#resumable-uploads-for-http-rufh>

アップロードの進捗を取得するために1xx status codeを使うことについての議論があった。もしかしたら現在未使用の104が割り当てられるかもしれない？

### QUERY Method
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-safe-method-w-body/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-httpbis-the-query-method-00>

120からの主要なupdateとして、Content-Location ヘッダと Location ヘッダの用途についてとそれに設定するURIのガイダンス、Accept-QueryヘッダのIANAへの登録が挙げられている。議事録にはAccept-Queryの値に対してStructued Field Valuesは使わないでくれ、くらいしか記載がない。

### Cache Groups
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-cache-groups/>

スライドがない。とはいえIn WG Last Callだし、もう特に議論すべきこともない段階？

### Incremental HTTP Messages
* <https://datatracker.ietf.org/doc/draft-kazuho-httpbis-incremental-http/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-httpbis-incremental-http-messages-00>

last updatedが10/15で新しい、奥さん(連名)のdraft。

> This document specifies the "Incremental" HTTP header field, which instructs HTTP intermediaries to forward the HTTP message incrementally.

abstractを読むとやはりCDNベンダっぽい課題感だなと感じる(とはいえ連名はFastly, Apple, Mozillaだけど)。HeaderにIncremental を指定することで、通信の中継者が全てのメッセージをクライアントから受信する前に背後(クライアント)に渡し始められる。これによって最終的にクライアントがタイムアウトとなる前にサーバーからのレスポンスを返せるようになる(例としてserver side events)……ってことかなあ。

スライドのmemeっぷりたるや。incremental enthusiastが多めで前向きな感じがする。

### The HTTP Wrap Up Capsule
* <https://datatracker.ietf.org/doc/draft-schinazi-httpbis-wrap-up/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-httpbis-the-wrap-up-capsule-00>

"GOAWAY is a sledgehammer"

00 → 01でIntroductionが大幅に加筆された。`WRAP_UP`によって、(MASQUEの例として)あるclientがCONNECT-UDPとCONNECT-TCP(あるいは別のproxy connection)の2つの接続を互いに別々のoriginに、単一のproxyを介して接続しているとき、CONNECT-UDPのほうでGOAWAYが起こると全部のconnectionが突然に終了されてしまう問題を解決できる。proxyの側が`WRAP_UP`をclientに送信することでclientがgracefullyにconnectionをdrainできる。client側から`WRAP_UP`を送信することを可能にするか？という議題がある。前進しそう。

### Guidance for HTTP Capsule Protocol Extensibility
* <https://datatracker.ietf.org/doc/draft-pardue-capsule-ext-guidance/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-httpbis-capsule-protocol-extensibility-00>

Capsuleプロトコルについては以下。

* [HTTP DatagramsとCapsuleプロトコルについて (RFC 9297) - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2022/03/31/003753)
* <https://datatracker.ietf.org/doc/rfc9297/>

RFC 9297をupdateするもの。RFC 9297のwgはmasqueだけど、このdraftはhttpbisの議題になっている。capsuleの拡張性について。

> Endpoints that receive a Capsule with an unknown Capsule Type MUST silently drop that Capsule and skip over it to parse the next Capsule.

という文書における "endpoint" が一体何であるかが曖昧、というのを出発点にしている。proxyは含まれるのか、とか。

結論としてはもうすこし議論しようということっぽい。


### Cookie eviction
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-httpbis-delete-cookie-00>

`Delete-Cookie` ヘッダーで明示的にCookieを削除できるようにする？

<https://datatracker.ietf.org/doc/draft-ietf-httpbis-rfc6265bis/> がちゃんとRFCになってから取り掛かるのでいいのでは？という意見があった。

### AD-Requested Feedback (draft-ietf-netconf-http-client-server)
* <https://datatracker.ietf.org/doc/draft-ietf-netconf-http-client-server/>

> YANG（ヤン、英: Yet Another Next Generation）は、データモデル言語の一種である。NETCONF や RESTCONF などのネットワーク管理用プロトコルによりアクセスされるネットワーク機器の設定や状態、遠隔手続き呼出し (RPC)、通知をモデル化するために開発された。
> <https://ja.wikipedia.org/wiki/YANG>

netconf wgのdraftについてhttpbis wgからのフィードバックはあるか、というやつかな。肯定的ではあるものの、もっと議論が必要という感じ。

### Template-Driven CONNECT for TCP
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-connect-tcp/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-httpbis-sessb-template-driven-http-connect-proxying-for-tcp-00>

MASQUE for TCPってスライドには書いてるし、そういうものを実現するためのもの？

[HTTPの拡張CONNECTメソッド について復習する - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2022/01/19/013106) で `connect-upd` を使うという解説があるけど、こっちは TCPの上に載せるので`connect-tcp` を新しく定義して使うとある。

Capsuleを使うべきでは？という意見がいくつか。賛否両論で、さらに議論しようという結論。

### Security Considerations for Optimistic Protocol Transitions in HTTP/1.1
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-optimistic-upgrade/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-httpbis-sessb-security-considerations-for-optimistic-protocol-transitions-in-http11-00>

もともと "Security Considerations for Optimistic Use of HTTP Upgrade" という名前だったのが後半が "Protocol Transitions in HTTP/1.1" に変更されている。

101(Switching Protocols) が返ってきた場合やCONNECT methodを使用する場合に使用されるプロトコルが変わることがあり、その場合におけるセキュリティ上の問題を解決するためのもの。Proxying UDP in HTTP" (RFC 9298)を更新するとも。
<https://datatracker.ietf.org/doc/rfc9298/>

スライドには120以降の変更についてと、HTTP CONNECTについて新規に追加された記載についてしか書いてないな？実際最終段階らしく、last callに向けてもっとreviewしようという感じで終わっている。


### No-Vary-Search
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-no-vary-search/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-httpbis-sessb-no-vary-search-00>

> No-Vary-Search というヘッダーで、URLのparamsに入っているものがレスポンスに影響するかどうかを知らせることができるようになる。なのでparamsのバリエーションによるキャッシュのうんぬんを制御できるってことだろうか。既にChromeにはサポートが入っているっぽい？call for adoptionされそう。

上記は前回の自分のblogより。

スライドで「CG Draft」にsuspendedとなっているのは、WICGでの策定？はやめて、httpbis wgでの作業に一本化したということ？なのか？

[Editorial: Move No-Vary-Search to IETF HTTPbis by jeremyroman · Pull Request #338 · WICG/nav-speculation](https://github.com/WICG/nav-speculation/pull/338)

### IP Geolocation & HTTP
* <https://datatracker.ietf.org/doc/draft-pauly-httpbis-geoip-hint/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-httpbis-ip-geolocation-http-01>

いわゆるGeoIPの話。間に中間者を挟むなどで自分のIP addrは知られたくないが、地理情報は伝えたい(？)ケースがある。そのときに `Sec-CH-IP-Geo` で地理情報をサーバーに送信できるようにする提案。目的としてはIP addrによる地理情報の推測をやめていきたい、というものだとか。問題意識はわかるような……とりあえず継続して議論しようというステータス。

## moq
この章を書いている途中で [第2回 Media over QUIC とか勉強会 - moq-wasm 開発秘話!!【Media over QUIC とか勉強会】 | 高田馬場 Live Cafe mono](https://teket.jp/10716/42505) に参加し、[nttcom/moq-wasm](https://github.com/nttcom/moq-wasm)を実装している方々とお話しすることができました。なので色々なワケワカラナイだった部分がだいぶわかるようになりました。やっぱ実装してるとより理解が進むし、実装しなければわからないこともあるということで。

* [MoQとか勉強会#2 発表資料 - Speaker Deck](https://speakerdeck.com/yuki_uchida/moqtokamian-qiang-hui-number-2-fa-biao-zi-liao)
    * とりあえずこれを読んでください。というかmoqに関しては僕のblogはすっ飛ばしていいかも
* [Media over QUIC Transport実装をOSSで公開しました｜SkyWay by ドコモビジネス](https://note.com/skyway/n/n5c1b3bdf43dc?sub_rt=share_pb)

### Agenda
* <https://datatracker.ietf.org/doc/agenda-121-moq/>

IETF 120からinterim meetingsが12も実施されている。やば。そしてこの記事を書いてる間にもどんどんinterimが予定されていって、今ではこうなっている。

![めちゃくちゃ予定されているinterimの様子](2024/ietf121-moq-interim.png)

<https://quic.video/blog/transfork/> が気になってるけど、議題にはないのかな？まあないか……

### Interop
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-moq-sessa-interop-results-00>

一番実装が進んでいるものでも 6 (unsubscribe) までで、7 (goaway) を実装できているものはない。そもそもinteropの内容が120から変わっていなかった、という話も(前述のスライドで)ありましたね。

### MoQT Updates Since Vancouver
* <https://datatracker.ietf.org/doc/draft-ietf-moq-transport/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-moq-moq-transport-updates-since-vancouver-00>

IETF 120以降でMoQ Transportに入った変更まとめ。超interimがあったので、こういうのがあるのが本当に助かる……そしてまあ、いっぱいありますね。

### JOIN
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-moq-join-api-proposal-00>

~~複数のgroupにobjectが配置されている場合においてRTTを削減できるってことか？beneftとしてスライド内で説明されているのが以下。例えば解像度の切り替えなんかで嬉しいというように読める。議事録によると、スライドにあるproposal #2が賛成多数ということでその方向で進むらしい。~~

スライド読んで！


### Updating MoQT Priorities based on Implementation Experience
* <https://github.com/moq-wg/moq-transport/issues/585>
* <https://github.com/moq-wg/moq-transport/pull/518>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-moq-updating-moqt-priorities-based-on-implementation-experience-00>

~~priorityについての記述のあいまいさがあるみたいで、そのための議論のよう。複数のgroup間でのpriorityの順序がどうなるか、ということっぽい。これもproposalが2つ挙げられており、決を取ったところproposal 2が賛成多数となった。proposal 2はsubgroup内でuniqueなpriority値をつける方式。見た感じgroupにもまたがっていそうだけど……？~~

スライド読んで！！

### Process / Workflow
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-moq-moqt-process-improvements-00>

moq wgのプロセス及びワークフローについて。chairがコンセンサスを確認できていない、virtual interimで物事が進んでいて参加できない人がおいていかれる、運営が難しいという問題が挙げられている。いくつかの解決策が挙げられていて、議事録を見た感じではそれで合意した……？


### WARP + Catalog Merge
* <https://datatracker.ietf.org/doc/draft-law-moq-warpstreamingformat/>
* <https://datatracker.ietf.org/doc/draft-ietf-moq-catalogformat/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-moq-warp-catalog-and-media-interop-00>

なんか色々ある……まず、10月のinterimにおいて、CatalogについてはWARPにmergeし、個別のdraftにはしない。interopはメディアストリーミングフォーマットに焦点をあてる。この2つがCatalog design teamのsummaryとして合意を得られている。

interopに関するInformationalなdraft (MOQ-MI)も作成されている。

<https://datatracker.ietf.org/doc/draft-cenzano-moq-media-interop/>

~~WARPとMOQ-MIでサポートしている機能が異なることについての議論がされたっぽいけど、議事録は簡潔すぎてちょっとわからない。Core featureとして最低限どこまでサポートするべきか、みたいなところが今後のワークで明確になる？~~

スライド読んで！！！

### SWITCH
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-moq-switch-proposal-00>

~~解像度を変えるなどしたい場合に、新しいgroupを受信しても今ある解像度から新しい解像度とのgroupの間のobject(？)をもらわないといけないとき、SUBSCRIBE+UNSUBSCRIBEか、それにFETCHもまざってくるかというケースの複雑さを解決するために導入する仕組みがSWITCH。具体的にどうするかについてはこれからっぽい。~~

スライド読んで！！！！

### Timestamps
* <https://github.com/moq-wg/moq-transport/issues/475>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-moq-timestamps-in-moq-transport-00>

Delivery TimeoutとMax Cache Durationが相対的でありベストエフォートである。もしパケロスや順序の入れ替わりがある場合にskewedとなる。エンコードに時間がかかるケースにおいてはcaches upできない？？optionalな"timestamp"を導入することで解決するということらしいが。わかりません！

### STOMP
* <https://datatracker.ietf.org/doc/draft-shamim-moq-time/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-moq-stomp-00>

latencyの計測のためにmoqt上で時刻のmetadataを交換できるようにするっぽい。地理情報も含められるようになっている。しかし事情によりskipとなった。

## ccwg
### Agenda
* <https://datatracker.ietf.org/meeting/121/session/ccwg>

recharterするっぽい？その兼ね合いでテストスイートがあると嬉しい、古くならないよう長期的にメンテされているべきだ、みたいな話がされていた。これ、Hackathonと関係していそうだけど。ns-3っていうやつが便利なツールっぽい。

<https://www.nsnam.org>

なんか日本の大学の名前が見える……

### Hackathon Update
* <https://wiki.ietf.org/en/meeting/121/hackathon#congestion-control-testing>

なんかあったらしい。"Design a suite of test cases based on 5033bis, the proposed new BCP on Specifying New Congestion Control Algorithms" は超ステキだと思うが。成果は……どこにまとまってるんだろう？？？

### BBRv3
* <https://datatracker.ietf.org/doc/draft-ietf-ccwg-bbr/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-ccwg-bbr-congestion-control-00>

変更点としては、wg draftになっているとか、元文書がXMLからMarkdownになっているとか、明確化したとかとか。軽微なアルゴリズムの変更をするpull reqが2つopenになっていて、TCPでないtransport(主にQUICのことを指してる)に対する一般化についてのissueがopenになっている。

### SEARCH
* <https://datatracker.ietf.org/doc/draft-chung-ccwg-search/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-ccwg-search-a-new-slow-start-algorithm-for-tcp-and-quic-00>
* <https://search-ss.wpi.edu/>

現実世界でのdeployに協力してくれるボランティアを募集している段階？ccwgのワークとして取り組むことに賛成の意見が多いので、引き続きなにかしら行われそう。

### Increase of the Congestion Window when the Sender is Rate-Limited
* <https://datatracker.ietf.org/doc/draft-welzl-ccwg-ratelimited-increase/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-ccwg-increase-of-the-congestion-window-when-the-sender-is-rate-limited-00>

> 送信者のデータ送信がrate limitedな場合における輻輳ウィンドウの増加について……？この挙動について、十分な送信が行われていない場合には輻輳ウィンドウの増加に制限をかけるようにする提案。"Who thinks we should not do work on this topic" が0 votesなので、肯定的な反応。

が、前回。これも投票の結果、ccwgのワークとして取り組むことに前向き。

### SCReAMv2
* <https://datatracker.ietf.org/doc/draft-johansson-ccwg-rfc8298bis-screamv2/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-ccwg-screamv2-00>

スライドの最後がオシャレ。ccwgのワークとして取り組むことの賛成は反対より多かったけど、no opinionを含めてあまり差がない感じ。どうなるんだろう？

他のものについては時間切れ。

## wish
### Agenda
* <https://datatracker.ietf.org/meeting/121/session/wish>

こんなwgありましたっけ……？って思ったけどpast meetingsは110からあって完全に節穴でしたね。

WebRTC Ingest Signaling over HTTPSなのでWHIP/WHEPのwg。

[WebRTC のシグナリング規格 WHIP と WHEP について](https://zenn.dev/shiguredo/articles/webrtc-whip-whep) が概要をつかむのにはわかりやすいかも。

### WebRTC-HTTP Egress Protocol (WHEP)
* <https://datatracker.ietf.org/doc/draft-ietf-wish-whep/>

agendaはこれだけ。そしてin WG Last Call状態。行われた議論自体はGitHubで未解決のissueについてとWHEPについて。WHEPはURLをどうするかについてどうしようか状態なのと、失敗(何に？)した場合の振る舞いについて定義しないといけない、ということについての議論があった。minutesを読むと議論があったことはわかるけど結論は書かれていなくて、合意に至らなかったのかな。

## quic
### Agenda
* <https://datatracker.ietf.org/meeting/121/session/quic>

### Multipath QUIC
* <https://datatracker.ietf.org/doc/draft-ietf-quic-multipath/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-quic-multipath-quic-00>

10から11の変更点は4-tuple addressがhas already been validatedな場合にendpointがchallenge(とは何だ)なしでpacketをsendできるようになった、`PATH_ABANDON` frameのerror codeについての再定義とreason phaseの削除、最大path identifierに達したことを通知する`PATHS_BLOCKED` frameの追加、transport parameterの変更といったところ。hackathonでのinterop testの結果報告も。

話し合われたissueは4つ。issue 459はendpointがCIDを有効な各Path IDに対して発行しなかった場合どうなるかについて。現在のdraftにおいてはpeerが新規pathを開いたらCIDを発行するのがRECOMMENDED。 ただし`MAX_PATH_ID`がnegotiateされるまでは`PATH_NEW_CID`を送ることができないので、遅延させたい。合意に至らず。

issue 414はPath Abandonのerror codeについて。`UNSTABLE_INTERFACE`や`NO_CID_AVAILABLE`のようなものが必要か？という話。新規にpull reqを作成して議論するみたい。

issue 457はPTO handlingについて。ある1つのpathにendopointがpacketを送り、突然そのpathがブラックホールになった場合(つまりpacketが虚空に消えた場合か？)の挙動かな。RFC 9002に従えば、endpointはackがそのpathから戻されない場合、PTOが発生するまでそのpacketが失われたと見做されない。議論の結果、何らかの指針を追加することが決まったみたい。

issue 458はmultipathがnegotiatedな場合においてPath migrationかnew pathのどちらをすべきかについて。endpointは通信内容を送信するために新規4-tuple addressを使いたい。新規pathを作成するのがREDOMMENDEDとなっている。ここの内容、どういうことなんだ……

WG last callになるかどうかについては、もう一回改訂を重ねるということになった。そもそもやろうとしてることが多くて大変とも。


### qlog
* <https://datatracker.ietf.org/doc/draft-ietf-quic-qlog-main-schema/>
* <https://datatracker.ietf.org/doc/draft-ietf-quic-qlog-quic-events/>
* <https://datatracker.ietf.org/doc/draft-ietf-quic-qlog-h3-events/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-quic-qlog-01>

なんだこのbikeshedは(スライドp6)。qlog-main-schemaについては09で識別子の名前が変更されたりなんだり。

JSON-SEQがpainfulであるというbikeshedについて。JSON-SEQが何かというと[RFC 7464](https://datatracker.ietf.org/doc/html/rfc7464)のことらしい。今はJSON-SEQを使うこともできる、という状態(`application/qlog+json-seq` で返す)。他にもNDJSONやJSON linesという選択肢もある。JSON-SEQを使う場合、grep、vimとの相性が悪く、またjqで使うには `--seq` optionを渡す必要がある。それらを踏まえてJSON-SEQのままでいくか、他の何かを採用するか、それとも他のserialization formatを追加するか、何のstreaming serialization formatも推奨しないかのどれにするかという議論。結論は出なくて、年内のWGLCに向けて解決しないといけない、というところで終了。

### Address Discovery
* <https://datatracker.ietf.org/doc/draft-seemann-quic-address-discovery/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-quic-quic-address-discovery-00>

P2Pな状況におけるQUICにおいてpublic addressを検出、シグナリングするための拡張。そもそもquic wgとして取り組むべきかどうかについての投票が行われ、賛成多数。

### Flexicast QUIC
* <https://datatracker.ietf.org/doc/draft-navarre-quic-flexicast/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-quic-flexicast-quic-00>

> The deployment of QUIC opens an interesting opportunity to reconsider the utilization of IP Multicast. As QUIC runs above UDP, it could easily use IP multicast to deliver information along multicast trees. Multicast extensions to QUIC have already been proposed in [I-D.pardue-quic-http-mcast] and [I-D.jholland-quic-multicast-05]. To our knowledge, these extensions have not been fully implemented and deployed.Flexicast QUIC takes a different approach. Instead of extending QUIC [QUIC-TRANSPORT], Flexicast QUIC extends Multipath QUIC [MULTIPATH-QUIC]. Multipath QUIC already includes several features that are very useful to allow a QUIC connection to use unicast and multicast simultaneously.

おお……？unicastについてはbidirectionalなpathを使い、multicastについてはshared unidirectional flowを使う？(p4の図)

フィードバック求む！状態。

## httpapi
### Agenda
* <https://datatracker.ietf.org/meeting/121/session/httpapi>

### HTTP Privacy
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-privacy/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-httpapi-api-keys-and-privacy-00>

httpなpathにrequestをした場合、httpsへと301 redirectするというのはありふれている。このとき最初のnon-secureなrequestにapi keyなどのcredentialが含まれているとunsecureだよね、という話。このdraftはBest Current Practiceなやつ。serverおよびclientに最初からsecureな通信での開始を行うための指針を提供するもの。HSTSとかHTTPS DNS recordとか。

### HTTP Signature
* <https://datatracker.ietf.org/doc/html/rfc9421>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-httpapi-http-message-signatures-rfc9421-00>

なぜスライドにこんなに映画ネタを……？ <https://httpsig.org/> を今さら見て気付いたけど、Ruby gemとして <https://github.com/nomadium/linzer> というのができているのか。これはRFC準拠っぽい。

### Digest FIelds Problem Types
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-digest-fields-problem-types/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-httpapi-http-problem-types-for-digest-fields-00>

[RFC 9530](https://datatracker.ietf.org/doc/rfc9530/)のDigest Fieldでdigestが不正だった場合に、[RFC 9457](https://datatracker.ietf.org/doc/rfc9457/)の仕組みを用いて結果を返すためのschemaを定義するものかな？

oracle attackに注意というコメントがあった。

### REST API Media Types
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-rest-api-mediatypes/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-httpapi-rest-api-media-types-00>

OpenAPIやJSON Schemaをresponseとして返せるようにするもの。レビューしてlast callの準備ができたか確認するということになった。

### RateLimit header
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-httpapi-rate-limiting-draft-update-00>

そういえばRate limitの仕組みがRailsに入ったよな……

patition keyが入った？のかな、これは便利という意見があった。

## masque
### Agenda
* <https://datatracker.ietf.org/meeting/121/session/masque>

いつ見てもなんかSEGAを彷彿とさせる。

### QUIC-Aware Proxying
* <https://datatracker.ietf.org/doc/draft-ietf-masque-quic-proxy/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-masque-quic-aware-proxying-00>

04での更新点は、Proxyはoriginal CIDsに限定した(as long asをこう理解していいのか？)virtual CIDsをpickしないといけない、`MAX_CONNECTION_IDS`をproxyに登録されるconnection idsの上限を限定するために追加した、など。スライドにある議題として、issue 113のPreferred address migrationについては追加の議論はなかった。issue 115のActive attack on scramble transformが主な議論。active attackerはiv生成のために使われるバイト列を複数のpacket間で共通になるように変更できる。packetそのものは無効または破棄されるけど、scrambled packetには一致するバイト列が含まれており、プロキシの両側のフローを対応することができる、と……結論としてはこのような攻撃手法がある、という対応のみに留まりそう。

### Proxying Linstener UDP in HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-masque-connect-udp-listen/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-masque-connect-udp-bind-slides-121-masque-connect-udp-bind-00>

前回(っていうのは120のこと？)からの変更は特になく、WGLCになるまでに相互運用性があると嬉しいので、実装に意欲的な人を募集中、という段階。hackathonで1つ実装した、という話があった。Googleによるもの。それってこれのことなのかな？ <https://github.com/google/quiche/commit/29f785f59dfb33f4fff4c87852983c2cb7808ad0>


### Proxying Ethenet in HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-masque-connect-ethernet/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-masque-connect-ethernet-00>

hachathonでericsson clientとgoogle serverとのinteropが行われたとのこと。もっと他の実装も募集中。輻輳制御に関して未解決の問題が残っている。これについてどうすべきかはまだまだ議論が必要という感じになっている。

### DNS Configuration for Proxying IP in HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-masque-connect-ip-dns/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-masque-connect-ip-dns-config-00>

dnsop wgに持っていって早期レビューを受ける流れ？

## tls
### Agenda
* <https://datatracker.ietf.org/meeting/121/session/tls>

会場めっちゃ広くない？？？？？

あとIETF 121が終わってから[ML-DSA](https://github.com/bwesterb/tls-mldsa)が[めっちゃもりあがってる](https://mailarchive.ietf.org/arch/msg/tls/nxYSuH6gC9c59QQ_xdfODHSd9ts/)んだが……

### Trust Tussle Interim Summary
* <https://datatracker.ietf.org/doc/draft-beck-tls-trust-anchor-ids/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-tls-trust-tussle-interim-summary-00>
* <https://datatracker.ietf.org/meeting/interim-2024-tls-01/materials/slides-interim-2024-tls-01-sessa-trust-tussle-00>
    * これはinterimのslide

> Avoid client trust conflicts by enabling servers to reliably and efficiently support clients with diverse trust anchor lists, particularly in larger PKIs where the existing certificate_authorities extension is not viable.

たぶんinterimの議事録をもっとちゃんと読めばどういうものかわかりそうなのであとで読むかも……

<https://datatracker.ietf.org/meeting/interim-2024-tls-01/session/tls>

ステータスとしては、もうひとつdraftが来るという。

### TLS Registries Update
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-tls-tls-registries-update-00>

TLS Registyに入った変更について。"A stunning presentation."

### ECH Discussion
* <https://github.com/tlswg/draft-ietf-tls-esni/issues>

issueについて議論する回。AD reviewでついたDNSの問題については、合意に至らずADからの勧告があれば従うと。他にもいくつかあるopen issueについての議論が行われた。今repoを見てる感じでは、それらに対応した変更がcommitされていそう。

### FATT Updates
* <https://github.com/tlswg/tls-fatt>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-tls-tls-fatt-00>
* <https://richsalz.github.io/draft-rsalz-tls-analysis/draft-rsalz-tls-analysis.html>

FATTの現状について。議論は公開されるべきだ、という意見が多い。(動画だと結構長い時間話してたけどmisnutesがアッサリめ)

### DTLS Clarifications
* <https://datatracker.ietf.org/doc/html/rfc9147>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-tls-13-dtls-13-details-00>

[RFC 9147 The Datagram Transport Layer Security (DTLS) Protocol Version 1.3](https://datatracker.ietf.org/doc/html/rfc9147)の改訂が必要だ、という1枚目から始まる。TLS 1.3とDTLS 1.3でKeyUpdatesの適用タイミングが異なるとか(マジで？)、1.3でしか対応していないACKがversionをまたいで使われる場合の挙動とか、Epoch managementが明記されていないとか、とか、とか……結構ございますわね。

repositoryを作るよ、という話になったぽい。

### Abridged Certs Update
* <https://datatracker.ietf.org/doc/draft-ietf-tls-cert-abridge/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-tls-abridged-certificates-update-draft-ietf-tls-cert-abridge-01>

certificateの圧縮。pass 2は複雑(これ2パス圧縮のことでいいのかな？)なので辞書なしのBrotilを使おうという提案がある、と。よりシンプルになるが圧縮率は落ちる。それはそれとしてZstdとBrotilのどっちでいくかはまだ議論中かな？

### Extended Key Update
* <https://datatracker.ietf.org/doc/draft-ietf-tls-extended-key-update/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-tls-extended-key-update-00>

ExtendedKeyUpdateRequestを受信したときにalert & terminateしていたのがExtendedKeyUpdateResponseを返すように定義されたり、ExtendedなKey Updateが実行されたときにSSLKEYLOGFILEにどう記録するか、などの更新。未解決issueはもうない！

### SSLKeylog ECH
* <https://datatracker.ietf.org/doc/draft-ietf-tls-ech-keylogfile/>
* <https://datatracker.ietf.org/meeting/121/materials/slides-121-tls-sslkeylogfile-extension-for-ech-00>

最新のWiresharkではもうサポートされている！！

## まとめ
アー
