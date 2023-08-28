---

title: "CloudNative Days Fukuoka 2023とRubyKaigi 2023 follow upのこと"
date: 2023-08-27 22:45 JST
tags:
- ruby
- quic
- aws
- gcp
- cndf2023
---

![](2023/cndf2023.jpg)

## CloudNative Days Fukuoka 2023とRubyKaigi 2023 follow up
8/3のCloudNative Days Fukuoka 2023(以下CNDF2023)と8/23のRubyKaigi 2023 follow upで発表しました。

* [CloudNative Days Fukuoka 2023](https://event.cloudnativedays.jp/cndf2023)
    * [パブリッククラウドにおけるQUIC現状確認2023年8月編 | CloudNative Days Fukuoka 2023](https://event.cloudnativedays.jp/cndf2023/talks/1890)
* [RubyKaigi 2023 follow up - connpass](https://rhc.connpass.com/event/288535/)
    * [RubyKaigi 2023 followup - unasuke - Rabbit Slide Show](https://slide.rabbit-shocker.org/authors/unasuke/rubykaigi-2023-followup/)

どちらも、自分が取り組んでいるQUICに関連する話をしてきました。

## 「パブリッククラウドにおけるQUIC現状確認2023年8月編」
CNDF2023においては、静的WebサイトとNginxなどのWebサーバーの2つの軸に対し、Public Cloud、特にAWSとGoogle CloudにおいてQUICでの運用が可能かどうかについての発表を行いました。

<iframe src="https://slide.rabbit-shocker.org/authors/unasuke/cndf2023/viewer.html"
        width="640" height="404"
        frameborder="0"
        marginwidth="0"
        marginheight="0"
        scrolling="no"
        style="border: 1px solid #ccc; border-width: 1px 1px 0; box-sizing: content-box; margin-bottom: 5px"
        allowfullscreen> </iframe>
<div style="margin-bottom: 5px">
  <a href="https://slide.rabbit-shocker.org/authors/unasuke/cndf2023/" title="CNDF2023">CNDF2023</a>
</div>

また、発表内で紹介した構成については、TerraformやWebサイトの構成をGitHubで公開しています。

* Webサイト<https://cndf2023.unasuke.dev/>
* GitHub <https://github.com/unasuke/cndf2023-infra>

半月ほどしか運用していませんでしたが、コスト削減を真面目にやっていなかったこともあり、AWS側で$122(&yen;17,000程度)、Google Cloud側で&yen;1,100ほどの費用がかかりました。

![AWSのコスト](2023/cndf2023-aws.png)

![Google Cloudのコスト](2023/cndf2023-gcp.png)

また、懇親会でのLT大会において、直前に開催されたIETF 117 San Franciscoで自分が聞いていたセッションで触れられていたdraftについて一言で説明していくという発表もさせていただきました。これについては発表資料はありませんが、[IETF 117 San Franciscoの参加記](/2023/ietf-117-san-francisco)でより詳細に記事にしています。


## 「RubyishなQUIC実装の進捗について」
RubyKaigi 2023 follow upでは、自分が取り組んでいるRubyishなQUIC実装についての進捗報告を行いました。

<iframe src="https://slide.rabbit-shocker.org/authors/unasuke/rubykaigi-2023-followup/viewer.html"
        width="640" height="404"
        frameborder="0"
        marginwidth="0"
        marginheight="0"
        scrolling="no"
        style="border: 1px solid #ccc; border-width: 1px 1px 0; box-sizing: content-box; margin-bottom: 5px"
        allowfullscreen> </iframe>
<div style="margin-bottom: 5px">
  <a href="https://slide.rabbit-shocker.org/authors/unasuke/rubykaigi-2023-followup/" title="RubyKaigi 2023 followup">RubyKaigi 2023 followup</a>
</div>

IETFやCNDF2023、Kaigi on Rails 2023の準備もありなかなかめぼしい進捗が出せていませんが、来年のRubyKaigi 2024でもproposalを出せるような成果を出せるようがんばりたいです。


## 余談 WebTransportについて
**以下の記載において、間違い等あれば訂正したいので気軽に言及してください。**

RubyKaigi 2023 follow upの会場で、「WebTransportはTCPの上にもQUIC(HTTP/3)の上にも展開されるのに、そこでリアルタイム性の求められる通信を行うのは、TCP及びQUICの欠損制御が邪魔になるのではないか？」という質問を頂いたのですが、その場で回答できなかったので調べました。

そもそもTCPと比較した際のQUICの優位点として、複数のstreamを使用することによるHead-of-line blocking(HOLB)の回避が挙げられます。WebTransport over HTTP/2ではこのstreamの独立をサポートしていません。また、続く "Partial Reliability" では、"HTTP/2 retransmits any lost data." とあるように、欠損したデータは全て再送されます(バッファリングできない分はdropすることが許可されます)。

> Stream Independence:
> WebTransport over HTTP/2 does not support stream independence, as HTTP/2 inherently has head-of-line blocking.
>
> Partial Reliability:
> WebTransport over HTTP/2 does not support partial reliability, as HTTP/2 retransmits any lost data. This means that any datagrams sent via WebTransport over HTTP/2 will be retransmitted regardless of the preference of the application. The receiver is permitted to drop them, however, if it is unable to buffer them.
> <https://www.ietf.org/archive/id/draft-ietf-webtrans-http2-06.html#name-transport-properties>

そして、WebTransport over HTTP/3 (<https://www.ietf.org/archive/id/draft-ietf-webtrans-http3-07.html>) では、このような欠損については特に言及されていません。

そもそも、[draft-ietf-webtrans-overview-05 (The WebTransport Protocol Framework)](https://www.ietf.org/archive/id/draft-ietf-webtrans-overview-05.html)にも<https://www.w3.org/TR/webtransport/>にも、WebTransportが"low-latency"を目的として生まれた技術であるとは書かれていません。(正確には、Head-of-line blockingによって生じるlatencyを避ける必要がある、という記述はありますし、またWebSocketはlatency-sensitive applicationsには向いていないという記載もあります[^webtrans-hol])

[^webtrans-hol]: <https://www.ietf.org/archive/id/draft-ietf-webtrans-overview-05.html#name-background>

では真にlow-latency性を求める通信はどのように行うべきかというと、今まで通りに素のUDPやWebRTCを使ったり、RTP over QUIC (RoQ)[^roq]の登場を待つ、ということになるのかなあ……ちょっとわかりません。ただ言えることとしては、[RFC 9002 QUIC Loss Detection and Congestion Control](https://www.rfc-editor.org/rfc/rfc9002.html)において、QUICがその欠損制御を無効化するような仕組みは定義されていないということです。

[^roq]: <https://datatracker.ietf.org/doc/draft-ietf-avtcore-rtp-over-quic/>

なので結論としては、QUICの欠損制御がWebTransportの通信において邪魔になるのかどうかという点については、QUICが複数のStreamによる通信によってHOLBを回避することで高速な通信を行うことができる、ということになると思います。

多分そういうことになるんじゃないかと考えていますが、間違い等あれば訂正したいので気軽に言及してください。
