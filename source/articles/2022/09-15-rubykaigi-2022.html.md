---
title: "RubyKaigi 2022 参加記"
date: 2022-09-15 20:10 JST
tags: 
  - ruby
  - quic
  - programming
  - rubykaigi
---

![](2022/rubykaigi-2022-slide.png)

## 発表について

<iframe src="https://slide.rabbit-shocker.org/authors/unasuke/rubykaigi-2022/viewer.html"
        width="640" height="404"
        frameborder="0"
        marginwidth="0"
        marginheight="0"
        scrolling="no"
        style="border: 1px solid #ccc; border-width: 1px 1px 0; box-sizing: content-box; margin-bottom: 5px"
        allowfullscreen> </iframe>
<div style="margin-bottom: 5px">
  <a href="https://slide.rabbit-shocker.org/authors/unasuke/rubykaigi-2022/" title="Do Pure Ruby Dream of Encrypted Binary Protocol?">Do Pure Ruby Dream of Encrypted Binary Protocol?</a>
</div>

<https://slide.rabbit-shocker.org/authors/unasuke/rubykaigi-2022/> (みんなRabbit使おう！)

昨年の発表から方針を変更し、実装をしていく中で、Rubyだとつらいな～と感じた事について話しました。発表内で、「Ractorをやめた」という表現をしましたが、実際にはRactorに依存しない部分もそれなにり書き直しており、そのためコードの外部から見た振る舞いは、昨年からは微々たる進展しかありませんでした。

発表後、バイナリデータをRubyでそのまま扱うことについて、Samuel氏から `IO::Buffer` の存在について教えていただきました。

<blockquote class="twitter-tweet"><p lang="en" dir="ltr"><a href="https://twitter.com/yu_suke1994?ref_src=twsrc%5Etfw">@yu\_suke1994</a> have you looked at IO::Buffer?</p>&mdash; Samuel Williams (@ioquatix) <a href="https://twitter.com/ioquatix/status/1568080314794385410?ref_src=twsrc%5Etfw">September 9, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

これはバイナリを扱うことについては既存のString、Integerよりも適していそうではあるものの、その内容に対して演算したい場合にまだまだ機能が不足しているのではないかと感じました。また、発表で用いたString、Integerでの操作を行うベンチマークを `IO::Buffer` も対象にして実行してみたところ、3つの中では最も遅いという結果になりました。

<https://github.com/unasuke/rubykaigi-2022/commit/1e4470d55217d6c8> (これ、experimentalの警告を消す段階で `hello_world_upcase_io_buffer` のWarming up、Calculatingの結果が消えていますね……ミスです……)

この結果についても会場でSamuel氏と話したところ、演算する過程で都合上 `set_value` と `get_value` をしている部分があるのですが、そこでオブジェクトの正当性のチェック処理が走っている[^iobuf]のが原因ではないか、ということを教えていただきました。

[^iobuf]: <https://github.com/ruby/ruby/blob/v3_1_2/io_buffer.c#L1324>

## 若干の燃え尽きだった

ところで、言ってしまえば前回のRubyKaigiからこれまでの間に、もっと多くのコードが書けたはずでした。しかし、昨年の発表の直後に開催されたKaigi on Rails 2021の運営、さらにその後に控えていたCloudNative Days Tokyo 2021での発表と、立て続けにイベントがあったことで若干燃え尽きてしまいました。しばらくプライベートの時間でQUIC関連のコードを書く気持ちになれない期間が続いていました。そもそも趣味プロジェクトだし、差し迫った締め切りというものも存在しないのも大きな要因でしょう。

## 締め切りを作っていく

なので今後は、もうちょっと自分を追い込んでいこうかなと思っています[^oikomi]。具体的には、Rubyアソシエーション開発助成金2022に応募しました[^grant]。50万円という助成金よりは、成果発表をしなければいけないことによって強制的に手を動かす動機ができること、もしかしたらメンターが付くかもしれないということのほうが、今の僕には魅力に感じました。採択されなかった場合も、別の形で締切を生み出す案がうっすらとあるので、ともかくやっていこうと思います。

## こっそりお手伝い
そして、実は今回のRubyKaigi 2022において、会場のインターネット設営の準備をお手伝いしていました[^wifi]。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">荷物整理終わった <a href="https://twitter.com/hashtag/rubykaigiNOC?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigiNOC</a> <a href="https://twitter.com/hashtag/rubykaigi?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigi</a> <a href="https://t.co/j1noLwgUHM">pic.twitter.com/j1noLwgUHM</a></p>&mdash; そらは (@sora\_h) <a href="https://twitter.com/sora_h/status/1568884816569077761?ref_src=twsrc%5Etfw">September 11, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

2018年、2019年とhelperとしてやっていたのが一旦なくなったことで、3年ぶりにケーブルを8の字巻きしたり、ケーブルを這わせに会場を駆け回ったりするのはとても懐かしかったです。
そういう訳で、一般参加者T、登壇者T、スタッフTの三種[^tshirts]を手にすることができました。in-personの嬉しいところは、ちゃんとそれぞれの属性に応じたTシャツを手に入れられることにもあると感じました。

![Tシャツ3枚](2022/rubykaigi-2022-tshirts.jpg)

## Ruby Music Mixin
本編終了後には、ピクシブさんの主催するアフターパーティーでDJをさせていただけました。これがめちゃくちゃ楽しかったです。

![pixiv Ruby Music Mixin](2022/rubykaigi-2022-pixiv-ruby-music-mixin.jpg)

ちなみにこれを聞いたのがこのタイミングだったのですが、クラブイベントの参加も初めてだったようで、それも楽しかったとおっしゃっていただけたのもとても嬉しかったです。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">「初めてでしたけど楽しかったです！」って言ってもらえてめっっちゃ嬉しかったよね <a href="https://twitter.com/hashtag/rubykaigi?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigi</a></p>&mdash; うなすけ (@yu\_suke1994) <a href="https://twitter.com/yu_suke1994/status/1568598715820314629?ref_src=twsrc%5Etfw">September 10, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## Next Kaigi
来年のRubyKaigiは松本リベンジということですが、実は7月になぜか松本に行っていました。このときは車で行ったので、来年も車で行こうかな？と思ったりしています。

<blockquote class="twitter-tweet"><p lang="zxx" dir="ltr"><a href="https://t.co/rt2Q750S1B">pic.twitter.com/rt2Q750S1B</a></p>&mdash; うなすけ (@yu\_suke1994) <a href="https://twitter.com/yu_suke1994/status/1542853586979536896?ref_src=twsrc%5Etfw">July 1, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

でも実はそれより先にKaigi on Railsがあるので、まずはそれに向けてがんばっていきます。

[^oikomi]: もちろん壊れない程度に
[^grant]: 三重で何人かにレビューをしていただきました
[^wifi]: ~~helper登録はしていないのでスタッフ一覧にはいません~~ 載りました (2022-09-17)
[^tshirts]: あと一種類ですね、ですけど……
