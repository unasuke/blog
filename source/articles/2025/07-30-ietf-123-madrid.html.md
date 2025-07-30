---
title: "IETF 123 Madridにリモート参加してませんでした"
date: 2025-07-30 23:35 JST
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
---

![](2025/ietf-123-madrid.png)

## IETF 123
今回のIETF 123は、Kaigi on Rails 2025の準備が忙しくなってきたり、CEDEC2025のほうに顔を出していたりということもあって、リアルタイムで参加したセッションはありませんでした……

それでは例によって以下は個人的な感想を無責任に書き散らかしたものです。内容の誤りなどについては責任を取りません。ちなみになんですが、WG及びBoFは <https://datatracker.ietf.org/meeting/123/agenda> で開催された順に記載しています。多分。

## ccwg
### Agenda
* <https://datatracker.ietf.org/meeting/123/session/ccwg>

議題としてはRate-limited sendersとBBRv3が主、かな？L4Sに関してはスライドはあるけどとりあげる時間はなかったみたい。スライドを見ると、iOSのDeveloper ModeではL4Sに関する設定ができるっぽい。

<https://developer.apple.com/documentation/Network/testing-and-debugging-l4s-in-your-app>

minutesの最後に "We created a whole simulator for BBR over QUIC. It’s open source." って書いてるけどどこにあるの！！！

### Testing Congestion Control and Queue Management Mechanisms (Hackathon update)
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-ccwg-hackathon-update-00.pdf>

ns-3を用いた、なんか……色々な……輻輳制御に明るくないので、このスライドをどう見ればいいのかわからない。輻輳制御評価を自動化する仕組みなどで協力者募集中というのはわかる。

### Rate-limited senders
* <https://datatracker.ietf.org/doc/draft-ietf-ccwg-ratelimited-increase/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-ccwg-increase-of-the-congestion-window-when-the-sender-is-rate-limited-draft-ietf-ccwg-ratelimited-increase-01-00>

IETF 122からの変更点は例に参照を追加するのとRTTが何を意味するかの定義を追加したこと、"MUST constrain the growth of cwnd" の部分を削除して3つのルールを2つにしたこと(FlightSize < cwndの場合において？)。Pacingについての議論が行われ、その問題が解決すればWGLCに進むっぽい。

### BBRv3
* <https://datatracker.ietf.org/doc/draft-ietf-ccwg-bbr/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-ccwg-bbr-july-2025-03-update-00.pdf>

IETF 122からの変更はECNの方針についての文書化、このdraftがexperimentalであることを明記(確かにIntended Statusが    Experimentalになっている)、章構造の変更などなど。issueとして挙げられているのが、TCPでないtransport protocolに対する一般化、ProbeRTTを5秒毎にするのか10秒毎にするのか、が主な2つで、他にもopen  issueについてつらつら書かれている。
会場での議論はProbeRTTについてが主だったよう。Starlinkではどうなんだ、という意図の発言があったみたいだけど、どういう挙動なんだろう。" Starlink 15s reconfiguration rhythm" とminutesには記載さているけど。

### Insights into BBRv3’s Performance and Behavior by Experimental Evaluation
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-ccwg-insights-into-bbrv3-performance-and-behavior-bless-00>
* <https://doc.tm.kit.edu/2025-bbrv3-eval-networking2025-authors-copy.pdf>

これはdraftではなく学術論文。BBRv3の性能評価について。2つの送信者、ルーター、1つの受信者の関係で、ルーター内でボトルネックとなる帯域を変化させたりACKに対するdelayを挿入したりして実験を行っている。CUBICよりは良い性能が出ている？Wi-Fi環境においてはまた異なる挙動を示すかもしれず、それは別の研究として有望、などの意見があった。

## webbotauth
### Agenda
* <https://datatracker.ietf.org/meeting/123/session/webbotauth>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-webbotauth-1-chairs-slides-00>

これはBoFで、WGになっていない。そもそも何のBoFかっていうと(minutesのbackground/contextより)トラフィックの30%が人間でもブラウザでもなく(これはいつの時点で？)、2024年に初めてBotのトラフィックが人間のそれを上回った。現在、人間かBotかの識別はUser-Agent(偽装可能)、IPアドレス(IPを公開する必要有)、DNS逆引き(運用上の問題有)によって行なわれている。より良いWebは、暗号学的に識別できるBot、暗号学的に識別できないBot(これどういうこと？)、人間から成る。解決策は既存のWebとの互換性が必要、複雑なWebインフラの上で動作する必要があり、認証及びビジネス上の決断に対してchoke pointとなることを避ける(？)必要もある。暗号学的な信頼は新規の中央集権構造となるべきではない……みたいな。

<https://datatracker.ietf.org/meeting/123/materials/slides-123-webbotauth-background-and-context-00>

### Cloudflare Use Cases
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-webbotauth-cloudflare-use-cases-00>
* <https://datatracker.ietf.org/doc/html/draft-meunier-web-bot-auth-architecture-02>
* <https://datatracker.ietf.org/doc/draft-nottingham-paid-crawl-reqs/>

ここでの "Use Cases" って何を指すのだろう。まずOrigin Controlとして、HTTP Signatureを用いたBot(クローラー)とOrigin間での認証についてのdraftが参照されている。これで特定のトラフィックを遮断もしくは通過させたり、Rate limitをかけたりということをしたい。次にCrawlerの認証についても言及されている。身元を偽装できず、管理がシンプルでスケール可能な仕組みを構築したい。そしてCloudflare Workers(など)がProxyとして中間に挟まる場合の挙動についても言及されている。

多分 [IETFでのPaid Web Crawlingの議論 - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2025/07/23/004043) についての話もされた。まあ [Introducing pay per crawl: Enabling content owners to charge AI crawlers for access](https://blog.cloudflare.com/introducing-pay-per-crawl/) っていうブログも書いてるしね。これを標準化しようってこと……か？(このブログで書いてること、draft-meunier-web-bot-auth-architectureでやってることに見える。まあ著者が一緒だし)

ところで <https://datatracker.ietf.org/doc/draft-jhoyla-req-mtls-flag/> が関係してるのでは？！と勘ぐってたけど、そんな言及はなかったぽい。まあちょっとレイヤーが低いか。

### SPIFFE at the BotAuth BoF
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-webbotauth-spiffe-at-the-botauth-bof-pieter-kasselman-00>

そもそもまず <https://spiffe.io/> (スピッフェかと思ったら登壇者はスピフィーと読んでる)というものがあり、これでBotを認証できないか？という話のよう(メーリングリストで話題になったので説明を依頼されているのだそう)。パプリックなSPIFFE基盤はこれまで観測できてない。ので使えるのか？という部分に関しては考えないといけないことが多い……という話だと理解した。

### Web Bot Authentication BBC Use Cases
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-webbotauth-web-bot-authentication-bbc-use-cases-00>

めっちゃBotからのアクセスが多そうなBBCの中の人からの発表。`www.bbc.com` へのアクセスの23%はBot。robots.txtを無視してくるやつもある。Botからのトラフィックによって過負荷になっている部分もある。特にBBCの配信しているコンテンツは、AI企業からの利用に対してはライセンス供与をする立場にあるのでより良いアクセス制御の方法を求めている。ただどのようにBotをBotと判定するかが困難。

### Vercel Web-Bot-Auth Use Cases
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-webbotauth-vercel-web-bot-auth-use-cases-00>

ここでVercelの名前を見るとは。ユースケースとして挙げられているのは、許可、拒否、Rate limitなどのルールをカスタムできること、可観測性、検証されてないBotからのアクセスのブロック、身元偽装からの保護、Vercel Botのidentification。Vercelの立場としては、良いBot、悪いBotの区別はしない、顧客によってコントロール可能であること、許可型のデザインでること、検証可能であること？

### reCAPTCHA and Agents
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-webbotauth-recaptcha-and-agents-00>

まあ、(re)CAPTCHAってBotにとっては……というのはある。AI agentが何段も重なる状況でのアクセスや、Agent-in-browser時代のことも話題として挙げられている。質問があったけどminutesには記録されてないな。

### Google Crawler Infra
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-webbotauth-8-google-crawler-infra-01>

クローラーのプロこと(？)Google。それがどういう構成で動いているのかの話。CrawlerとFetcherという言葉を使い分けている。Googlebotからのアクセスということは、User-Agentでの判別と、[アクセス元IPでの判定とDNSの逆引き](https://developers.google.com/search/docs/crawling-indexing/verifying-googlebot?hl=ja)で可能になっている。求めるのは、シンプルであること、スケール可能であること、エコシステムフレンドリーであること。

### OpenAI Use Cases
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-webbotauth-openai-use-cases-00>

他のAI企業、例えばAnthoropicは出てきてないのだろうか。ともかくOpenAIはあるWebサイトがBotによるアクセスを制御できるようにしたい。

### Charter discussion
そもそもどうするねんという話になった。たぶんこれはもうWGになるのは確定で、Google Docs上でWGの憲章についての策定が行われている。IETFでやるべきことかについての投票も行われ、賛成多数になってる。

## moq
### Agenda
* <https://datatracker.ietf.org/meeting/123/session/moq>

「名前変えない？」という議論があったようで。名前を変えるタイミングに関して遅すぎるという意見はなかったものの、そもそも名前変える必要ある？という意見が多数派だったようで、名前は変わらなかった。2回目では、Media Over QUICの略ではなく別の言葉の略にしては？(many things over quic)という意見もあったが、自転車小屋の議論ということになり、やはり反対多数で名前の変更にはならなかった。

moqに関してはこの辺で……

## masque
### Agenda
* <https://datatracker.ietf.org/meeting/123/session/masque>

[`draft-ietf-masque-connect-udp-listen`](https://datatracker.ietf.org/doc/draft-ietf-masque-connect-udp-listen/) と [`draft-ietf-masque-connect-ethernet`](https://datatracker.ietf.org/doc/draft-ietf-masque-connect-ethernet/) がWGLCになった。

### QUIC-Aware Proxying Using HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-masque-quic-proxy/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-masque-quic-aware-proxying-using-http-00>

issue 116で議論されている、「ECBという単語を使わないようにする」 (electronic code blockかな？)に関してはRFC 9001への参照があるため対応せずにcloseで意見が一致。issue 85のECN forwardingに関してもcloseになるかと思いきや、今見たら質問コメが来ているのでどうなるかな？

相互運用性に関するhackathonの結果報告もあり、3つの実装で相互運用可能とのこと。

### Proxying Listener UDP in HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-masque-connect-udp-listen/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-masque-connect-udp-bind-00>

go-quicとGoogle QUICHEの間での相互運用が確認されている。issue 40についての議論がさかんだった。minustesを見ただけだと結論としてどうなったかがわからないな。

### Proxying Ethernet in HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-masque-connect-ethernet/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-masque-connect-ethernet-00>

interopのための実装募集中。

### DNS Configuration for Proxying IP in HTTP
* <https://datatracker.ietf.org/doc/draft-ietf-masque-connect-ip-dns/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-masque-dns-configuration-for-proxying-ip-in-http-01>

PREF64 ([RFC 8781](https://datatracker.ietf.org/doc/rfc8781/))をどうするかというのが議論。もしやるならそれに対しての相互運用性も確保すべきだよね、という話にはなっている。今は実装を作成中？

### ECN and DSCP support for HTTPS’s Connect-UDP
* <https://datatracker.ietf.org/doc/draft-seemann-masque-connect-udp-ecn/>
* <https://datatracker.ietf.org/doc/draft-westerlund-masque-connect-udp-ecn-dscp/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-masque-ecn-and-dscp-for-connect-udp-01>

ECN for Connect-UDPに対して2つのdraftが提出されていて、それに関するセッション。これに関してWGで取り組むべきか、という投票に関して賛成多数となった。(minutesにpollが載ってない！)

### The MASQUE Proxy
* <https://datatracker.ietf.org/doc/draft-schinazi-masque-proxy/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-masque-the-masque-proxy-00>

これ(`draft-schinazi-masque-proxy`)をMASQUE WGで取り組むためにrecharterする必要があるという話。なんならMASQUE WGをcloseする方向に流れつつあるように読める？現時点のWG draftに関する作業が全て完了したら終了するかも。

## tls
### Agenda
* <https://datatracker.ietf.org/meeting/123/session/tls>

6つのdraftがRFC Editor queueに入ってて、2つがIESGからの承認を得られている(いつのまにかrfc8446-bisもapprovedだった)。

### A Well-known URL for publishing service parameters
* <https://datatracker.ietf.org/doc/draft-ietf-tls-wkech/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tls-wkech-00>

Encrypted Client Helloに限らない、任意のservice parametersについての話になってる？(いつから？)draft見るとipv4hintやalpnも書けるようになってる。WGLC準備完了。

### Extended Key Update
* <https://datatracker.ietf.org/doc/draft-ietf-tls-extended-key-update/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tls-extended-key-update-01>

FATTによるレビューを受けている段階。4件のレビュー内容についての議論が行われた。もっと実装と相互運用性検証がしたい、などのnext stepが挙げられてる。

### Large Record Sizes for TLS and DTLS
* <https://datatracker.ietf.org/doc/draft-ietf-tls-super-jumbo-record-limit/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tls-large-record-size-00>

IETF 119での議論を受け、様々な部分が書き直された。最大長が(2^32)-256 bytes。そうでない場合は2^14なんだっけ？

### ML-KEM Post-Quantum Key Agreement for TLS 1.3
* <https://datatracker.ietf.org/doc/draft-ietf-tls-mlkem/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tls-ml-kem-post-quantum-key-agreement-for-tls-13-ietf-123-madrid-00>

"pure-PQ ciphersuite" ってなんだろう？hybridではないということか？IETF 122以来、様々なreviewに対応した。ClientHelloのサイズが大きくなったことでサーバーがハングした例が少数あったとのこと。

### A Password Authenticated Key Exchange Extension for TLS 1.3
* <https://datatracker.ietf.org/doc/draft-bmw-tls-pake13/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tls-tls-pake-extension-00>

"NOT aiming for general web login use case"。2つの実装がSPAKE2+のサポートによって実装完了している(ひとつはBoringSSL)。ただCPaceかSPAKE2+かOPAQUEかのどれをrequirementsとするかで若干割れてる？

### Dual Certificates in TLS 1.3
* <https://datatracker.ietf.org/doc/draft-yusef-tls-pqt-dual-certs/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tls-sessa-dual-certificates-in-tls-13-00>

どのようにPost-Quantumへとmigrateするか。これまでの証明書とPQ証明書の2つを扱えるようにすればという案。PKIが3つではなく2つであるなどの利点と、TLSのnegotiationが複雑になるし、実装も大変ではないかなどの欠点。これは……むずそう……
Chairから、メーリングリストで議論を深めようということになった。

ここまでが1回目。

### Workload Identifier Scope Hint
* <https://datatracker.ietf.org/doc/draft-rosomakho-tls-wimse-cert-hint/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tls-sessb-workload-identifier-scope-hint-00>

<https://datatracker.ietf.org/doc/draft-jhoyla-req-mtls-flag/> の精神的後継？そこからユースケースを拡張したものだと。

[OpenAI Mutual TLS Beta Program | OpenAI Help Center](https://help.openai.com/en/articles/10876024-openai-mutual-tls-beta-program) こんなんやってたんですね。やっぱWeb Bot Authにも関わってきそう。あとそもそもwimse WGの関心領域とも重なるという話がある？(スライド内でworkload identifierとしてるのは <https://datatracker.ietf.org/doc/draft-rosomakho-wimse-identifier/> のことっぽいし)

これもメーリングリストで議論することになった。

### TLS 1.3 Certificate Update
* <https://datatracker.ietf.org/doc/draft-rosomakho-tls-cert-update/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tls-sessb-tls-13-certificate-update-00>

証明書は様々な理由でexpireすることがある。長時間確立しているsessionにおいて、セッション期間よりも証明書の寿命が先に来た場合はどうなる？

いくつかの対応策が挙げられているなかのひとつがこの Certificate Update。certificate_update_request拡張をClientHelloとEncryptedExtensionsでやりとりする。

そもそも証明書の寿命よりセッションが長生きするという状況がまずいのでは、秘密鍵が漏洩したケースを想定しているが、その場合はそれどころではないのでは、証明書が無効になるのは期限以外にもあるのでは(TLSの責任ではないのでは)、など結構反対意見も多く、メーリングリストへの議論へと持ち越し。

### Reliable Transparency and Revocation Mechanisms
* <https://datatracker.ietf.org/doc/draft-mcmillion-tls-transparency-revocation/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tls-reliable-transparency-and-revocation-mechanisms-00>

今のCertificate Transparencyについて問題提起するもの。スライドの図でどういう提案なのかがわかる……？TLS clientがTLS serverに対して接続を開始するとき、TLS serverはtransparency log serverからKey Transparency proofを取得してそれをclientに返却する？

TLS WGには大きすぎるので、PLANTSメーリングリスト(ができる予定だそう)とBoFでやろうという提案があった。

###  Remote Attestation with Exported Authenticators
* <https://datatracker.ietf.org/doc/draft-fossati-tls-exported-attestation/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tls-remote-attestation-with-exported-authenticators-00>

TLS Exporterを使用して"現在の" evidenceを生成しようというもの。今回の発表は脅威モデルの定義が主？

### FATT Process Extensions
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tls-sessb-fatt-process-extensions-00>

プロトコル実装者と検証を行う人の数の差が大きい。形式検証のためのツールは習得が難しい。これを改善し、FATTプロセスを持続可能にしたい。minutesを読む限りでは、消極的賛成な感じ？(ここで挙げられている要件を全てのdraftがやる必要はないのでは？という意見)

### ECH Signed config (Implicit ECH)
* <https://datatracker.ietf.org/doc/draft-sullivan-tls-implicit-ech/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tls-ech-signed-config-00>

スライドのイラストがかわいい。Trust On First Useを略してTOFUと呼ぶの面白い。前向きに検討することとなった。

## httpbis
### Agenda
* <https://datatracker.ietf.org/meeting/123/session/httpbis>

今回httpbisは2回あった。

### Layered Cookies
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-rfc6265bis/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-httpbis-layered-cookies-00>

共有が行なわれただけ？minutesには特に記載事項がない。

### The HTTP QUERY Method
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-safe-method-w-body/>

スライドなし。GETのようなモデルなのかPOSTのようなモデルなのかという質問に対してはGETのようなモデルとの回答。関連してキャッシュをどうするかという話も出ている。新しい版を作成したらWGLCの検討に進むとのこと。

### Resumable Uploads
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-resumable-upload/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-httpbis-sessb-resumable-uploads-00>

未解決問題はなし、IETF 121で相互運用性の確認も済んでいる。WGLCを開始！

### Incremental HTTP Messages
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-incremental/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-httpbis-sessb-incremental-http-messages-00>

IETF 122でのフィードバックを受け、3つのissueをclose。WGLCに進むけど、関係者からのフィードバックを待つためにちょっと長く時間がかかるかもしれない？とのこと。

### Detecting Outdated Proxy Configuration
* <https://datatracker.ietf.org/doc/draft-rosomakho-httpbis-outdated-proxy-config/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-httpbis-detecting-outdated-proxy-configuration-00>

PACとPvDにおいて、設定の更新が行われるタイミングはクライアントに依存しているという問題。活発な質疑応答があったぽい。関心が多く、引き続き議論されるとのこと。

### Unencoded Digests
* <https://datatracker.ietf.org/doc/draft-pardue-httpbis-identity-digest/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-httpbis-sessb-unencoded-digests-00>

例えばgzip圧縮されたレスポンスを返すとき。gzipのdigestとgzipされる前のdigestをそれぞれ返すようにできる提案。headerの名前をどうする問題などの議論があった。実装募集中状態。

### Secondary Certificate Authentication of HTTP Servers
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-secondary-server-certs/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-httpbis-sessa-secondary-certificate-authentication-of-http-servers-00>

> This document defines a way for HTTP/2 and HTTP/3 servers to send additional certificate-based credentials after a TLS connection is established, based on TLS Exported Authenticators.

minutesを見ても結果としてどうなったかがわからないな……反対という感じではなさそうなので作業継続という状態なのだろうか？

### Template-Driven CONNECT for TCP
* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-connect-tcp/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-httpbis-sessa-connect-tcp-00>

WGLCに向け、相互運用性のテストを行いたい段階にある。

### HTTP Version Translation of the Capsule Protocol
* <https://datatracker.ietf.org/doc/draft-kb-capsule-conversion/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-httpbis-sessa-http-version-translation-of-the-capsule-protocol-00>

[RFC 9297](https://datatracker.ietf.org/doc/rfc9297/)に関連する提案かな。実際にこれによって解決したい問題がどのくらい発生しているのかについてはCDNは困っている(？)らしい。投票で、これについて取り組むことに賛成多数ということになった。

### Template-Driven HTTP Request Proxying
* <https://datatracker.ietf.org/doc/draft-schwartz-modern-http-proxies/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-httpbis-sessa-template-driven-http-request-proxying-00>

こ、混乱してきた……ユースケースと誤用のケースに対する理解を深めて議論する必要があるという結論になった。

## webtrans
### Agenda
* <https://datatracker.ietf.org/meeting/123/session/webtrans>

W3CでのUpdateの共有。<https://github.com/w3c/webtransport/tree/main/samples> にサンプル実装が置かれている。テスト用にホストされてるURLもスライドに掲載されている。

相互運用性の検証は計画通りにはいかなかったらしい。相互運用性のテストが完了するまではIESGに送らないとのこと。

### WebTransport over HTTP/2 and HTTP/3
* <https://datatracker.ietf.org/doc/draft-ietf-webtrans-http3/>
* <https://datatracker.ietf.org/doc/draft-ietf-webtrans-http2/>
* <https://datatracker.ietf.org/doc/draft-ietf-webtrans-overview/>

`_WEBTRANSPORT_` が `_WT_` になったり、`CLOSE_WEBTRANSPORT_SESSION` が `WT_CLOSE_SESSION` になったり他にも様々な更新が入っている。WGLCに向けて動き出す、と言ってる？！


## httpapi
### Agenda
* <https://datatracker.ietf.org/meeting/123/session/httpapi>

[api-catalogがRFC 9727になった](https://datatracker.ietf.org/doc/rfc9727/)。Linux FoundationのやっているAgent2Agent Protocolでこれを使うことになりそう。<https://github.com/a2aproject/A2A/pull/642>

JSON StructurについてBoFをやることになりそう。draft-ietf-httpapi-link-hintについては、JSONを使うのは正規化が複雑なので構造化フィールドを使用するよう変更された。draft-ietf-httpapi-digest-fields-problem-types、draft-ietf-httpapi-privacy、draft-ietf-httpapi-ratelimit-headersについてはWGLCに進むことに。

### Byte Range PATCH
* <https://datatracker.ietf.org/doc/draft-ietf-httpapi-patch-byterange/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-httpapi-byte-range-patch-00>

課題は、patchしたい部分が連続していない場合どうするか、media typeをどうするか、opaqueなmedia typeで末尾に追加するだけの場合どうするか。media typeどうするかっていうのはdiffを表現するのに標準化されたフォーマットがあるのかどうか、みたいなのを気にしているっぽく、例えばRFC 3284のVCDIFFとか、あとはPOSIXにある `diff -u` 形式とかが候補になるとminutesにはある。

### HTTP Events Query
* <https://datatracker.ietf.org/doc/draft-gupta-httpapi-events-query/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-httpapi-http-events-query-00>

今年初めに亡くなられたJosh Cohen氏が通知分野の研究を提案者のRahul氏に伝えたことがこのdraftの基礎となったとのこと。

あらゆるリソースに対する通知を行うこと、プロトコルの切り替えを必要としないことなど6つの要素がゴールとして挙げられている。

Server Side Eventとはどう違うのか、などの議論については今後メーリングリストでやろうということになり、httpapiが時間切れになった。

## happy
### Agenda
* <https://datatracker.ietf.org/meeting/123/session/happy>

しあわせそうな絵！

### Happy Eyeballs v3
* <https://datatracker.ietf.org/doc/draft-ietf-happy-happyeyeballs-v3/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-happy-happy-eyeballs-v3-ietf-123-02>

非同期解決、アドレスのソート、IPv6-mostlyやPREF64についてのハンドリング、あと表記の修正が入った。スライド見るとわかるけど、ANDとORの入り乱れ。しかもこれ、downgrade attachについても気にしないといけないのか。む、むずかしい……

他にもhackathon reportや論文についての発表もあったけどこの辺でギブ。

## wish
### Agenda
* <https://datatracker.ietf.org/meeting/123/session/wish>

例によってWHEPのみ。

### WebRTC-HTTP Egress Protocol (WHEP)
* <https://datatracker.ietf.org/doc/draft-ietf-wish-whep/>

pull req 31において、HTTP status codeをどうすべきかについて専門家に聞いてみることになったので会場の専門家に聞いたら303(see other)だろうということに。他にもいくつかの事項についての議論があった。今はexpiredになっているので、openなpull reqをmergeして01を出そうということに。

## quic
### Agenda
* <https://datatracker.ietf.org/meeting/123/session/quic>

Qlogに関して残っているissueは13。8月と9月でこれに取り組む時間を作る。Reliable resetsについても作業が進行中。Load balancersについては運用した知見を集めている段階。interimの内容についても共有が行われ、QMuxについて取り組むのはいいがQUIC wgなのかどうか、QUIC wgでやるとしたらrecharterが必要ではという話に。charterに "The fourth area of work" が追加されることに。

### Multipath extension for QUIC
* <https://datatracker.ietf.org/doc/draft-ietf-quic-multipath/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-quic-multipath-extension-for-quic-02>

IETF 122以降2つ版が進んだ。FrameやError codeの名前が変わったり。open issueについての議論が盛り上がって時間が足りなくなっていた。

### Extended Key Update in QUIC
* <https://datatracker.ietf.org/doc/draft-ietf-quic-extended-key-update/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-quic-extended-key-update-in-quic-00>

共著者の追加。通常のKey updateがcompromise後に行なわれてもsessionは脆弱なままだが、extended key updateでは再度secureなsessionになれる。[draft-ietf-tls-extended-key-update](https://datatracker.ietf.org/doc/draft-ietf-tls-extended-key-update/)側の変更を取り込んだりしている。そもそも同じことをやっているのでは？という疑問に対して、QUICではkey phase bitを使用できるという差分がある。draft-ietf-tls-extended-key-updateのほうはFATTをするけどこっちはどうなんだろう。仕組みが一緒なら結果は同じかな。

### Address Discovery
* <https://datatracker.ietf.org/doc/draft-ietf-quic-address-discovery/>

スライドはなし。いくつかの編集作業が完了したらWGLCに進めるとの共有があった。

### Ack Frequency
* <https://datatracker.ietf.org/doc/draft-ietf-quic-ack-frequency/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-quic-ack-frequency-00>

2023年のサンフランシスコになってて草。Frame形式に少し変更が入った。ロストした判定したパケットがやっぱり届いたときの挙動についての議論。これも議論が盛り上がっているな……

### QUIC Packet Receive Timestamps
* <https://datatracker.ietf.org/doc/draft-smith-quic-receive-ts/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-quic-quic-packet-receive-timestamps-00>

timestampについて、いくつかのpacketsなのか受信した全てのpacketsなのか、どちらの場合のtimestampもreportできるように変更された。QUIC Multipath(や他のQUIC拡張)との互換性について懸念事項がある？現時点でMvfstとGoogle quicheが実装しているとのこと。

### QMux comparing wire protocols
* <https://datatracker.ietf.org/doc/draft-opik-quic-qmux/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-quic-qmux-comparing-wire-protocols-00>

著者の名前を一文字ずつ取ってopik、なるほどね……スライドはプロトコルの比較。

| | frame encoding | negotiation | establishment latency* | record layer |
| --- | --- | --- | --- | --- |
| WT-over-H1 | capsules | HTTP header | 3 RT | TLS |
| capsules | capsules | QUIC v1 TP? | 2 RT | TLS |
| v1 frames | QUIC v1 | QUIC v1 TP | 2 RT | TLS |
| v1 frames & packets | QUIC v1 | QUIC v1 TP | 2 RT | QUIC v1-ish |
| (QUIC v1) | QUIC v1 | QUIC v1 TP | 1 RT | QUIC v1 |

スライドの表を写した。スライドのほうには注釈もあるのでそっちを参照のこと。それぞれの手法について特徴、利点と欠点が記載されている。recharter後にどの手法でいくかの議論ができるようにとのこと。どの手法が良いかに関しては発言キューがロックされるくらい盛り上がった。

### Deadline-Aware Streams for QUIC/QUIC-Multipath
* <https://datatracker.ietf.org/doc/draft-tjohn-quic-multipath-dmtp/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-quic-deadline-aware-streams-00>

DMTPというのは、そもそも "Deadline-aware Multipath Transport Protocol" という論文があって、それをQUIC Multipathに適用するのがこのdraftってこと？既にpicoquicベースの実装が <https://github.com/netsys-lab/picoquic/tree/dmtp_dev> にある。これは残り時間の関係で共有だけに留まった？

### QUIC Optimistic ACK
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-quic-quic-oack-00>

Optimistic acknowledgment (OACK) attackというのがあるんだ？あるんだ？っていうか、RFC 9000に書いてあったね……<https://datatracker.ietf.org/doc/html/rfc9000#name-optimistic-ack-attack> 全部忘れてるわ。で、この攻撃が成立するかの実験をしたら16の実装のうち11の実装でこの攻撃に対して脆弱であるということがわかった、と。いくつかの実装に関しては実装者に対して連絡し、修正された。

### Instant Acknowledgments in QUIC Handshakes
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-quic-instant-acknowledgments-in-quic-handshakes-00>

maprg wgで関連する話がされるという共有があった。内容に関してはちょっとスキップさせて……

<https://datatracker.ietf.org/meeting/123/session/maprg/>

## tiptop
### Agenda
* <https://datatracker.ietf.org/meeting/123/session/tiptop>

minutesがない？作られなかったのかな。[draft-ietf-tiptop-usecase](https://datatracker.ietf.org/doc/draft-ietf-tiptop-usecase/) が最初のWG draftになった。

### IP in Deep Space: Key Characteristics, Use Cases and Requirements
* <https://datatracker.ietf.org/doc/draft-ietf-tiptop-usecase/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tiptop-ip-in-deep-space-key-characteristics-use-cases-and-requirements-02>

Requirementsを見るとdeep spaceにおける通信プロトコロルが何を気にしなければいけないかがわかる。過酷な環境だ……

### Architecture for IP in Deep Space
* <https://datatracker.ietf.org/doc/draft-many-tiptop-ip-architecture/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tiptop-architecture-for-ip-in-deep-space-00>

深宇宙におけるL2レイヤは現実のそれとどう異なるのか、どのような特性を持つのか。やっぱりQUICが有力な選択肢なのね。8ページ目の図が、良い。やりすぎるとそれはQUICと呼べなくなるのでは？という議論があったみたい。どうなんでしょうか。

### Deployment and Use of the Domain Name System(DNS) in Deep Space
* <https://datatracker.ietf.org/doc/draft-many-tiptop-dns/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tiptop-deployment-and-use-of-the-domain-name-systemdns-in-deep-space-01>

深宇宙でのDNS、時間かかるよねという話。なので。「事前に全ての名前解決をしておく」「事前に全てのzoneを取得しておく」「必要な名前を持つ特別なzoneを用意する」「その他」のアプローチが提案されている。どれか1つを選択するのではなく、どの方法についても使用できるようにしては？という意見があった。他にも `.moon` や `.mars` TLDができるのか？みたいな話も。

### Deployment and Use of Email in Deep Space
* <https://datatracker.ietf.org/doc/draft-many-tiptop-email/>
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tiptop-deployment-and-use-of-email-in-deep-space-00>

> Sending email from Earth to deep space and back

宇宙に進出するSMTP！でもSMTPのやりとりは深宇宙ではRTTがとんでもないので推奨できない、ではどうするか？地上のlast SMTP hop serverがBatch SMTP MIME objectを作成してQUICで送る！！

そもそもメールを使う必要があるのか疑問、という意見も出ている。

### SCHC Applicability To IP in Deep Space
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tiptop-schc-applicability-to-ip-in-deep-space-01>

schc wgからの説明。Static Context Header Compressionの略。とにかく圧縮は重要。schcはステートレスで、計算量も少ないため深宇宙に向いている。

### Space Security and QUIC
* <https://datatracker.ietf.org/meeting/123/materials/slides-123-tiptop-space-security-and-quic-00>

セキュリティの話。QUICのTLS handshakeは同期的なコミュニケーションを前提としている。0-RTTには既知の問題がある。例えば打ち上げ前の段階でセッションを確立し、それを打ち上げ後も使い回す……これはいわば静的鍵暗号化であってQUICではないし、セキュリティの保証もできないと。耐量子暗号も帯域的にどうなのかという疑問。そこでQUICのhandshakeにMLSを使うという案がある。TIPTOP WGでやるのかQUIC WGでやるのかがちょっとわからなかった。

## Plenary
アメリカの新政権によって削除された文章についての話がちらっとあった？IETF 127は結局SF開催というのは動かなさそう

## まとめ
7月のうちに書き上げようと思って若干記載が薄くなっている部分がなくもないかな……
