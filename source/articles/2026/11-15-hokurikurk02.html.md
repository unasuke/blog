---
title: "北陸Ruby会議02で基調講演をさせていただきました"
date: 2026-11-15 19:55 +0900
tags: 
- diary
- ruby
- quic
---

![](2026/hokurikurk02-banner.jpg)

この度は、北陸Ruby会議02の基調講演者としてお招きいただき、ありがとうございました。

<https://regional.rubykaigi.org/hokuriku02/>

オファーをいただいたタイミングで、会場が福井県立恐竜博物館になると聞き、化石発掘を絡めて「dig」という単語を使いたいというのと、プロトコルのossificationについてのネタは入れたいなという2つのアイデアがありました。ただ、その時点でも自分のQUIC実装は不完全な段階であり、digないし関連するDNSのことについては完全に無策な状態でした。

ossificationを題材にするとはいっても、RFC 9000の内容を話すのはそもそも時間も足りませんし、内容も難しすぎます。これに関しては、RFC 8999についてはあまり着目されていないだろうという仮定のもと、そこから誤った仮定やgreasing、ossificationについての話題に繋げられそうだと考えました。(まあdigはDoQに対応してはいませんけど)

ただ、digをどうするか、DNSをどうするかについては少し悩み、一旦考えることを後回しにしていました。そして、protocol-quicの実運用について考えていたとき、これで権威DNSサーバーを実装してDoQに対応させたうえで、そこに対してdigで問い合わせるというアイデアを思い付きました。

そういうわけで、トークの内容をざっくり3部構成とし、まず自己紹介、次にプロトコルのossification、最後に自分のこれまでの取り組みとその現時点での成果という流れでトークを組み立てることにしました。そしてあとは実装するだけ……

さて発表本番では、どうにか実装を間に合わせることができ、かつ当日皆さんにお披露目したデモが成功してひと安心しています。デモでお見せした内容の技術的詳細については、また別のQUIC実装月報にまとめようと思っています。発表資料はこちらです。

<iframe src="https://slide.rabbit-shocker.org/authors/unasuke/hokurikurk02/viewer.html"
        width="640" height="404"
        frameborder="0"
        marginwidth="0"
        marginheight="0"
        scrolling="no"
        style="border: 1px solid #ccc; border-width: 1px 1px 0; box-sizing: content-box; margin-bottom: 5px"
        allowfullscreen> </iframe>
<div style="margin-bottom: 5px">
  <a href="https://slide.rabbit-shocker.org/authors/unasuke/hokurikurk02/" title="Dig It!">北陸Ruby会議02 基調講演 "Dig It!"</a>
</div>


個人的には、QUICの仕様及び実装の複雑な部分に深入りして聴衆を置いてけぼりにすることなく、楽しく、かつ学びになる話ができたかなと思っています。皆さんもそうだったでしょうか？

最後に、北陸Ruby会議02を開催してくださり、自分を基調講演者として招待してくださった運営の皆さま、そして会場にお越しいただいた参加者の皆さま、本当にありがとうございました。

![](2026/hokurikurk02-fpdm.jpg)
