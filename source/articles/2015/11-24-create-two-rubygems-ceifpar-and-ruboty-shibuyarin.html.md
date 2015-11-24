---
title: rubygemを２つ作って公開した
date: 2015-11-24 19:00 JST
tags:
- Programming
- ruby
- gem
- diary
---

![rubygem 2つ](2015/create-two-rubygems.png)

## それは今年の5月のこと
smartnews社でのパーティーで、今年の抱負として「rubygemを2つ作ります」と宣言したのを、僕以外に覚えている人がいるでしょうか。

まあそれでも人は宣言したことはやるので、まとまった休みに重い腰を上げて人生初rubygemの制作に取り掛かりました。

その当時からgemにするならあれとあれ、というのは決まっていたのに、半年も先延ばしにするとは……

## rubygemの作り方
```shell
$ gem install bundler
$ bundle gem gem_name
```
これで雛形は出来上がりです。あとはやっていきましょう。

rubygems.orgにアカウント作ってもcredentialを落とすところはないし、あちこちに書いてあるAPIへのリンクやドキュメントもないのでそこは少し手間取りました。書いてあるそのままを実行すればよかったです。

## ceifpar
[unasuke/ceifpar](https://github.com/unasuke/ceifpar)

これは[Rubyとrmagickでjpegのexif削除、サイズ変更ツールを作った話](/2015/story-about-ceifpar-rb)をgemにしたものです。

コマンドライン上でのみの操作だったものをメソッドに切り出し、テストを書いてgemの形に仕上げました。もともとがgemでなかったものをgemにしたので、commit logを見ればgemの作り方がなんとなーくわかるんじゃないかなと思います。そんなところまでわざわざ見る人はいないでしょうが。

## ruboty-shibuyarin
[unasuke/ruboty-shibuyarin](https://github.com/unasuke/ruboty-shibuyarin)

これはRubotyプラグインを作成したもので、まだ未完成([セリフの追加が終わっていない](https://github.com/unasuke/ruboty-shibuyarin/pull/2))ですが呼びかけに対しての応答はできるのでとりあえず出してしまえ、という感じのものです。テストの書き方がわからない。

## テスト
それぞれでtest frameworkが違います。ceifparはminitestで、ruboty-shibuyarinはrspecです。まだまだどちらが書きやすいとかはなく、どっちにしてもどう書けばいいかでうんうん悩みながら書いています。

ceifparの方は画像を加工するので、testデータとして画像を持っておくべきかどうか考えましたが、画像の加工に関してはrmagick(imagemagick)を使用しており、どちらかと言うと責務はこちらにあるものではない、と判断しました。なので、ceifparの方のテストはjpeg判断と比率正規化のもののみとなりました。

rubotyの方はいろいろな方のリポジトリを見ましたが、どうにも呼び出しがわからず、今後の課題とします。

## gemを作ってみて
終わらせると「こんなものか」と拍子抜けしますが、やってみる前は右も左もわからない状態でした。

こんな規模のgem、作れたところで自慢にも何にもならないのでしょうが、初心者からすると偉大な一歩に思えるものです。仕事でRails触り始めてもう1年が経とうとしている人が初心者を名乗るのもおかしいですが。
でも僕にとっては大きな一歩だと思っています。よっしゃやったるでという感じ。

とりあえず宣言したことをやり遂げたので満足です。あとセリフ追加します。
