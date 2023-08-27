---
title: "IETF 117 San Franciscoにリモート参加しました"
date: 2023-08-27 22:40 JST
tags:
- ietf
- quic
- tls
- mls
---

![](2023/ietf-117-quic-bluesheet.png)


## IETF 117 San Francisco
<https://datatracker.ietf.org/meeting/117/proceedings>

7/22から7/28まで開催されていたIETF 117 San Franciscoに日本からリモートで参加しました。前回のIETF 116 Yokohamaの開催後、ISOC日本支部によって開催された[IETF116報告会](https://www.isoc.jp/activities/ietf_updates/116/)において、参加した感想を発表させていただきました。

<iframe src="https://slide.rabbit-shocker.org/authors/unasuke/isocjp-ietf-116-report/viewer.html"
        width="640" height="404"
        frameborder="0"
        marginwidth="0"
        marginheight="0"
        scrolling="no"
        style="border: 1px solid #ccc; border-width: 1px 1px 0; box-sizing: content-box; margin-bottom: 5px"
        allowfullscreen> </iframe>
<div style="margin-bottom: 5px">
  <a href="https://slide.rabbit-shocker.org/authors/unasuke/isocjp-ietf-116-report/" title="isocjp-ietf-116-report">isocjp-ietf-116-report</a>
</div>

その発表内で「参加記を書こう！」と宣言したのもあり、こうして117の参加記を書いています。なるべく今後も参加記は書いていこうと考えています。

## 参加したセッション
以下で言及するWGについては、基本的にはsessionの部屋に入って議論を聞いてはいましたが、ここでまとめ直すにあたっては基本的には議事録を参考にして書いています。英語のリスニングスキルがポンコツなので……

### QUIC
<https://datatracker.ietf.org/meeting/117/session/quic/>

quic wgにおいては、前回の116 Yokohama以降の大きな出来事といえば [RFC 9369 QUIC Version 2](https://datatracker.ietf.org/doc/rfc9369/) が出たことでしょうか。

* [draft-ietf-quic-multipath-05](https://datatracker.ietf.org/doc/draft-ietf-quic-multipath/)
    * 複数の経路を用いた通信を行うためのdraft
    * see also [マルチパスQUICのdraft-ma-quic-mpqoe とその論文 XLINK: QoE-Driven Multi-Path QUIC Transport in Large-scale Video Services を読んだ。 - momokaのブログ](https://momoka0122y.hatenablog.com/entry/2022/06/24/161303)
        * momokaさんが詳細に書いてくださっていてありがたい……
        * [IETF117 参加記録　土日　Hackathon - momokaのブログ](https://momoka0122y.hatenablog.com/entry/2023/07/24/230829)
            * draftを書いている方と直接話した内容についても書かれていました
    * 発表資料内で複数実装間での相互運用性がどうなっているかの言及がありました。既に5つの実装でmultipath QUICをサポートしている？とのこと。
* [draft-ietf-quic-reliable-stream-reset-01](https://datatracker.ietf.org/doc/draft-ietf-quic-reliable-stream-reset/)
    * see also [再送はしてもらう Reliable QUIC Stream Resets の仕様 - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2023/05/06/020718)
* [draft-ietf-quic-qlog-main-schema-06](https://datatracker.ietf.org/doc/draft-ietf-quic-qlog-main-schema/)
    * versionが0.3から0.4になりました
        * いくつかのcategoryの名前が変わって短くなった
    * UDP層のイベントをどう記録するか、追加のschemaを使用する方法についての議論など……
* [draft-ietf-quic-ack-frequency-05](https://datatracker.ietf.org/doc/draft-ietf-quic-ack-frequency/)
    * ackの頻度をどうするか。頻度を減らすことで計算リソースの削減、低速回線での高効率などを目指す
* [draft-ietf-quic-load-balancers-16](https://datatracker.ietf.org/doc/draft-ietf-quic-load-balancers/)
    * see also [インフラエンジニアなら気になるQUICのロードバランサ (方式編) | by Jun-ya Kato | nttlabs | Medium](https://medium.com/nttlabs/quic-load-balancer-design-82c5fbae8305)
    * ロードバランサー越しのQUICについて
    * Google級の規模のデータセンターにおいてはConfig Rotationの空間が枯渇するので1bit増やしたという話
        * [Expand to 3 Config ID bits · Issue #215 · quicwg/load-balancers](https://github.com/quicwg/load-balancers/issues/215)
* [draft-zmlk-quic-te-00](https://datatracker.ietf.org/doc/draft-zmlk-quic-te/)
    * multipath QUICと大体同じ人達からのdraft
    * packetがどういう経路を通って宛先に届くか
        * multipath QUICとの違いはroutingの優先順位付け？
    * 結構白熱した印象？まだまだ考慮する点がいっぱいありそうでした
* [draft-seemann-quic-nat-traversal-00](https://datatracker.ietf.org/doc/draft-seemann-quic-nat-traversal/)
    * いわゆる「NAT越え」をQUICで行うことについて
    * やろうやろうということになりそう

### Media over QUIC (moq)
<https://datatracker.ietf.org/meeting/117/session/moq/>

moqはQUICを用いたメディア転送に関するプロトコル、Media over QUICを策定するためのworking groupです。今議論されているのはMedia over QUICそのものの仕様をどうするか、という点ですね。まだmoq wgからRFCは出ていません。116もそうでしたが、moqはセッションが2回ありました。なぜなんでしょうか。

draftを読んだりミーティングを聞いたりして感じたことは、やはりメディア転送についての知識が必要になるなということです。本当に難しい。別に他のWGの内容が簡単で理解できるという訳ではありませんが。

* [draft-ietf-moq-transport-00](https://datatracker.ietf.org/doc/draft-ietf-moq-transport/)
    * <https://github.com/moq-wg/moq-transport/issues> について
    * issueが多すぎでは……という意見があった
    * とにかく沢山の議題があった
* [draft-law-moq-warpstreamingformat-00](https://datatracker.ietf.org/doc/draft-law-moq-warpstreamingformat/)
    * <https://github.com/moq-wg/warp-streaming-format/issues> について
    * CMAFとか色々わからない概念が出てきてわからない
* [draft-jennings-moq-usages-00](https://datatracker.ietf.org/doc/draft-jennings-moq-usages/)
    * とりあえず実装が揃うのを待つ、という段階？
* [draft-mzanaty-moq-loc-01](https://datatracker.ietf.org/doc/draft-mzanaty-moq-loc/)
    * Low Overhead (Media) Containerの略でloc
    * 個人draftからwg draftに移動する

### Transport Layer Security (tls)
<https://datatracker.ietf.org/meeting/117/session/tls/>

TLS WGにおいて前回からの大きなUpdateといえば、個人的にはdraft-rsalz-tls-tls12-frozen-01がでてきたことでしょか。

* [draft-ietf-tls-wkech-03](https://datatracker.ietf.org/doc/draft-ietf-tls-wkech/)
    * [Encrypted Client Helllo](https://datatracker.ietf.org/doc/draft-ietf-tls-esni/)のConfiguration値を `https://$ORIGIN/.well-known/origin-svcb` で取得できるようにしようというdraft
    * > Next draft might be final
        * らしい？
        * ところでもうindividual draftじゃないのに https://github.com/sftcd/wkesni なんですね、https://github.com/tlswg 以下じゃないんだ。
* [draft-ietf-tls-esni-16](https://datatracker.ietf.org/doc/draft-ietf-tls-esni/)
    * こっちはEncrypted Client Helloの本丸
    * Firefoxのtelemetryから、ECHがどのような状況にあるかの共有がされた
        * > ECH is faster for lowest 25% and slower for fastest %25
    * 118までにChromeでも1%のtrialが始まるかも？
* [draft-jackson-tls-cert-abridge-00](https://datatracker.ietf.org/doc/draft-jackson-tls-cert-abridge/)
    * 新しいdraft、WebPKIのために要約された証明書の圧縮について
    * post-quantum CA Certificateへのmigrationをsize penaltyなしでやりたい
    * <https://www.ccadb.org/> っていうCAのdatabaseがあり、これを辞書として圧縮をする
* [draft-rsalz-tls-tls12-frozen-01](https://datatracker.ietf.org/doc/draft-rsalz-tls-tls12-frozen/)
    * TLS 1.2に対する新規暗号スイートの追加などの更新は行わず、TLS 1.3以降の使用を推奨するというdraft
    * 賛成多数

### Messaging Layer Security (mls)
<https://datatracker.ietf.org/meeting/117/session/mls/>

E2EEなメッセージのやりとりをどうするかについてのWGです。

* [draft-barnes-mls-addl-creds-00](https://datatracker.ietf.org/doc/draft-barnes-mls-addl-creds/)
    * MLSでのユーザーの認証としてOpenID Connectを使う方法についてのdraft
    * OpenID側のUserInfo Verifiable Certificateについての文書は <https://openid.net/specs/openid-connect-userinfo-vc-1_0-00.html> かな？
    * 特に反対意見はなかった
* [draft-mahy-mls-x25519kyber768draft00-00](https://datatracker.ietf.org/doc/draft-mahy-mls-x25519kyber768draft00/)
    * 名前がすごいややこしいけど、[X25519Kyber768Draft00](https://datatracker.ietf.org/doc/draft-westerbaan-cfrg-hpke-xyber768d00/)というのがX25519とKyberを組み合わせたpost-quantumなKey Encapsulation Mechanismの提案で、それをMLSで使用できるciphersuiteの一種として追加しようというもの
    * 特に反対意見はなかった
* [draft-mahy-mls-selfremove-00](https://datatracker.ietf.org/doc/draft-mahy-mls-selfremove/)
    * MLSのmessage groupにおいてある部屋から自分が退出する方法を定めるもの。kick的な仕組みはあるけど、自分から抜ける仕組みはまだ確立されてなかったようだ

### Congestion Control Working Group (ccwg)
<https://datatracker.ietf.org/meeting/117/session/ccwg/>

ccwgは輻輳制御に関するworking groupです。もともと[congress](https://datatracker.ietf.org/wg/congress/documents/)という名前だったのが、ccwgに改名されました[^ccwg-name]。

[^ccwg-name]: <https://mailarchive.ietf.org/arch/msg/congress/rHNowIkEJt8SZy4PkUYzAt2c0nw/> congressという単語よりccwgのほうがclearだというのは、確かにそうですね。

* [draft-scheffenegger-congress-rfc5033bis-00](https://datatracker.ietf.org/doc/draft-scheffenegger-congress-rfc5033bis/)
    * > The goal of this document is to provide guidance for considering alternate congestion control algorithms within the IETF.
    * IETFで輻輳制御アルゴリズムを標準化する場合のガイダンス(RFC 5033)をあたらしくしようというもの。いまところはRFC 5033とほぼ同じで、とりあえずはそこから始めていこうということになった？
* [draft-nishida-ccwg-standard-cc-analysis-01](https://datatracker.ietf.org/doc/draft-nishida-ccwg-standard-cc-analysis/)
    * RFCで標準化されているいくつかの輻輳制御アルゴリズム間でどのような差異があるかをまとめた文章
    * transport protocolから独立したRenoの標準化をする流れがある？
        * RFC 5681はTCPとして、RFC 9002はQUICの一部としてReno(を元にした輻輳制御アルゴリズム)を標準化している
* [draft-fairhurst-ccwg-cc-00](https://datatracker.ietf.org/doc/draft-fairhurst-ccwg-cc/)
    * 文書の立場としては "Best Current Practice" を提供するもの
    * > Working Group should consider adopting a new term instead of “congestion control”.
        * congeastion controlに代わる用語を決める必要性が提示された
        * draft-scheffenegger-congress-rfc5033bisとしても考えよう、という流れ？
* [draft-cardwell-iccrg-bbr-congestion-control-02](https://datatracker.ietf.org/doc/draft-cardwell-iccrg-bbr-congestion-control/)
    * Googleが開発したBBRのversion 3を標準化するもの。v3自体はもう運用されていて、コードも公開されている
    * そもそもBBRはRFCになっていないようなので、これはBBRをRFCとして標準化しようという取り組みということ？
        * このdraftがUpdatesするRFCが記載されていない
* [draft-romo-iccrg-ccid5-00](https://datatracker.ietf.org/doc/draft-romo-iccrg-ccid5/)
    * TSV WG(Transport Area Working Group)でやるべきでは、という意見があった
* [draft-miao-ccwg-hpcc-00](https://datatracker.ietf.org/doc/draft-miao-ccwg-hpcc/)
    * そもそもHPCCという輻輳制御アルゴリズムがあり、これはそれを拡張したものを標準化しようというもの
    * スライドを見ると、輻輳制御のためのtelemetryをより(inbandで)で収集しようということ？

### Building Blocks for HTTP APIs (httpapi)
<https://datatracker.ietf.org/wg/httpapi/documents/>

普段はこのWGの動向は追っていないのですが、 [Kaigi on Rails 2021でohbaryeさんが発表してくださった「Safe Retry with Idempotency-Key Header」](https://kaigionrails.org/2021/talks/ohbarye/)で紹介されている [draft-ietf-httpapi-idempotency-key-header](https://datatracker.ietf.org/doc/draft-ietf-httpapi-idempotency-key-header/) がagendaにあったので参加しました。これは一度expiredになってしまったのですが、つい最近03が公開されて再度activeに戻っています。

* [draft-ietf-httpapi-idempotency-key-header-03](https://datatracker.ietf.org/doc/draft-ietf-httpapi-idempotency-key-header/)
    * 詳しくは [Idempotency-Key Headerの現状・仕様・実装の理解を助けるリソースまとめ - valid,invalid](https://ohbarye.hatenablog.jp/entry/2021/09/06/idempotency-key-header-resources) を見るといいかもしれません。前述のohbaryeさんのまとめです。
    * 議論自体はあんまり前進した感じではなさそう、RFCになるのはまだまだ先なのかもしれないです

## まとめ
むずかしいですね。
