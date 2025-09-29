---
title: "Kaigi on Rails 2025 - an organizer’s report"
date: 2025-09-29 20:14 JST
tags: 
- kaigionrails
- ruby
- rails
- diary
---

![](2025/kaigionrails-2025-lanyards.jpg)


## Acknowledgments
We would like to express our sincere gratitude to everyone who participated in Kaigi on Rails 2025. The event's success was made possible by the contributions of all speakers, proposal submitters, sponsoring companies, and attendees. This year's event followed our hybrid format also. While this marks our third year and third iteration, we recognize there's still room for improvement in our operational processes. We encourage anyone who has feedback or suggestions—whether about operations or how things could be improved—to fill out the survey.

[Kaigi on Rails 2025 Survey - Google Forms](https://docs.google.com/forms/d/e/1FAIpQLSd316ACVrwmnzk8j9WaUQEICUwPvDTg9zYRT7Uvt4LAW7A8lw/viewform)

Below is a brief retrospective.

## i18n Support
This year, Kaigi on Rails took its first steps toward becoming an international conference. To accommodate this transition, we ensured all announcements were presented in both English and Japanese. We have also begun accepting visa application support for participants.

## Live Interpretation
One crucial element we could not compromise on in our internationalization efforts was simultaneous interpretation. Whether from English to Japanese or Japanese to English, providing this service was absolutely essential.
For this year, we provided simultaneous interpretation from English to Japanese. While two-way interpretation would be ideal with sufficient resources, it was not feasible in this case.

## Live Streaming
For English-to-Japanese interpretation, we enlisted professional simultaneous interpreters. But what about Japanese-to-English interpretation? Failing to make conference content—which forms the core experience—accessible to non-Japanese speakers from overseas would be unacceptable.

This time, we used Amazon Transcribe for real-time transcription in both Japanese and English, and Amazon Bedrock's Claude 3.5 Sonnet for Japanese-to-English translation. We implemented this system based on models used at RubyKaigi. Implementation was greatly influenced by the systems at RubyKaigi and 東京Ruby会議12. Thanks to sorah, terfno, and osyoyu.

* <https://github.com/ruby-no-kai/takeout-app>
* <https://github.com/tokyorubykaigi12/captioner>

Now, Kaigi on Rails 2025 introduced a unique feature. This decision was made when we first considered inviting Samuel as our keynote speaker. For delivering subtitle data, we utilized Falcon. As a result of this implementation, we developed a separate repository independent of our conference-app. The name "Shirataki" combines meanings from both "translation" → "ほんやくコンニャク"[^gummy] and "streaming subtitle data like a waterfall," reflecting these dual concepts.

[^gummy]: In the US version, it's called “Translation Gummy,” one of Doraemon's secret gadgets.

* <https://github.com/kaigionrails/shirataki>

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">The <a href="https://twitter.com/hashtag/kaigionrails?src=hash&amp;ref_src=twsrc%5Etfw">#kaigionrails</a> live translation system is running on Falcon &amp; Async: <a href="https://t.co/qoSomsSXOf">https://t.co/qoSomsSXOf</a></p>&mdash; Samuel Williams (@ioquatix) <a href="https://twitter.com/ioquatix/status/1971742549984620710?ref_src=twsrc%5Etfw">September 27, 2025</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

We implemented this feature in a rush, making full use of Claude Code. There are still many areas we'd like to improve.

## 2026
I'll do my best!


## 感謝
Kaigi on Rails 2025に参加していただいたみなさま、ありがとうございました。登壇者の皆様、Proposalを出してくださった皆様、協賛してくださった企業の皆様、そして一般参加者の皆様のご協力のおかげでKaigi on Rails 2025を無事に終えることができました。今年もハイブリッド開催となりました。3年目そして3回目ではありますが、運営の面でまだまだ改善の余地があるなと思っています。運営に伝えたいこと、もっとこうすればいいんじゃないかということがあれば、是非アンケートへの回答をお願いします。

[Kaigi on Rails 2025アンケート - Google Forms](https://docs.google.com/forms/d/e/1FAIpQLSdSLC17mhaDnltfM6txyavvGvkKRJGBJgZe2mJsc1k6M7-ASw/viewform)

以下、簡単なふりかえりです。

## i18n
とうとうKaigi on Railsも国際カンファレンスへの第一歩を踏み出すことができました。今年は移行期ということで各種アナウンスをなるべく英日併記するようにしました。参加者へのVisa取得支援も受け付けるようにしました。

## Live interpretation
国際化にあたって外したくなかった要素が同時通訳です。その方向はどうあれ、用意しなければならないことは確実でした。

今回は英語から日本語への同時通訳を用意しました。リソースが潤沢であれば双方向用意できるのが理想的ではあるのですが、そうもいきませんね。

## Live streaming
英語から日本語へは同時通訳者さんにお願いしました。では日本語から英語はどうでしょうか。海外からの非日本語話者に対してカンファンレンスのメインコンテンツとも言える発表内容が伝わらないというのは避けるべき事態です。

今回は、日本語と英語の書き起こしをAmazon Transcribeに、日本語から英語への翻訳にAmazon Bedrock (Claude 3.5 Sonnet)を用いました。例年RubyKaigiで行われているものを参考に実装しました。実装にあたってはRubyKaigiのものと、東京Ruby会議12のものを大いに参考にさせてもらっています。sorah、terfno、osyoyu、ありがとう。

* <https://github.com/ruby-no-kai/takeout-app>
* <https://github.com/tokyorubykaigi12/captioner>

さて、Kaigi on Rails 2025の独自要素があります。これは基調講演にSamuelを呼ぼうと考えたときから決めていたことですが、字幕データの配信に関してはFalconを活用しています。その都合上、conference-appとは切り離した別repositoryに実装を置いています。名前の由来は、翻訳 → 翻訳コンニャク、字幕データを滝のように流したいの両方の意味を汲んで"白滝"です。

* <https://github.com/kaigionrails/shirataki>

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">The <a href="https://twitter.com/hashtag/kaigionrails?src=hash&amp;ref_src=twsrc%5Etfw">#kaigionrails</a> live translation system is running on Falcon &amp; Async: <a href="https://t.co/qoSomsSXOf">https://t.co/qoSomsSXOf</a></p>&mdash; Samuel Williams (@ioquatix) <a href="https://twitter.com/ioquatix/status/1971742549984620710?ref_src=twsrc%5Etfw">September 27, 2025</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

急拵えでClaude Codeをフル活用して実装しました。まだまだ改善したいところがあります。

## 2026
がんばろ～～
