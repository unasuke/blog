---
title: "IETF 116 Yokohamaに参加してきました(IETF Meetingに参加しよう)"
date: 2023-04-02 19:00 JST
tags: 
- ietf
- quic
---

![IETF 116の受付あたりの写真](2023/ietf116-reception.jpg)

## IETF、IETF Meetingとは
※ IETF 116などの定期的に開催されるin-personな会合をこのブログでは "IETF Meeting" と呼びますが、正式名称ではない可能性があります。正式名称があったら教えてください。ちょっと探したけど総称っぽいものが見付かりませんでした。

IETFは、"Internet Engineering Task Force" の略で、インターネットの標準を決める団体です。ざっくばらんに言えば、RFCを出しているところです。

IETFが何なのかについては、既に良い説明があるのでそちらを参考にするのがいいでしょう。以下にリンクを貼っておきます。

* [インターネット用語1分解説～IETFとは～ - JPNIC](https://www.nic.ad.jp/ja/basics/terms/ietf.html)
* [IETFとは～はじめに～ - JPNIC](https://www.nic.ad.jp/ja/tech/ietf/section1.html)
* [IETFとRFC - JPNIC](https://www.nic.ad.jp/ja/tech/rfc-jp.html)
* [JPRS トピックス＆コラム No.22 | インターネット標準の作られ方 | JPRS](https://jprs.jp/related-info/guide/topics-column/no22.html)
* [IETF | The Tao of IETF: A Novice's Guide to the Internet Engineering Task Force](https://www.ietf.org/about/participate/tao/)
    * "A Novice's Guide to the Internet Engineering Task Force" ともあるように、IETFなにもわからん、という状態であれば読むととても助けになる文章だと思います。

さて、そんなIETFの116回目のMeetingが横浜で行われるとのことなので参加してきました。ただ、僕は都合上Hackathon(日曜)と木曜日のみの参加でした。

## 前準備
まずはIETFがどのような構造を持つ組織で、どのように議論が進んでいくのかを頭に入れておくと、議論が現在どういう状態にあるのかを把握でき、理解の助けになります。以下のリンクを読み、そのあたりの勉強をしました。

* [IETF116 Yokohamaをもっと楽しむために (その1) \~参加申し込み\~ - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2022/11/24/002658)
* [IETF116 Yokohamaをもっと楽しむために (その2) \~当日編\~ - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2023/03/26/155210)
* [IETFの構造とインターネット標準の標準化プロセス 林 達也, ⼩原 泰弘  94th IETF Yokohama Japan(PDF)](https://www.ietf.org/proceedings/94/slides/slides-94-edu-localnew-3.pdf)
* [勉強会「IETFの歩き方」 一般社団法人日本ネットワークインフォメーションセンター - YouTube](https://www.youtube.com/watch?v=PsHEvHKUTh8)
    * IETF 116 Yokohamaが開催されるにあたり、初参加される方を対象にして開催された勉強会のアーカイブです。
    * <https://www.isoc.jp/activities/ietf116_howto_event/>

次に、自分の興味がある分野のdraftなど、Agendaに記載されている資料について読んでおきます。IETFの会議は、既にMailing listである程度議論されているdraftの内容について実際に対面で意見を交わすという場なので、draftは読んでおくべきでしょう。

## 参加したセッション
以下、メモは常体です。正確性の保証はありません。

### Hackathon
<https://wiki.ietf.org/en/meeting/116/hackathon>

Hackathonは特定のprojectには参加せず、自分がやっているcurlのHTTP/3版ビルドをメンテナンスしたり、QUIC実装のデバッグをしたりしていました。

### QUIC
<https://datatracker.ietf.org/meeting/116/session/quic/>

* [draft-ietf-quic-v2-10](https://datatracker.ietf.org/doc/draft-ietf-quic-v2/) と [draft-ietf-quic-v2-10](https://datatracker.ietf.org/doc/draft-ietf-quic-v2/) はAUTH48という状態になった
    * → もうしばらくするとRFCになる
* [draft-ietf-quic-multipath-04](https://datatracker.ietf.org/doc/draft-ietf-quic-multipath/)
    * 複数の通信経路を用いたQUICによる通信を行うための仕様
        * 複数Path間でパケット番号空間を分けるのはなかったことになった
        * Pathの識別子をどうするかについての議論
* [draft-ietf-quic-ack-frequency-04](https://datatracker.ietf.org/doc/html/draft-ietf-quic-ack-frequency)
    * ackの頻度について
        * `ACK_FREQUENCY` frame とか `IMMEDIATE_ACK` frameとか
        * *Is One ACK per RTT enough?* についての議論
* [draft-ietf-quic-qlog-main-schema-05](https://datatracker.ietf.org/doc/html/draft-ietf-quic-qlog-main-schema)
    * QUICの通信状況をloggingするformatであるQLOGについて
    * いくつかのkeyの名前を短かくする提案 ( **would be a fairly large breaking change to implementations!** )
    * 外部のschemaを参照できるような `additional_schema` について
* [Reliable Stream Resets (PDF)](https://datatracker.ietf.org/meeting/116/materials/slides-116-quic-closing-streams)
    * WebTransportにおけるユースケースからの提案について。streamをresetする時に送信するframeの名前についてどうする？という議論だったと思う
    * [draft-seemann-quic-reliable-stream-reset](https://datatracker.ietf.org/doc/draft-seemann-quic-reliable-stream-reset/)
        * > the `RELIABLE_RESET_STREAM` frame, that resets a stream, while guaranteeing reliable delivery of stream data up to a certain byte offset
    * 絵に描いたような自転車置き場の議論が始まって面白かった
* [QUIC handshake challenges (PDF)](https://github.com/quicwg/wg-materials/blob/main/ietf116/quic-handshake-challenges.pdf)
    * 証明書のサイズによってhandshakeのRTTが増加することについてどうするか、等のQUICのhandshakeにおけるいくつかの問題点についての話
    * 途中で時間がなくなって続きはMLで、になった


### Media Over QUIC (moq)
<https://datatracker.ietf.org/meeting/116/session/moq/>

むずかしい！

* [draft-nandakumar-moq-scenarios-00](https://datatracker.ietf.org/doc/draft-nandakumar-moq-scenarios/)
    * moqが使われるシナリオ、どういう状況下で使われるかについて？
        * 複数のmedia source、複数のrelay、複数のreceiver(かつ様々な帯域)、それに認証も加わる
    * エンコーディングについての言及もあった……けどちょっとよくわからない
* [draft-nandakumar-moq-transport-00](https://datatracker.ietf.org/doc/draft-nandakumar-moq-transport/)
    * MoQTransportについて
        * > This specification defined MoqTransport (moqt), an unified media delivery protocol over QUIC
    * どういう機能を持つか、についての説明とそれについての議論だった……と思う
* [draft-lcurley-warp-04](https://datatracker.ietf.org/doc/draft-lcurley-warp/)
    * Warp (QUIC上でメディア転送を行うプロトコル)の基本的な振る舞いを定めるもの。
        * もともとTwitchから出てきたdraftだけど、今はTwitchに加えてMeta、Cisco、そしてGoogleの人が加わっている。
    * これについてデータをまとめる単位をどうしようという議論があった
* [draft-ma-moq-relay-for-deadline-00](https://datatracker.ietf.org/doc/draft-ma-moq-relay-for-deadline/)
    * Relay serverがデータごとに設定されているdeadlineを読んで適切にパケットをハンドリングする仕組みについての提案？転送コストを抑えたいという要求から。

メディア転送、既にあるWebTransportではなくMoQ(MoQTransport)を定義したいモチベーションとしては、WebTransportはHTTP/3の上にあるプロトコルなので、映像配信をするのにサーバーがHTTP/3を解釈する必要があり、そうじゃなくQUICの上で直にメディア転送ができると嬉しいということらしい(会場で又聞きした)

### Automated Certificate Management Environment (acme)
<https://datatracker.ietf.org/meeting/116/session/acme/>

* [draft-ietf-acme-ari-01](https://datatracker.ietf.org/doc/draft-ietf-acme-ari/)
    * 証明書の更新リクエストを送るタイミングを指定できるようにするための仕組みについて
        * 発表者不在のため、これについてのセッションは行われなかった
* [draft-ietf-acme-dns-account-01-00](https://datatracker.ietf.org/doc/draft-ietf-acme-dns-account-01/)
    * 新しいACME Challengeである `dns-account-01` を定義するもの
        * 参考 : [チャレンジの種類 - Let's Encrypt - フリーな SSL/TLS 証明書](https://letsencrypt.org/ja/docs/challenge-types/)
    * 複数のACME accountを跨げる識別子を発行してそれによる認証を行えるようにする
        * > This allows multiple systems or environments to handle challenge-solving for a single domain.
    * ドメインの向き先が複数事業者を跨ぐ場合に助かるとのこと
    * 発表の中では、Let's Encrypt ではもう実装されてる、みたいな言い方をされていたけど、実際にLet's EncryptのCA実装であるboulderを見にいってもそれらしいものはなかった。まだinternalなんだろうか？という話を友人と会場でした
        * <https://github.com/letsencrypt/boulder>
* [draft-misell-acme-onion-00](https://datatracker.ietf.org/doc/draft-misell-acme-onion/)
    * Tor network上の `.onion` domain に対してもACMEによる証明書の自動発行が可能になるようにしようというもの

## IETF Meetingに行こう

IETF、インターネットの標準化について「興味はあるし、楽しそうだけど敷居が高くて、自分はまだそのレベルじゃないな」と尻込みしている人が多いのではないかと思います。確かに、議論の内容はインターネットの最先端についてなので予習しておかないとついてはいけませんし、しかし予習したからといってついていけるわけでもないですし、何より英語でのやりとりを理解する必要があります。ただ文字起こしがあるので、あとからゆっくり読み返すことはできます。

しかし、IETFそのものが初心者を歓迎しているイベントです(そう感じました)。理由は、参加回数が5回未満であれば名札に "NEW ATTENDEE" というリボンを付けることができます。初参加者向けの "New Participants' Social Hour" というイベントもあります。つまりそのようなNewbieに対するサポートを行うという意識が参加者の間にはあるということです。実際、わからないことを聞いても突き放されることなく、丁寧に教えていただけました。

![IETF116の参加記念？Tシャツと名札。NEW ATTENDEEのリボンをつけている](2023/ietf116-t-shirt-and-lanyard.jpg)

ただやっぱり、趣味で行くにはEarly Birdであっても$700というのは厳しいものがあります。これについては、(レポートなりを書くことで)業務扱いとして参加費を出してくれる企業が増えてくれることを願うばかりです。特に「若い人達が流入してくれないか」というのを懇親会ではよく耳にしましたし、そのためには若者の手を引いてくれる先輩の存在が、そしていずれそのような先輩となってくれるような、標準化の分野に興味のある人が参加しやすいような土壌をつくることが重要です。インターネットは、欧米の大企業が作っているものを享受する、というものではなく、人類全体で作っていくものです。インターネット上でサービスを提供している企業であれば、インターネットをより良くしていくための活動に対しては支援を惜しむべきではありません。それこそ、社内で採用されているプログラミング言語やフレームワークのカンファレンスに対する参加支援と同じような流れで、IETF Meetingの参加費を支援する企業が増えてくれると嬉しいですね。毎回とはいかないまでも、せめて国内開催の場合は旅費交通費を含めた支援がされるのが望ましいのかもしれません。

そして、お金を払って参加するのであれば、何か目標を自分に課すといいかもしれません。議論の様子や発表される資料は全て公開されています。それでも現地に参加するのは、実際に「インターネット」に関わっている人達に会えるからです。実際僕も、今回のIETF Meetingで「QUIC working groupのchairに話してQUIC開発者が集まっているSlackに招待してもらう」ことを目標として参加し、達成しました[^quicdev-slack]。現地参加するのであれば、現地参加だから意味のある目標をひとつ決めて参加するのがいいと思います。

[^quicdev-slack]: もちろんmailing list経由で招待してもらうこともできると思います。しかしこんな良いタイミングでIETFがあるなら直接、と考えました。

それと、チケットはWeek Pass(全日)を買っておくほうが絶対に良いです。僕は日和ってAgendaが確定した後にOne-Day Passを購入しましたが、自分の興味のある分野のMeetingが1日に集中することは本当にまれですし、一旦Agendaが確定した後に突然Meetingが生えたりすることもあります。

(ついでに言うと、1日しか参加しないにしても、Agendaの決定を待たずに購入するべきでした。参加当日、正確には受付時に判明したのですが、One-Day Passを購入する段階ではどの日に参加するかを選ぶものではなく、受付のタイミングでどの日に参加するか伝えるというものでした。上の写真の名札にある "THURSDAY" はその場でスタンプされたものです。つまりどういうことかというと、Early価格で買えたのにAgendaを待ってたからLate価格になってしまった……という話です。このシステムが116特有のものか、ずっとこのシステムなのかはわかりませんが。)

僕もこの界隈に足を踏み入れたばかりなので右往左往していますが、それでも参加して楽しかったし、今になっては全日程参加しておけばよかったと思っています。QUICというプロトコルに関しての活動をしているタイミングで、国内でIETF Meetingが開催されるというのは本当に幸運だったと思います。

次回、117はサンフランシスコで開催されるようです。時差が厳しい問題ではありますが、まずはRemote参加をしてみるというのは検討してみてもいいのではないでしょうか。僕も参加するとしたらリモートになるでしょうし。

<https://www.ietf.org/how/meetings/117/>
