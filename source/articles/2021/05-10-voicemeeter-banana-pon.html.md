---
title: VoiceMeeter Bananaだけでポン出しをする
date: 2021-05-10 19:00 JST
tags: 
- dialy
- voicemeeter_banana
- windows
---


## ミーティングやLT会でポン出しがしたい
昨今の社会情勢から、オンライン上で会議をしたり、LT会に参加したりということが増えてきました。そうすると、たまに拍手音などのちょっとした効果音を流したいという場面も出てきます。そのような「ポン出し」を手軽にできる方法が無いものでしょうか。

## VoiceMeeter Banana
そこで、VoiceMeeter Bananaというソフトウェアを使います。

[VB-Audio VoiceMeeter Banana](https://vb-audio.com/Voicemeeter/banana.htm) (公式サイト)


VoiceMeeter Bananaは仮想ミキサーソフトウェアで、配信用途でその使用方法を紹介している記事が沢山あります。そのようなものを見たことがある方もいらっしゃるでしょう。以下にVoiceMeeter Bananaの紹介や使い方について記載されている記事をいくつか記載しました。

- [【藤本健のDigital Audio Laboratory】Windowsユーザにオススメの万能仮想ミキサー「VoiceMeeter Banana」が凄い-AV Watch](https://av.watch.impress.co.jp/docs/series/dal/1255935.html)
- [「Voicemeeter Banana」の設定における基本的な考え方](http://labo.pls-ys.com/stemiki/base_setting.html)
- [京都大学 Panda／Zoom／Kaltura利用支援サイト](https://kyoto-u.github.io/online-edu/zoom-audio-voicemeter)


## 他のアプリと組み合せたポン出し
[リモート飲み会やテレビ会議でBGMや効果音を流して和もう！ (ソフトウェアミキサーで遊ぶ)](https://www.kokozo.net/remoteNomikai/)

上記の記事にもあるように、VLCなどのメディアプレイヤーとVoiceMeeter Bananaを組み合わせればポン出しは可能です。

しかしVLCを使った場合だと、複数の音を出し分けたい場合に、その種類の数だけウィンドウを開く必要があり少々不便でした。

## Macro Buttonsで音を再生する
ところでVoiceMeeter BananaにはMacro Buttonsという機能があります。VoiceMeeter Bananaをインストールしたときに同時にインストールされるものです。

![Macro Buttons](2021/voicemeeter-banana-macro-buttons.png)

このMacro Buttonsでは様々な操作を行うことができます。どのようなことが可能なのかは公式のマニュアルに記載があります。

<https://vb-audio.com/Voicemeeter/VoicemeeterBanana_UserManual.pdf>

このなかの `Recorder.load` を使用することで音声を流すことができます。この動画の1:30あたりからMacro Buttonsの使い方についての説明が始まります。

<iframe width="560" height="315" src="https://www.youtube.com/embed/Mkri8RN561U?start=94" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

せっかくなのでどのように使用するか、ここでも書いていこうと思います。

まずMacro Buttonsを起動し、どれかのボタンを右クリックすることで設定画面が開きます。

![Macro Buttonsの設定画面を開く](2021/voicemeeter-banana-macro-buttons-configure.gif)

ここで、"Request for Button ON / Trigger IN:" に `Recorder.load = "ここに音声ファイルの場所"` と書きます。

![Macro Buttonsの設定例](2021/voicemeeter-banana-macro-buttons-setting.png)

音声ファイルの場所はエクスプローラーからコピーするのが手軽でしょう。

![explorerからpathのコピー](2021/voicemeeter-banana-macro-buttons-copy-path.gif)

そして、このように設定したMacro Buttonをクリックすると、VoiceMeeter Banana上のカセットテープの部分にファイルが読み込まれて再生される様子が確認できます。

![ポン出しの様子](2021/voicemeeter-banana-macro-buttons-pon.gif)

注意点として、一度に再生できる音声はひとつだけのようなので、何度もクリックしてエコーがかかったような状態にすることはできません。

## 最後に
この記事ではMacro Buttonsで音声を流す方法について触れましたが、押している間だけマイクをミュートするといったこともできるようです。VoiceMeeter Bananaの説明書には、もっと色々な機能が記載されています。英語ではありますが、解説記事だけではなく一度説明書を読んでみることをオススメします。(僕はそれでMacro Buttonsの使い方を知りました)

また、VoiceMeeter BananaはDonationwareということもあり無料で使うことができますが、活用しているという方は是非寄付をしてみてはいかがでしょうか。
