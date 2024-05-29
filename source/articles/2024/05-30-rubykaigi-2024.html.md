---
title: "RubyKaigi 2024 参加記"
date: 2024-05-30 00:00 JST
tags:
  - ruby
  - programming
  - rubykaigi
---

![](2024/rubykaigi-2024-okinawa-beach.jpg)

## はじめに
昨年は英語で書いたんですが、今年は発表できなかったので日本語で書きます。

## 登壇したかったニャンね
いや〜〜〜〜〜〜〜〜〜〜〜〜……はい。

特にしおいさん、いまいずみさんと僕はRubyKaigi Takeout 2021での初登壇以来、RubyKaigi 2023まで連続してacceptされていたので、勝手に同期みたいな仲間意識を感じていたのですが、今年は僕がnot acceptedとなり、ぐぅぅぅ……という感じです[^kuyashi]。まあnot acceptedとなることに対しての納得はあるので、精進が必要、といったところですね。

[^kuyashi]: この気持ちはおふたりにぶつけ済

## トーク
まともに聞けているのがあまりない……以下箇条書きで感想を書いていきます。

* [The depths of profiling Ruby (osyoyu)](https://rubykaigi.org/2024/presentations/osyoyu.html)
    * 言いつけどおり最前待機した
    * "Software profiling is a never-complete art"
        * やっていくぞ
* [Exploring Reline: Enhancing Command Line Usability (ima1zumi)](https://rubykaigi.org/2024/presentations/ima1zumi.html)
    * いまいずみさんに教えてもらうまで `.inputrc` の存在を知らなかった
    * ちょっとしたスクリプトで `gets.chomp` じゃなく `Reline.readline` するの、いいな……
    * これを書いているときに思ったのが、passwordなどのsensitiveな入力をRelineで受け取るのはどうやるんだろう
        * なるほど `IO#noecho` か～
* [An adventure of Happy Eyeballs (coe401_)](https://rubykaigi.org/2024/presentations/coe401_.html)
    * Happy Eyeballsは[2020年度のGrantでの松下さんによる取り組み](https://www.ruby.or.jp/ja/news/20210517)があってから色々あったのか、なかなか本体に取り込まれなかったけど、しおいさんの努力によって本体に入ってめでたい
    * ところでHappy Eyeballsにはv3の提案があってですね……
        * しかしこれは自分の首を絞める発言でもある
* [Leveraging Falcon and Rails for Real-Time Interactivity (ioquatix)](https://rubykaigi.org/2024/presentations/ioquatix.html)
    * Samuelファンボーイかつ勝手にライバル視している身としては見るしかないセッション
        * まあ実力は足元にも及びませんが……
    * 発表内容は面白かったし、Kaigi on Rails向けといわれるとそれも一理ありますね
    * SamuelのGitHubで彼の作っているものを追っていくと色々とすごい
        * そのことについて、STORES CAFE at RubyKaigi 2024でJeremyと話しました(なんなんだあれは、我々にはできない、的な)(みんなもdigってみよう)
* [Getting along with YAML comments with Psych (qnighy)](https://rubykaigi.org/2024/presentations/qnighy.html)
    * インターネットではお見掛けしてるけど直接話したことはなかったくないさん
    * YAMLのコメントを吐きたい要望って世にはあまりない？みたいな質問をしたり
    * 思ったけど、YAMLってlibyamlなどで出力するんじゃなくて、テンプレートエンジンを使って出力する(helmとか)ケースのほうが多いのかもしれない
* [An mruby for WebAssembly (udzura)](https://rubykaigi.org/2024/presentations/udzura.html)
    * 以下の投稿を参照
        * <https://twitter.com/mizchi/status/1791299723355435147>
        * <https://twitter.com/udzura/status/1791300095981629543>
    * これはRubyKaigi 2024の前週に開催されたTSKaigi 2024でmizchiさんと話していてワクワクしていた
        * というのも、初学者が選ぶ言語としてRubyが選択肢に上がらないのは何故か、という問題意識が(個人的に)あり、例えばNext.jsだったりedge functionとしてのJavaScriptは無料で動かす環境がそれなりに揃っているのに対し、Railsなどサーバーとして動くインスタンスが必要になる場合はあまり無料枠でいろいろいじれる環境がなくなってきているので、その辺で手を出しづらくなっていたりしないか、みたいな仮定をしていました
            * そして、ではEdgeでRubyが動く未来が来るとどうなるのか、そもそもEdgeでRubyが動くためには/選択肢のひとつになるには何が不足しているのか？みたいな議論をTSKaigiの場でmizchiさんとしていたのでした
    * 速度さえなんとかなればmrubyでWASMでedge computing with Ruby、アリなんだよな……
* [Adding Security to Microcontroller Ruby (sylph01)](https://rubykaigi.org/2024/presentations/sylph01.html)
    * これ！！！！これですよ。
    * [レビューしていただいた本](/2023/c103-tlsbook/)もお渡しできて何より
        * <https://twitter.com/s01/status/1791759754571948386>
    * TLS(HTTPS)文脈というよりはCBOR/COSE/CoAP、これは確かにそう
* [Ruby Committers and the World](https://rubykaigi.org/2024/presentations/rubylangorg.html)
    * 「Rubyをキメると気持ちいい」みたいなのは、型による補完がバチバチに効くことでも得られる体験だったりしない？
        * 特に初学者にとってはリファレンスと反復横飛びしなくてもよくなるという点でも型の情報があるとよいと思う
            * コード内に書かせない、せめてコメントによる注釈が黙認レベル、というところに異議はない
    * 自分はPromise, async/awaitが出てきたあたりでJavaScriptを書く機会が増えたのであまりインデントが延々と深くなるcallbackを書いた経験はないけど、それでもasync/awaitが出てきたのは嬉しいポイントだとは考えている
        * 非同期処理の記法としてのasync/awaitがあるべき姿か、と言われるとわからない
    * ビルドシステム、マルチプラットフォーム対応でつらくないものって、そもそも存在するのだろうか
    * defer/ensureについて、隣に座っていたosyoyuがsyntax errorになる記法を発見したのでこれは "来る" か？となった
        * しかし文法の変更はPrism/Lramaのためにしばらく入らない宣言がされており……

## コミュニケーション
やはり普段会えない人と会えるというのはとても貴重な機会でした。STORES CAFEでJeremyを独り占めしてOpenBSDのことを教えてもらったり[^gomen]、いまいずみさんと英語トークの(自分なりの)準備のしかたについて話したり、RubyKaraokeで転岩を2回リクエストされたり、RubyMusicMixinでありたそと限界になったり……

<blockquote class="twitter-tweet"><p lang="qme" dir="ltr"><a href="https://twitter.com/hashtag/rubykaigi?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigi</a> <a href="https://twitter.com/yu_suke1994?ref_src=twsrc%5Etfw">@yu\_suke1994</a> <a href="https://t.co/PRrRq86Lmj">pic.twitter.com/PRrRq86Lmj</a></p>&mdash; ima1zumi (@ima1zumi) <a href="https://twitter.com/ima1zumi/status/1791575939731636427?ref_src=twsrc%5Etfw">May 17, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

![RubyMusicMixin terfno撮影](2024/rubykaigi-2024-rubymusicmixin.jpg)

[^gomen]: Jeremyと話したかった人がいたらマジごめんという感じ

## #RubyKaigiNOC
![](204/rubykaigi-2024-fiber.jpg)

昨年までは得に何も考えずにスケジュールを決めた結果、NOC完全撤収の前に帰ってしまうという(自分的)失態をしたので、今年はちゃんと最後の集荷のスケジュールに合わせて帰ることにしました。ので自分史上最も長くRubyKaigiの会場付近にいたことになります。これは来年も継続していきたいことのひとつです。

NOCの仕事としては、ネットワーク構築、発注したケーブルの巻き直し、当日のケーブル敷設、AP設置、会期中の運用、クソクイズ出題、そして撤収などなどなどがあります。このうち、僕が関われるケーブル巻き直し、敷設、設置、撤収については、特に今年はKMCからの若者が多数参加してくれたおかげで、会場作業については例年の比ではない速度で完了させることができました。本当に助かりました。

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Today&#39;s <a href="https://twitter.com/hashtag/rubykaigiNOC?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigiNOC</a> quiz deployed! <a href="https://twitter.com/hashtag/rubykaigi?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigi</a> <a href="https://t.co/nNG47iIDbZ">pic.twitter.com/nNG47iIDbZ</a></p>&mdash; osyoyu (@osyoyu) <a href="https://twitter.com/osyoyu/status/1791305320482091307?ref_src=twsrc%5Etfw">May 17, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

ところで皆さんはDay 0の準備中や、Day 4の撤収作業をDiscordで配信していたことにお気付きでしたか？

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">RubyKaigi Discordサーバのnetops VCでやってます（きてね）。 <a href="https://twitter.com/hashtag/rubykaigi?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigi</a> <a href="https://twitter.com/hashtag/rubykaigiNOC?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigiNOC</a> <a href="https://t.co/aKfbTF6OSo">https://t.co/aKfbTF6OSo</a> <a href="https://t.co/A2gUzTlHLQ">https://t.co/A2gUzTlHLQ</a></p>&mdash; 花月かすみΛ\_\_Λ (@k\_hanazuki) <a href="https://twitter.com/k_hanazuki/status/1791800197649211655?ref_src=twsrc%5Etfw">May 18, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Day 4は何人か聞きにきてくれたのを観測しています。来年どうなるかはわかりませんが、おもしろコンテンツとして聞きにきてくれたらいいかなと思います。

## レジャー
完全撤収日まで滞在すると数日何も作業予定のない日が発生します。このタイミングで沖縄を満喫しました。

### #rubyistsonwaves
おしょうゆという人がいます。僕は彼に「沖縄行くんだったら船舶免許取ったほうがいいよ」と背中を押され、取りました。

<iframe src="https://mstdn.unasuke.com/@unasuke/112369475717423096/embed" class="mastodon-embed" style="max-width: 100%; border: 0" width="400" allowfullscreen="allowfullscreen"></iframe><script src="https://mstdn.unasuke.com/embed.js" async="async"></script>

そして土曜日、海へ……

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">風も強くて波も高いけど最高！！！！！ <a href="https://twitter.com/hashtag/rubykaigi?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigi</a> <a href="https://twitter.com/hashtag/rubyistsonwaves?src=hash&amp;ref_src=twsrc%5Etfw">#rubyistsonwaves</a> <a href="https://t.co/eTayA3Z7J0">pic.twitter.com/eTayA3Z7J0</a></p>&mdash; なっちゃん (@pndcat) <a href="https://twitter.com/pndcat/status/1791729473630683527?ref_src=twsrc%5Etfw">May 18, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

海に出たあとは戻ってバーベキューをしたりして、これは完全に "陽" だな……と改めて思います。

<blockquote class="twitter-tweet"><p lang="qme" dir="ltr"><a href="https://twitter.com/hashtag/rubyistsonwaves?src=hash&amp;ref_src=twsrc%5Etfw">#rubyistsonwaves</a> <a href="https://twitter.com/yu_suke1994?ref_src=twsrc%5Etfw">@yu\_suke1994</a> <a href="https://t.co/gLNOKnQgtb">pic.twitter.com/gLNOKnQgtb</a></p>&mdash; ねっけつ (@nekketsuuu) <a href="https://twitter.com/nekketsuuu/status/1791732238452928954?ref_src=twsrc%5Etfw">May 18, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

この日は海から帰った後、なはーとで少しNOCの撤収作業があったのでそりゃ夜にはこうなりますわな、という写真です。

<blockquote class="twitter-tweet"><p lang="zxx" dir="ltr"><a href="https://t.co/jiJtOt74sT">pic.twitter.com/jiJtOt74sT</a></p>&mdash; そらは (@sora\_h) <a href="https://twitter.com/sora_h/status/1791887895311343746?ref_src=twsrc%5Etfw">May 18, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

### ドライブ
![果報バンタ(カフウバンタ)](2024/rubykaigi-2024-happycliff.jpg)

それでもまだ数日の空きがあり、その日はKMCのメンバーで沖縄ドライブをしました。民泊でバーベキュー、美ら海水族館、植物園、辺戸岬、ダム見学、タコライス、24時間営業のmelonbooks……沖縄でやるレジャーっぽいことをそこそこやれて良かったです。

<blockquote class="twitter-tweet"><p lang="qme" dir="ltr"><a href="https://twitter.com/hashtag/rubykaigi?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigi</a> <a href="https://t.co/cnRTTBNbJi">pic.twitter.com/cnRTTBNbJi</a></p>&mdash; そらは (@sora\_h) <a href="https://twitter.com/sora_h/status/1792168051036799102?ref_src=twsrc%5Etfw">May 19, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## やっていくぞ
RubyKaigiが終わったら、Kaigi on Railsがやってくるわけです。Kaigi on Railsがんばりモードに切り替えて、やっていきます。

また、ふと思い付いた取り組みがあり、関係者には企みを話して「やろう」ということになったので、やっていきます。こういう話が顔を合わせてやれるのもRubyKaigiのいいところですね。


![コミットしよ](2024/rubykaigi-2024-commitcommit.jpg)
