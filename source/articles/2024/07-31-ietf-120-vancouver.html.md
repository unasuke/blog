---

title: "IETF 120 Vancouverにリモート参加しました"
date: 2024-07-31 19:25 JST
tags:
- ietf
- quic
- tls
---

![](2024/ietf120-vancouver.png)

## IETF 120 Vancouver
5回目のIETF Meeting参加シリーズ、リモート参加の4回目です。期間中のバンクーバーはUTC-7(PDT)なので、日本からだと1時から13時の範囲となり、リアルタイムの参加はあきらめていました。

## 参加したセッション
「参加したセッション」とはいっても前述のようにリアルタイムでmeetechoに入るのは厳しく、基本的に資料と議事録を見て書いています。httpbis、httpapi、masque、webtrans、ccwg、moqについてもまとめようと思ったんですが、一旦7月中に出すことを考えると余裕がなく、力尽きました。追って書くかもしれません。

### Transport Layer Security (tls)
#### Agenda
<https://datatracker.ietf.org/meeting/120/session/tls>

#### ML-KEM Post-Quantum Key Agreement for TLS 1.3
* <https://datatracker.ietf.org/doc/draft-connolly-tls-mlkem-key-agreement/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-tls-ml-kem-for-tls-13-00>

draft自体は今年3月から更新はされていない。Named Groupに `mlkem768(0x0768)` と `mlkem1024(0x1024)` を足すという提案。MTI(Mandatory To Implement、必須実装)にはしないという。`MLKEM512` も欲しいという声や、文書を分割したほうがいいのでは？という案が出てきているが、前回と比較して提案自体はおおむね前向きな印象？

#### The Transport Layer Security (TLS) Protocol Version 1.3
* <https://datatracker.ietf.org/doc/draft-ietf-tls-rfc8446bis/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-tls-rfc8446bis-00>

エラッタの修正が入っている。X25519をMTIとするかどうかで投票が行われたようで、結果としては今は行わないということに。

#### Hybrid key exchange in TLS 1.3
* <https://datatracker.ietf.org/doc/draft-ietf-tls-hybrid-design/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-tls-hybrid-key-exchange-update-00>

`X25519Kyber768Draft00`はChromeとCloudflareでもう使用できるようになっていて、20%のnegotiationsにおいてこれが使われるようになっている(マジで！？)。

<https://pq.cloudflareresearch.com/> にアクセスすると `X25519Kyber768Draft00` が使われているかどうかわかります。

| Chrome  127.0.6533.73 | Firefox 128.0.3 |
| --- | --- |
| ![Chrome 127の結果](2024/ietf120-pq-chrome-127.png) | ![Firefox 128の結果](2024/ietf120-pq-firefox-128.png) |

* <https://pq.cloudflareresearch.com/>
* [Cloudflare now uses post-quantum cryptography to talk to your origin server blog.cloudflare.com](https://blog.cloudflare.com/post-quantum-to-origins)
* [X25519Kyber768 key encapsulation for TLS - Chrome Platform Status](https://chromestatus.com/feature/5257822742249472)

#### TLS Formal Analysis Triage
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-tls-tls-13-formal-analysis-triage-panel-00>

"Formal Analysis Triage Panel" ではなく "Formal Analysis Triage Team" ということになった？略して "FATT"。学術論文の査読のように匿名で行なわれていることに対する議論が行なわれていたように見える(賛否両論)。というかこの議論を簡潔にまとめられる気がしないので気になる人は議事録を参照してください。かなり長い。

#### A well-known URI for publishing ECHConfigList values
* <https://datatracker.ietf.org/doc/draft-ietf-tls-wkech/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-tls-a-well-known-uri-for-echconfiglist-values-00>


ドラフト自体の説明は [ECH の config を well-known URI で配布するドラフトのメモ - araya's reservoir](https://blog.araya.dev/posts/2023-02-17-well-known-uri-ech-draft-01/) に詳しい。i18nの問題があるらしいけど、それは国際化ドメイン名のことなんだろうか？"more generic?" とされているけど、ECHだけではなくkey_shareなどTLSで必要なパラメータの公開のためにも使うことはできないのか？みたいな議論がされたみたい。dnsop wgと連携する案も。

#### TLS 1.2 is in Feature Freeze
* <https://datatracker.ietf.org/doc/draft-ietf-tls-tls12-frozen/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-tls-chipping-flakes-from-tls-12-is-still-frozen-00>

TLS 1.2にはpost-quantumのサポートは入らないだろう(しかしminutesを読むと逆の意味にも取れるような……TLS 1.2にpq関連のものを追加することを咎めないようなニュアンスの記録がある？)。

#### SSLKEYLOGFILE Extension for Encrypted Client Hello (ECH)
* <https://datatracker.ietf.org/doc/draft-rosomakho-tls-ech-keylogfile/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-tls-sslkeylogfile-extension-for-ech-00>

ドラフト自体の説明は [TLS Encrypted Client Hello用のSSLKEYLOGFILE拡張の提案仕様 - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2024/07/07/232626) に詳しい(いつもありがとうございます)。SSLKEYLOGFILEにおいてEncrypted Client Helloが行われた場合における鍵も記載するようにしたいというのは、それはそう。

もう既にいくつか実装がある(！)。SSHKEYLOGがTLSのセキュリティを崩壊させるという意見、いやいやデバッグ用なのでそういうものではない、など意見の対立はあったものの採用する方向でいくことになっている。

#### Extended Key Update for Transport Layer Security (TLS) 1.3
* <https://datatracker.ietf.org/doc/draft-tschofenig-tls-extended-key-update/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-tls-extended-key-update-for-tls-13-00>

> 長生きなTLS connectionにおいての鍵更新をなんとかしたいという話。TLS 1.2での再ネゴシエーションが脆弱であるということでTLS 1.3では削除されている仕組み。(ラムダノートさんの「プロフェッショナルTLS＆PKI改題第2版」では「8.1 安全でない再ネゴシエーション」として記載があります)
>
> これが、通信インフラやIoT機器などのコネクションが長生きする場面において通信内容をよりセキュアにするために有用であるという提案。仕組みではpost-quantumでも使われるKEMを使う？RFC 9180を参照するとのこと。

以上が前回書いたこと。SSH3のケースを考えると有用だ、という意見。前向きなように見える。

[Towards SSH3: How HTTP/3 improves secure shells | APNIC Blog](https://blog.apnic.net/2024/02/02/towards-ssh3-how-http-3-improves-secure-shells/)

#### TLS Trust Expressions
* <https://datatracker.ietf.org/doc/draft-davidben-tls-trust-expr/>
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-tls-trust-anchor-negotiation-00>

ドラフトの内容については [信頼しているCAをネゴシエーションする TLS Trust Anchor Negotiation のメモ - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2024/07/29/003000) を参照してください。

Trust Anchor IDsとTrust Expressionsのどちらを採用するか、という投票の結果はTrust Anchor IDsが優勢。その場合のShort CA Nameってどう決めるんだろう。IANAに置くのかな。

### QUIC (quic)
#### Agenda
<https://datatracker.ietf.org/meeting/120/session/quic>

#### Multipath QUIC
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-quic-multipath-extension-for-quic-00>
* <https://datatracker.ietf.org/doc/draft-ietf-quic-multipath/>

Chair slideにおいて3GPP(モバイル通信規格の標準化プロジェクト)との連携があることが述べられている。3GPP側からはATSSSの内容においてこのMultipath QUICのdraftを参照しているよ、という連絡があった……と書いてあるけど、その3GPPのドキュメントがどこにあるのか、探しかたが全然わからない……Zennでの解説は発見しました。

* <https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=3992>
    * たぶんこれ？zipを展開すると出てくるdocxにMultipath QUICのことが書いてある
* Zennの解説 [3GPP TS 23.501 5.32 Support for ATSSS](https://zenn.dev/nic/articles/88b18ede979be7)

Multipath QUICそのものについては、Frame名が変更されたり、エラーコードをどうするか、pathがタイムアウトしたときにどうするか、実装間の相互運用性の状況はどうか、などもりだくさん。

#### qlog
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-quic-qlog-00>
* <https://datatracker.ietf.org/doc/draft-ietf-quic-qlog-main-schema/>

時刻表現を相対的なものか絶対時刻のどちらを採用するかという議論が行なわれたようだけど、議事録を見る感じではどっちに決着したかがわからない。

IETF 120が終わったタイミングで <https://github.com/quicwg/qlog/pull/433> が出ている。この提案だとどのような時刻表現を採用しているかをlog先頭で宣言する形式か。……複雑ではないかなあ。

#### Accurate ECN
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-quic-accurate-ecn-acknowledgements-00>
* <https://datatracker.ietf.org/doc/draft-seemann-quic-accurate-ack-ecn/>

`ACCURATE_ACK_ECN` frameの導入によって輻輳制御アルゴリズムに対しより詳細な情報を提供できるようにしようというもの。累積のECNカウントではなく、個別にどのpacketがCongestion Experiencedとなったかを知れるようにしたい。そもそもコンセプトに反対だったり、ack frequencyのほうがよいのではないかという意見があった。QUICの拡張としてやってみようという結論になったように読める。

#### HTTP/3 Prioritization in the wild
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-quic-http3-priorities-in-the-wild-anrw-taster-00>

特定のdraftというよりは現実世界における調査のまとめのよう。 Extensible Prioritization Schemeというのはこれかな。

* [RFC 9218 - Extensible Prioritization Scheme for HTTP](https://datatracker.ietf.org/doc/rfc9218/)
* [RFC9218: Extensible Prioritization Scheme for HTTP をまとめてみた。 - momokaのブログ](https://momoka0122y.hatenablog.com/entry/2022/06/09/235923)

各ブラウザおよびサーバー実装のサポート状況、fetchpriorityの効果についてまとめられている。うまくいってない感じ……？

#### QUIC tokens
* <https://datatracker.ietf.org/meeting/120/materials/slides-120-quic-quic-token-confusion-00>

RFC 9000における

> When a server receives an Initial packet with an address validation token, it MUST attempt to validate the token, unless it has already completed address validation. If the token is invalid, then the server SHOULD proceed as if the client did not have a validated address, including potentially sending a Retry packet. Tokens provided with NEW_TOKEN frames and Retry packets can be distinguished by servers (see Section 8.1.1), and the latter can be validated more strictly.
> https://datatracker.ietf.org/doc/html/rfc9000#section-8.1.3-10

という記述にあいまいさがあり、`NEW_TOKEN` か `Retry` で送信されるtokenは区別できるべきで、serverが不正なRetryトークン以外は正常なclient initialを受信した場合は直ちに `INVALID_TOKEN`エラーで接続を閉じなければいけない。このとき、`NEW_TOKEN` と Retry トークンの区別が曖昧な場合は誤った処理が引き起こされる……？

"Extensible tokens" がこの問題を解決できるかもしれない、という意見があるけど、"Extensible tokens"とは……？

## まとめ
むずかしいですね。こんなにあやふやなまとめになってしまって誰に需要があるのか……1人でこんなに追うものではないのかもしれません。

あと、sylph01さんとIETFなど標準化活動について話した内容をPodcastとして公開しました。ぜひ聞いてください。そして文字起こしを買ってください。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">というわけでPodcast初出演です。ここにない範囲では、SMTPをやめろとは何か（メッセージングの未来とその課題について）、「真のIETF/RubyKaigiは廊下にある」とはどういうことか、あとふるさと納税のおすすめの柑橘について話しました。よろしくねよろしくね <a href="https://t.co/JvI2LwcIoe">https://t.co/JvI2LwcIoe</a></p>&mdash; sylph01 (@s01) <a href="https://twitter.com/s01/status/1815283152404808155?ref_src=twsrc%5Etfw">July 22, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
