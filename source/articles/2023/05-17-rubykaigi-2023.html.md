---
title: "RubyKaigi 2023 participation report"
date: 2023-05-17 02:00 JST
tags: 
  - ruby
  - quic
  - programming
  - rubykaigi
---

![](2023/rubykaigi-2023-slide.png)

<https://slide.rabbit-shocker.org/authors/unasuke/rubykaigi-2023/>

## As the Ruby Association Grant 2022 final report
As I wrote in [last year's participation (JA)](/2022/rubykaigi-2022), I applied for the Ruby Association Grant 2022. As a result, it was accepted and I was able to complete the port of aioquic to some extent.

I think this presentation was a little early final report. I am a little concerned about whether or not I will apply for the Grant again this year, but I will think about it again when the time comes. This is because, after all, time constraints are unmanageable. It is true that it makes a deadline, and I can certainly make progress with the help of my mentor, but I have no choice but to devote my personal time to writing the code. I felt that if I cannot generate the time to do this as a job, I will not be able to continue. However, I wondered if any company would invest in the QUIC implementation of Pure Ruby, which is not suitable for production use. I have not been able to approach companies because I am worried about this, or rather, I have not been able to come up with an answer to this question.

## As a member of #RubyKaigiNOC  

![unasuke dropped fiber](2023/rubykaigi-2023-fiber.jpg)

_"unasuke dropped"_

I have been helping with the RubyKaigi network for the past few years. This year again, as a member of `#RubyKaigiNOC`, I mainly helped with L1.  

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr"><a href="https://twitter.com/hashtag/rubykaigi?src=hash&amp;ref\_src=twsrc%5Etfw">#rubykaigi</a> <a href="https://twitter.com/hashtag/rubykaigiNOC?src=hash&amp;ref\_src=twsrc%5Etfw">#rubykaigiNOC</a> 台数チェックをするうなすけの様子です <a href="https://t.co/WqZpi1bEoV">pic.twitter.com/WqZpi1bEoV</a></p>&mdash; そらは (@sora\_h) <a href="https://twitter.com/sora_h/status/1657914633846673408?ref\_src=twsrc%5Etfw">May 15, 2023</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Sorah, who is the organizer of the RubyKaigi and NOC boss, is a very busy person. Therefore, this year I decided to take some of her tasks away from her. But as a result, other NOC members including her, helped me. However, thanks to that, I was able to gain knowledge about fluentd. I had never written a fluentd configuration before. The book ["fluentd実践入門"](https://gihyo.jp/book/2022/978-4-297-13109-8) written by tagomoris was very helpful in doing this task, and I got him to sign the book for me on #authorsrb.  

[It's time to collect stamps at the venue of #rubykaigi2023 ! - Rubyist Book Authors Stamp Rally #authorsrb｜やきとりい](https://note.com/yotii23/n/n031bfdc95859)
  
I'm very pleased to provide the Internet to all RubyKaigi attendees. I hope to provide the same experience in Kaigi on Rails which is the conference about Ruby on Rails in Japan as one of an organizer of that either. But it's a very hard thing in this year I thought.
  
## As a DJ of RubyMusicMixin2023
  
Continuing from last year, I had the opportunity to DJ at a RubyMusicMixin2023 organized by pixiv. After a great Kaigi, it is a great time to dance to the music also.

* <https://conference.pixiv.co.jp/2023/rubymusicmixin>
* [#RubyMusicMixin2023 ツイートまとめ - Togetter](https://togetter.com/li/2147580)

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr"><a href="https://twitter.com/hashtag/RubyMusicMixin?src=hash&amp;ref\_src=twsrc%5Etfw">#RubyMusicMixin</a> <a href="https://twitter.com/hashtag/RubyMusicMixin2023?src=hash&amp;ref\_src=twsrc%5Etfw">#RubyMusicMixin2023</a><br><br>NICEDJでオタクの語彙が「懐かしい」と「ヤバイ」になり、NICE VJで人は踊る <a href="https://t.co/AOxrgr2T7C">pic.twitter.com/AOxrgr2T7C</a></p>&mdash; 炬燵は首輪を買い足した (@sakahukamaki) <a href="https://twitter.com/sakahukamaki/status/1657776726301368320?ref\_src=twsrc%5Etfw">May 14, 2023</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## Challenges

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">2、そして3。<a href="https://t.co/0XDpjsJgQi">https://t.co/0XDpjsJgQi</a> <a href="https://t.co/EIz0X4Zsa5">pic.twitter.com/EIz0X4Zsa5</a></p>&mdash; うなすけ (@yu\_suke1994) <a href="https://twitter.com/yu_suke1994/status/1632417580026830849?ref\_src=twsrc%5Etfw">March 5, 2023</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

_1. Write Codes, 2. Receiving and sending in English (as a lingua franca), 3. Show Your Presence at International Conferences -- by kakutani_

The most difficult part of this year's RubyKaigi was speaking in English. I think I did a little bit about "1. Write Codes" in "Developing the Ruby Ecosystem," as Kakutani-san mentioned. On the other hand, I did nothing about 2 and 3.

However, DeepL and ChatGPT have recently allowed us to empower English language skills. I may still be powerless in face-to-face conversations, but in one-way speaking situations where I have to prepare a script in advance or writing, they help me a lot. (Also, I wrote this blog in English and Japanese too!) In fact, for my presentation, I first wrote a script in Japanese, had it translated into English by DeepL, and then adjusted the English text to suit my English skill. (I spoke a little Japanese. I apologize.)

## About the future
As I mentioned in my talk, I'm trying to create my own QUIC implementation based on my porting knowledge. In doing so, I'm reading [RFC 8446](https://datatracker.ietf.org/doc/rfc8446/) and [draft-ietf-tls-rfc8446bis](https://datatracker.ietf.org/doc/draft-ietf-tls-rfc8446bis/), although this is a bit of a detour. Because, during the porting process, I was trying to rewrite the existing Python implementation in Ruby in its original form, and not much thought was given to the TLS 1.3 specification itself.

See you at the next RubyKaigi, Okinawa.

## Ruby Association Grant 2022 の最終成果報告として

[昨年の参加記](/2022/rubykaigi-2022)で書いたように、Rubyアソシエーション開発助成金 2022に応募しました。結果として採択していただき、aioquicの移植をある程度まで完成させることができました。

[Rubyアソシエーション開発助成2022を終えて](/2023/personal-impressions-of-the-ra-grant-2022/)

今回の発表は、結果として少し早めの最終成果報告という形になったんじゃないかと思います。今年度も応募するかどうかは少し悩んでいますが、時期が来たらまた考えようかと思っています。

## #RubyKaigiNOC のメンバーとして
ここ数年は #RubyKaigiNOC の一員としてネットワークの手伝いをしています。今年も、主にL1(ケーブル、APの敷設、撤収)の手伝いをしました。

RubyKaigiのオーガナイザーでもあり、NOCのボスでもあるsorahが大量のタスクを抱えているので、今年はsorahのタスクを奪うことを密かな目標にしていました。結果としてsorahやhanazukiさんにおんぶにだっこでしたが…… ただ、奪ったタスクにより、fluentdについての知見を得ることができました。そして、奪ったタスクはfluentdに関するもので、とはいえこれまでfluentdの設定を書いたことがなかったのですが、tagomorisさんの[「fluentd実践入門」](https://gihyo.jp/book/2022/978-4-297-13109-8) がすごく助けになりました。#authorsrb のおかげで、tagomorisさんから直接本を書い、サインを頂くことができました。同じ本を何度も買おう！

[最近本を出したRubyistに話しかけようスタンプラリー #rubykaigi2023 会場 をやります #authorsrb｜やきとりい](https://note.com/yotii23/n/n031bfdc95859)

RubyKaigi参加者の皆さんにインターネットを提供することは嬉しいことです。同じ体験をKaigi on Rails 2023でも提供できると嬉しいのですが、今年はどうなるでしょうね……

## As a DJ of RubyMusicMixin2023
昨年に引き続き、今年もpixivさんの主催するアフターパーティーであるRubyMusicMixin2023でDJをさせていただきました。Kaigiの後に良い音楽を浴びるの、最高の体験ですね……！

* <https://conference.pixiv.co.jp/2023/rubymusicmixin>
* [#RubyMusicMixin2023 ツイートまとめ - Togetter](https://togetter.com/li/2147580)

最後に告知をしましたが、[高専DJ部](https://kosendj-bu.in)というイベントを早稲田にある「茶箱」で定期的に開催しています。次回は7月の後半になる予定です。RubyMusicMixin2023のような、オールジャンルなクラブイベントとなっています。是非来てください。

<https://kosendj-bu.in>

## 挑戦
今回のRubyKaigiにおいての一番の挑戦は、英語で発表するということでした。角谷さんがおっしゃっていた「Rubyエコシステムの発展」にある事項(上記)のうち、1はそれなりにできていたんじゃないかと思っています。反面、2と3については僕は特に何もできていませんでした。

しかし、最近はDeepLやChatGPTなどによって英語力に下駄を履かせることができるようになりました。対面での会話に対してはまだ無力かもしれませんが、事前に原稿を練って一方的に話す場面や、文章を書く場面においては非常に力になってくれます(現にこの参加記も)。実際、僕の今回の発表は、まず日本語の台本を書き、それを一旦DeepLによって英語にしてもらったあと、その英文を自分の英語力に合わせて調整するという形式で作成しました。

## 今後

今回の発表でも話しましたが、移植の知見を基にした独自のQUIC実装を作ろうとしています。それにあたり、少し遠回りではありますが、[RFC 8446](https://datatracker.ietf.org/doc/rfc8446/)並びに[draft-ietf-tls-rfc8446bis](https://datatracker.ietf.org/doc/draft-ietf-tls-rfc8446bis/)を読んでいます。移植中は、既にある実装をそのままの形式でRubyに書き換えるという作業をしており、TLS 1.3そのものの仕様についてはあまり考えられていなかったためです。

それでは次のRubyKaigi、沖縄で……の前に、Kaigi on Railsで会いましょう。

![](2023/rubykaigi-2023-namecard.jpg)
