---
title: "RubyKaigi 2025 参加記"
date: 2025-04-25 00:35 JST
tags: 
  - ruby
  - rubykaigi
  - diary
---


![](2025/rubykaigi-2025-lanyard.jpg)


## はじめに、体調のこと
### 何があった
3日目に起きた瞬間から強い頭痛、倦怠感、発熱している感じ(計ってはいない[^oura])があり、その時点で安静にしたほうがいいと判断し、よろよろとコンビニでポカリ、inゼリーを調達したあとはホテルでずっと寝ていました。その朝の時点で他のNOCメンバーが同様に体調不良でダウンしていましたし、昼以降も体調を崩すNOCメンバーが出てきてバタバタと倒れていってやばい……という様相でした。

[^oura]: Oura ringによれば体表温は+3.0℃

発症時点ではとにかく頭痛！頭痛！！頭痛！！！という症状だったので、これは何か風邪、インフルエンザでもうつされたか、嗅覚はあるしコロナの線は薄いのか？なとど色々考えていました。翌日以降からは頭痛に加えてずっとお腹を下しっぱなし状態で、まあしんどかったです。ブログ公開の時点でもまだ全快してないです。おなかがゆるゆる。

### 何故
<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">Day 0 で <a href="https://twitter.com/hashtag/rubykaigiNOC?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigiNOC</a> メンバーでご飯行ったところ当たったのではという説が濃厚で、来年からは全員で同じところに行くのを禁止します</p>&mdash; そらは (@sora\_h) <a href="https://twitter.com/sora_h/status/1913413136255979805?ref_src=twsrc%5Etfw">April 19, 2025</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

多分これなんじゃないかなと思います。Day 0の設営の後、みんなで晩ご飯を食べに入った焼き鳥居酒屋がラストオーダー寸前で、そのタイミングでドカドカ注文した結果として焼きの甘かった鶏肉を食べてしまったんじゃないか、という予想をしています。いや、あったんですよ。「これちゃんと火通ってる？」ってやつが。ただ明かりが暗かったのと、まあいうて焼き鳥屋が客に出してて火が通っとらんことないやろ……という慢心で判断をミスりましたね。実際、そのメニューを食べなかったおしょうゆは最後までピンピンしていました。そういう目線で症状を見ると、カンピロバクター、サルモネラ、そんな感じの症状でまあ妥当なんじゃない？となりますね。来年は全員で同じところに行くのをやめる、リスクを感じたらちゃんと引く、を胸に刻んで臨みます。パイロットか？

では本題に戻ります。

## 登壇したかったニャンね2
いやもう、全部わかります。

(文脈 : [プロポーザルの余白を読み解くRubyKaigi 2025 - connpass](https://smartbank.connpass.com/event/347455/))

わかっているんです。

## トーク

* [Goodbye fat gem 2025 (ktou)](https://rubykaigi.org/2025/presentations/ktou.html)
    * Nokogiriはすごい
    * 実はPythonのwheelがどういうものなのかよくわかっていない
        * というよりはwheelとfat gemの違いとか、メンテナにとってのwheelの面倒さとかが自分の中で区別できていない
            * fat gemと同じではない？
    * see also [RubyKaigi 2025 - Goodbye fat gem 2025 #rubykaigi - 2025-04-21 - ククログ](https://www.clear-code.com/blog/2025/4/21/rubykaigi-2025.html)
* [Running JavaScript within Ruby (hmsk)](https://rubykaigi.org/2025/presentations/hmsk.html)
    * Rubyの例外を try catch で拾ってconsole.errorで表示とか、本当に何が起こっているんだ
* [How to make the Groovebox (asonas)](https://rubykaigi.org/2025/presentations/asonas.html)
    * 縦ノリ。やはり音楽はいいですね。電子楽器のUIがわかりづらいというのは、ある……
* [You Can Save Lives With End-to-end Encryption in Ruby (s01)](https://rubykaigi.org/2025/presentations/s01.html)
    * 言うてる間にMLS ArchitectureがRFCになりましたね
        * <https://www.rfc-editor.org/rfc/rfc9750.html>
    * 応援していますというよりは、共にやっていきましょうというほうが即していそう
        * しかしそう言うには自分の不完全さというものが……
* [Making TCPSocket.new "Happy"! (coe401_)](https://rubykaigi.org/2025/presentations/coe401_.html)
    * 応援していますというよりは(ry
        * しかしそう(ry
    * 私信ですが、余白の会で聞いたことをずっと考え続けています


## 本屋
以下5冊購入させていただきました。

* [伝わるコードレビュー](https://www.shoeisha.co.jp/book/detail/9784798186009)
* [パタン・セオリー](https://patterntheory.jp)
* [入門 OpenTelemetry](https://www.oreilly.co.jp/books/9784814401024/)
* [Googleのソフトウェアエンジニアリング](https://www.oreilly.co.jp/books/9784873119656/)
* [改訂3版 パーフェクトJava](https://gihyo.jp/book/2025/978-4-297-14680-1)

特に「入門 OpenTelemetry」と「パーフェクトJava」は自分の今の業務でまさに必要な本だったので、ここで買えてよかったです。


## #RubyKaigiNOC
<blockquote class="twitter-tweet"><p lang="ja" dir="ltr"><a href="https://twitter.com/hashtag/rubykaigi?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigi</a> <a href="https://twitter.com/hashtag/rubykaigiNOC?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigiNOC</a> <br>クソクイズ2025の午前問題出てます。 <a href="https://t.co/Eg1FpLchz0">pic.twitter.com/Eg1FpLchz0</a></p>&mdash; てるふの (@terfno\_mai) <a href="https://twitter.com/terfno_mai/status/1913055230067195962?ref_src=twsrc%5Etfw">April 18, 2025</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

そもそも8の字巻きコンテストや、NOCクソクイズをやっているのはなぜか？という話をします。NOCチームの存在や、NOCチームの仕事については知られているのでしょうか。その認知(NOCチームというものがあり、ネットワーク関連のなにかをやっている、程度)を得るためにやっています。あとは楽しいから。

8の字巻きコンテストについては「8の字巻き」という技能を要求されるので参加のハードルはあるかもしれませんが、NOCクソクイズはもっと気軽に参加してほしいですね。我々が頭をひねって「そんなん考えてもわかるわけないだろ」な問題をお出ししているので、頭空っぽにしてぼんやり思いついた答えを書いてもらうとか、大喜利のつもりで臨むくらいでちょうどいいです。参加賞も景品もありませんし。

例えばこの画像のQ3「この付箋(み)の意味は？」『まいた』『み』『ま』なんですが、答えは……

* 『まいた』: 8の字巻きしてある
* 『ま』: 上記「まいた」の略
* 『み』: 「ま」と書こうとして間違えた ← (これを答える)

です。わかるか！！ちなみにQ4が結構すきです。どこか(多分Discord)で他の問題の回答も発表されるでしょう。

## レジャー
例のごとくRubyKaigi後もしばらく滞在し、近辺を観光しました。もちろん病み上がりっていうか完治してないままに歩き回っていました。おしょうゆ、運転ありがとう……

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">しまなみ街道・尾道・佐田岬灯台・宇和島・四万十川・四国カルストを高速履修しました</p>&mdash; osyoyu (@osyoyu) <a href="https://twitter.com/osyoyu/status/1914244011566719244?ref_src=twsrc%5Etfw">April 21, 2025</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-conversation="none"><p lang="ja" dir="ltr">今治が抜けてた！</p>&mdash; osyoyu (@osyoyu) <a href="https://twitter.com/osyoyu/status/1914244718193754197?ref_src=twsrc%5Etfw">April 21, 2025</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="mastodon-embed" data-embed-url="https://mstdn.unasuke.com/@unasuke/114363609983593458/embed" style="background: #FCF8FF; border-radius: 8px; border: 1px solid #C9C4DA; margin: 0; max-width: 540px; min-width: 270px; overflow: hidden; padding: 0;"> <a href="https://mstdn.unasuke.com/@unasuke/114363609983593458" target="_blank" style="align-items: center; color: #1C1A25; display: flex; flex-direction: column; font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Oxygen, Ubuntu, Cantarell, 'Fira Sans', 'Droid Sans', 'Helvetica Neue', Roboto, sans-serif; font-size: 14px; justify-content: center; letter-spacing: 0.25px; line-height: 20px; padding: 24px; text-decoration: none;"> <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="32" height="32" viewBox="0 0 79 75"><path d="M74.7135 16.6043C73.6199 8.54587 66.5351 2.19527 58.1366 0.964691C56.7196 0.756754 51.351 0 38.9148 0H38.822C26.3824 0 23.7135 0.756754 22.2966 0.964691C14.1319 2.16118 6.67571 7.86752 4.86669 16.0214C3.99657 20.0369 3.90371 24.4888 4.06535 28.5726C4.29578 34.4289 4.34049 40.275 4.877 46.1075C5.24791 49.9817 5.89495 53.8251 6.81328 57.6088C8.53288 64.5968 15.4938 70.4122 22.3138 72.7848C29.6155 75.259 37.468 75.6697 44.9919 73.971C45.8196 73.7801 46.6381 73.5586 47.4475 73.3063C49.2737 72.7302 51.4164 72.086 52.9915 70.9542C53.0131 70.9384 53.0308 70.9178 53.0433 70.8942C53.0558 70.8706 53.0628 70.8445 53.0637 70.8179V65.1661C53.0634 65.1412 53.0574 65.1167 53.0462 65.0944C53.035 65.0721 53.0189 65.0525 52.9992 65.0371C52.9794 65.0218 52.9564 65.011 52.9318 65.0056C52.9073 65.0002 52.8819 65.0003 52.8574 65.0059C48.0369 66.1472 43.0971 66.7193 38.141 66.7103C29.6118 66.7103 27.3178 62.6981 26.6609 61.0278C26.1329 59.5842 25.7976 58.0784 25.6636 56.5486C25.6622 56.5229 25.667 56.4973 25.6775 56.4738C25.688 56.4502 25.7039 56.4295 25.724 56.4132C25.7441 56.397 25.7678 56.3856 25.7931 56.3801C25.8185 56.3746 25.8448 56.3751 25.8699 56.3816C30.6101 57.5151 35.4693 58.0873 40.3455 58.086C41.5183 58.086 42.6876 58.086 43.8604 58.0553C48.7647 57.919 53.9339 57.6701 58.7591 56.7361C58.8794 56.7123 58.9998 56.6918 59.103 56.6611C66.7139 55.2124 73.9569 50.665 74.6929 39.1501C74.7204 38.6967 74.7892 34.4016 74.7892 33.9312C74.7926 32.3325 75.3085 22.5901 74.7135 16.6043ZM62.9996 45.3371H54.9966V25.9069C54.9966 21.8163 53.277 19.7302 49.7793 19.7302C45.9343 19.7302 44.0083 22.1981 44.0083 27.0727V37.7082H36.0534V27.0727C36.0534 22.1981 34.124 19.7302 30.279 19.7302C26.8019 19.7302 25.0651 21.8163 25.0617 25.9069V45.3371H17.0656V25.3172C17.0656 21.2266 18.1191 17.9769 20.2262 15.568C22.3998 13.1648 25.2509 11.9308 28.7898 11.9308C32.8859 11.9308 35.9812 13.492 38.0447 16.6111L40.036 19.9245L42.0308 16.6111C44.0943 13.492 47.1896 11.9308 51.2788 11.9308C54.8143 11.9308 57.6654 13.1648 59.8459 15.568C61.9529 17.9746 63.0065 21.2243 63.0065 25.3172L62.9996 45.3371Z" fill="currentColor"/></svg> <div style="color: #787588; margin-top: 16px;">Post by @unasuke@mstdn.unasuke.com</div> <div style="font-weight: 500;">View on Mastodon</div> </a> </blockquote> <script data-allowed-prefixes="https://mstdn.unasuke.com/" async src="https://mstdn.unasuke.com/embed.js"></script>

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">中村見てる <a href="https://t.co/9ijJoZYr6R">pic.twitter.com/9ijJoZYr6R</a></p>&mdash; osyoyu (@osyoyu) <a href="https://twitter.com/osyoyu/status/1914123942174007299?ref_src=twsrc%5Etfw">April 21, 2025</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

![しまなみ海道の橋のどれか](2025/rubykaigi-2025-shimanami.jpg)

![かつて日本一海に近い駅とされていた下灘駅](2025/rubykaigi-2025-shimonada-station.jpg)

![佐田岬灯台の途中で行ける海辺。超・磯の香り](2025/rubykaigi-2025-sadamisaki.jpg)

![四万十川の沈下橋。落ちそうで若干の怖さ。](2025/rubykaigi-2025-shimanto-chinkabashi.jpg)

