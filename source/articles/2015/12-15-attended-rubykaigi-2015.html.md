---
title: RubyKaigi 2015に参加した
date: 2015-12-15 1:30 JST
tags:
- ruby
- diary
---

![壇上](2015/rubykaigi-2015-stage.jpg)

## 初RubyKaigi
地域RubyKaigiも参加した覚えがなくって、これが初めてのRubykaigiでした。

発表の内容とかはtogeterなど見ればわかると思いますし、それぞれについて感想を書くのも疲れたので、印象に残っていることを書きます。

## matzと迷子になる
1日目、道がわからないままに新橋駅から歩いていると、偶然matzをお見かけしたので、声をかけて道をご存知か尋ねたら知らないとこのことでした。2人でgoogle mapを見ながら歩いて、道を間違えて引き返したりしました。天候の話くらいしかできませんでした。

## hsbtさんに直談判する
1日目にruby 2.3.0-preview2がリリースされましたが、それ関連で、あることが気になり始めました。

### 経緯

僕は[rbenv-default-gems](https://github.com/rbenv/rbenv-default-gems)を使っているのですが、これ、default-gemsの置き場が`.rbenv/`直下なんですね。で、何が困るかというと、rbenvの更新のたびにuntracked fileの表示が出てうざったいのです。じゃあ.gitignoreに追記すればいいじゃないかという事も考えました。しかし、rbenvのいちプラグインにすぎないrbenv-default-gems(それでも作者は同一人物ですが)のファイルの都合を、rbenvが見るのは違うと思います。なので、default-gemsの置き場を`.rbenv/plugins/rbenv-default-gems/`にして、rbenv-default-gemsの.gitignoreにdefault-gemsを追加する、というのが筋の通った実装だと考えました。

さてそんなPull Requestでも書こうかと思っていると、なんとすでにその前段階とも言えるPull Requestが存在しました。
[Allow overriding default-gems location by cdlm · Pull Request #4 · rbenv/rbenv-default-gems](https://github.com/rbenv/rbenv-default-gems/pull/4/files)
しかし、rbenv-default-gemsは最後のcommitが2013年4月で、このissue[Abandoned? · Issue #13 · rbenv/rbenv-default-gems](https://github.com/rbenv/rbenv-default-gems/issues/13)にも全く反応がありません。停滞しています。

なので、ruby-buildにcommitしておられるhsbtさんにそのへんどうなってるのか直談判しに行きました。後で気づいたのですが、僕はてっきり[rbenv organization が爆誕 - HsbtDiary(2015-11-26)](http://www.hsbt.org/diary/20151126.html#p01)を読んでhsbtさんがメンテナになったと思い込んでいたのが、よく読んでみるとメンテナはmislavさんでした。

それでもhsbtさんは僕の話を聞いてくださり、mslavさんに伝えておくとの好意的な回答をしていただけました。hsbtさんありがとうございます。

<blockquote class="twitter-tweet" lang="ja"><p lang="ja" dir="ltr">スタートアップの若者に大企業で働くことのメリットについて解説してる</p>&mdash; SHIBATA Hiroshi (@hsbt) <a href="https://twitter.com/hsbt/status/675628885619310592">2015, 12月 12</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

スタートアップの若者です。

## koicさんとなかよくなる
koicさんは弊社と何かと関わりの深い英和さんの方なのですが、何かと予定が合わず今までお会いすることができませんでした。お会いできて良かったです。rubykaraokeではお世話になりました。

## 感想
- Rubyだいすき
- Railsだいすき
- プロジェクトの停滞きらい
- 御社ステッカーすき
- LTとか発表いっぱいしていきたい

とにかく界隈に知り合いがほとんどいなくて、気持ちがつらいというのがあります。僕は「きっと何者にもなれないお前たち」の「お前たち」のほうなので、とにかく人前に出て行かないと知ってもらえる機会なんてないんですね。

というけでせっせと手を動かしてなんか作って顔を出していきたい気持ちが高まっています。よろしくお願いします。

そして、発表者の方々、スタッフの方々、楽しい時間をありがとうございました。

## 追記
hsbtさんに直談判した件、こんな感じです。これに加えて自分でもPull Requestを送りたいと思います。

- [don't assume rbenv is installed in $HOME by jasonkarns · Pull Request #14 · rbenv/rbenv-default-gems](https://github.com/rbenv/rbenv-default-gems/pull/14)
- [Allow overriding default-gems location by cdlm · Pull Request #4 · rbenv/rbenv-default-gems](https://github.com/rbenv/rbenv-default-gems/pull/4)
