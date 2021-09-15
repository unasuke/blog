---
title: RubyKaigi Takeout 2021 で発表しました
date: 2021-09-16 01:17 JST
tags:
  - ruby
  - quic
  - programming
  - rubykaigi
---

![スライド表紙](2021/rubykaigi-takeout-2021-slide.png)

RubyKaigi Takeout 2021 の 3 日目に、「Ruby, Ractor, QUIC」 という題で個人的に取り組んでいることについて話しました。

<iframe src="https://slide.rabbit-shocker.org/authors/unasuke/rubykaigi-takeout-2021/viewer.html"
        width="320" height="220"
        frameborder="0"
        marginwidth="0"
        marginheight="0"
        scrolling="no"
        style="border: 1px solid #ccc; border-width: 1px 1px 0; margin-bottom: 5px"
        allowfullscreen> </iframe>
<div style="margin-bottom: 5px">
  <a href="https://slide.rabbit-shocker.org/authors/unasuke/rubykaigi-takeout-2021/" title="Ruby, Ractor, QUIC">Ruby, Ractor, QUIC (スライドへのリンク)</a>
</div>

<br>

<iframe width="560" height="315" src="https://www.youtube.com/embed/9da7QccHXV4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

発表内容については、事前に台本を作成し 25 分間という枠に収まることを確認してからスライドを作成するという流れで組み立てました。それもあってとても聞きやすかったというお声を頂き、苦労が報われた感じがありました。ありがとうございます。

## きっかけ

開発のきっかけを、発表内では「QUIC の勉強をしている時に ko1 さんの Tweet を見かけた」と言いましたが、実はもう少しバックストーリーがあります[^story]。

[^story]: 「表向きの理由」とも言える

発表に出していない部分の経緯として、そもそもは Black 社内で Web 技術について話していたのがきっかけとなります。2021 年初頭くらいから一部メンバーの間で WebRTC を自前実装する流れ [^curious] が社内にあり、だったら自分も何かしてみたい、そういえば WebTransport というものがあるけど、土台となる技術について何も知らないな、じゃあ QUIC について調べてみるか、という流れで、 QPACK や QUIC の draft を読んだり、curl の HTTP/3 対応版を build したり、Initial packet を手で parse したりしはじめた、というのが始まりです[^story2]。

[^story2]: このあたり時系列がふわふわしている
[^curious]: がんばって [WebRTC for The Curious](https://webrtcforthecurious.com) を訳していたら voluntas さんに先を越されたという裏話もある

これは 3 月

<img width="802" alt="image.png (27.1 kB)" src="https://img.esa.io/uploads/production/attachments/11214/2021/09/06/3132/cd30b375-a9c4-46db-bc43-da8db6b594d5.png">

これは 4 月

<img width="727" alt="image.png (39.5 kB)" src="https://img.esa.io/uploads/production/attachments/11214/2021/09/06/3132/2a03648c-4964-4f44-9e64-d2700b37d50d.png">

これは 5 月

<img width="748" alt="image.png (450.9 kB)" src="https://img.esa.io/uploads/production/attachments/11214/2021/09/06/3132/9f10931f-a7f8-411b-9143-a51f1c43d46b.png">

そうこうしている過程で QUIC のことを調べているうちに、奥さんと笹田さんの tweet を見、Ractor でやってみるのはよさそうだ、ということも考えるようになりました。

その後、身内で「Ruby で QUIC をやっている」ということを言ったところ応援されたのもあり、しばらくの間、正しく Initial packet を parse することもできないままにちまちまと開発を進めていましたが、角谷さんの tweet に触発され、エイヤで RubyKaigi に Proposal を出したところ accept されたので焦りはじめた、という経緯がありました。

採択されて以降、特に timetable が公開されるまでの間にはなんとか成果を出そうとがんばって書いたのが以下の 2 つの記事になります。

- [QUIC の Initial packet を Ruby で受けとる](/2021/read-quic-initial-packet-by-ruby/)
- [続・QUIC の Initial packet を Ruby で受けとる (curl 編) ](/2021/read-quic-initial-packet-by-ruby-2/)

## Proposal 原文

### Details

> Ractor, introduced in Ruby 3, has made it possible to easily write parallel processing in Ruby. However, at this point, there are still no examples of its use on a certain scale, and it is difficult to estimate whether it is practical or not, and whether there are bottlenecks or not.
>
> QUIC, which will be standardized in May 2021, is a protocol for communication-based on UDP, as opposed to the TCP communication used in HTTP to date. It is generally implemented in userspace, which makes development easier.
>
> For my technical interest, I am trying to implement the QUIC protocol on Ruby 3 by using Ractor. By doing so, I believe I can contribute to the performance evaluation and improvement of Ractor itself by creating a program that uses Ractor of a certain size.

### Pitch

> I am involved in the development of a cloud gaming service called OOParts. This service uses WebRTC to send video from the server to the user's web browser.
> As a successor to WebRTC, a protocol called WebTransport has been proposed by W3C and IETF. This is a technology that is attracting a lot of attention in the field of cloud gaming.
> WebTransport is being developed with the primary goal of being built on top of HTTP/3, and HTTP/3 will be implemented based on QUIC.
> I have been trying to implement the QUIC protocol stack in Ruby for learning purposes, and have partially succeeded in parse the initial packet at this stage.
> https://gist.github.com/unasuke/322d505566de087f58a6b47902812630
>
> The reason I started this effort in the first place was because I saw these messages between Kazuho Oku san, who is working on the QUIC specification, and Sasada-san, who is developing Ractor
> https://twitter.com/_ko1/status/1282963500583628800
>
> Since then, I have started learning QUIC, and have written several pull requests and blog posts in the process.
>
> - https://github.com/bagder/http3-explained/pull/195
> - https://github.com/curl/curl/commit/c1311dba6ec9c65508c907b8509f0dbc5751e8c0
> - https://github.com/ruby/openssl/pull/447
> - https://blog.unasuke.com/2021/curl-http3-daily-build/
>
> At this point, I haven't gotten to the point of using Ractor to communicate, but I can talk about some of the challenges of implementing QUIC in Ruby.

この proposal 、及び当日の発表原稿はあらや君に review してもらいました。毎度直前のお願いになってしまって申し訳ないです。次回以降の HTTP/Tokyo には是非参加させていただきます。

## 副産物 : udpbench

既存のツールはなかったのだろうか、という tweet がありました。UDP を使ってベンチマークを行うツールとして、iperf3 というものがあります。しかしこれがベンチマークの対象としているのは帯域であり、iperf3 間での通信がどのくらいの速度で行えるのかを計測するツールで、今やりたい「サーバーがどのくらいの UDP パケットを処理できるのか」という目的にはマッチしないものでした。

また、そもそも UDP が送りつけっぱなしプロトコルということもあり、「送ったら、返ってくる」という性質のものでもないために、 TCP のようにちゃんと想定した response を返してくれるのか、ということを検証できる既存のものが見当りませんでした[^another-udpbench]。

[^another-udpbench]: 今調べたら <https://github.com/bluhm/udpbench> というものがありました、今見つけました。

udpbench は本当に突貫工事で、例えば packet が返ってこなかった場合は無限に待ち続けてしまうなど、いわゆるタイムアウト機構がありません。テストもありません。Pull request お待ちしております……使う人いるの？

## 感想

「こういうものができました、見てください」ではなく、「こういうことをやろうとしています、今の課題はこうです」という内容の発表だったので、出来上がっているものがほぼ無い状態で発表するというものすごいプレッシャーがありました。Proposal が通った以上、それが求められていると運営側が判断したから話す価値はあるはずなのですが、他の登壇している方々が成果を持ってやってくる様子を見ていると、やはり無力感があります。

そして RubyKaigi が終わった今はまた一変して「こういうことをやっています」というのを全世界の Rubyist に対して宣言したという状況になります。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">人は宣言すると実行する</p>&mdash; うなすけ (@yu\_suke1994) <a href="https://twitter.com/yu_suke1994/status/623802918110519296?ref_src=twsrc%5Etfw">July 22, 2015</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

資料作成のために手を動かしている間は、自分に対してずっと「あとはやるだけ」「でも、やるんだよ」と言い聞かせていました。これからも、やるだけです。

## Rabbit のこと

少し前に書いた [スライド置き場のポリシー](/2021/compare-slide-share-services) にも書きましたが、しばらく Rabbit からは離れていました。しかし RubyKaigi に登壇となったら Rabbit 使うしかないだろう！という気持ちになって久々に使いました。スライドのテーマについて参考にさせていただき、また ruby-jp slack でトラブルシューティングに付き合っていただいた [@hasumikin](https://twitter.com/hasumikin) さんにはとても感謝しています。

Rabbit については思うところがあり、やはり凝ったことをし出すと大変になってしまうあたり、HTML と CSS でスライドを作るようにしたほうが自分のスタイルに合っているんじゃないかということです。これまでは Markdown、今回は RD で書きましたが、これらは文書構造の定義には向いていても外観の装飾には向いていないのでどうしてもがんばってやりくりしないといけなくなります。図は結局 Illustrator でがんばりましたし。

あと、素材に関しては keynote.app の template しかなかったのも手間取りました。RubyKaigi team に Rabbit の theme を書いてくれとは言いませんが、 Mediakit みたく素材を配布してもらえるとありがたかった[^mediakit]です。Web ページの情報から取得できるだろうというのはそれはそうですが……

それはそれとして、もっと Rabbit ユーザーが増えてくれると嬉しいですね。

[^mediakit]: じゃあ Kaigi on Rails team では提供してんのかいな！と言われるとそこまで手が回っていないのでスミマセン、という……

## 発表後から Fukuoka.rb までのこと

まず宿題とした `OpenSSL::Cipher` の Ractor 対応を行いました。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">OpenSSL::Cipher をRactor内で使えるように試してみたら、これで一旦 new はできたけどテストが何もありません。 (Make OpenSSL::Cipher ractor-safe, but is it right...?)<br><br>Make OpenSSL::Cipher Ractor-safe <a href="https://t.co/GfpfgEWWMo">https://t.co/GfpfgEWWMo</a> <a href="https://twitter.com/hashtag/rubykaigi?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigi</a></p>&mdash; うなすけ (@yu\_suke1994) <a href="https://twitter.com/yu_suke1994/status/1436584837922492423?ref_src=twsrc%5Etfw">September 11, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

加えて、既に Ractor-safe とされていた `OpenSSL::BN` について、Ractor を使用したテストケースを追加して pull request を作成しました。不完全なのでまだまだ修正が必要ですが。

発表では「できる」と言ったこと、例えば packet をパースする部分について、実際は実装できていなかったので実装を行いました。

<https://github.com/unasuke/raiha/compare/b0eadd3...0886149>

パーサーは、今は Initial Packet が来る前提のコードになっているのをまずは修正しないと、と考えています。

他には細かいですが、Rabbit でドキュメントの誤りについて、MFA を有効にしているとスライドの公開ができないことについての pull request を作成しました。

- [Fix slide publish document (use rake) by unasuke · Pull Request #140 · rabbit-shocker/rabbit](https://github.com/rabbit-shocker/rabbit/pull/140)
- [Just exec "gem push" in `rake publish:rubygems` by unasuke · Pull Request #141 · rabbit-shocker/rabbit](https://github.com/rabbit-shocker/rabbit/pull/141)
  - これは解決策が間違っていたので merge はされませんでしたが問題自体は解決しました

## 謝辞

まずは一緒に Initial Packet を目と手でパースするのを手伝ってくれた Black のメンバーに、次にこの活動について背中を押してくれ、またわからないところを親切に教えてくれ、さらにレビューもしてくれたあらやくんをはじめとする kosen10s のみんなに改めて感謝します。

次にオンラインでのイベント体験として素晴しいシステムを用意してくれ、Proposal の後押しならびに採択による開発のブーストとなってくれた RubyKaigi team の皆さん、ありがとうございました。

## これから

「開発しています」とは言ったものの、しばらくガッツリ手を動かすことはないと思います。理由としては、高専 DJ 部、Kaigi on Rails 、その後に (Proposal が通った場合は) Cloud Native Days Tokyo 2021 が控えているためです。隙間時間を見つけてちまちま手を動かしていくつもりです。

また、 Ractor 自体に手を入れていくということになると C 言語などの知識が必要になる[^c]と思っていて、 C 言語は学生時代に書いたきり、かつ高度なことはやらなかったので改めて C 言語の学習をしようとも思っています。具体的には次の本を買って読もうと思いますが、他におすすめの本があれば教えてください。

- [O'Reilly Japan - C 実践プログラミング 第 3 版](https://www.oreilly.co.jp/books/4900900648/)
- [O'Reilly Japan - 並行プログラミング入門](https://www.oreilly.co.jp/books/9784873119595/)
- [図解即戦力 暗号と認証のしくみと理論がこれ 1 冊でしっかりわかる教科書：書籍案内｜技術評論社](https://gihyo.jp/book/2021/978-4-297-12307-9)

[^c]: Fukuoka.rb でうづらさんにアドバイスいただいた、String に C 拡張で each_bit のようなメソッドを生やすというのを手始めにやってみたい

また実装、資料作成中に思ったこととして、るりまに Ractor と OpenSSL についてのドキュメントが不足しているというものがあり、それもなんとか手を動かしていきたいです。
