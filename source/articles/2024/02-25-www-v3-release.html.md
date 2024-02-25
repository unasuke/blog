---
title: "楽々静的HTTPサーバーことpocke/wwwのv3.0.0をリリースしました"
date: 2024-02-25 20:05 JST
tags:
- golang
- programming
---

![](2024/www-v3-release.png)


## 楽々静的HTTPサーバーことpocke/wwwとは
* <https://github.com/pocke/www>
* [楽々静的HTTPサーバー - pockestrap](https://pocke.hatenablog.com/entry/2016/01/25/120952)
* [www v0.3.0 をリリースした - pockestrap](https://pocke.hatenablog.com/entry/2016/04/09/233321)

これらをご覧ください。ちょこちょこpull reqを投げていたらコミット権をもらえた[^commitbit]ので気付いたときに触っています。

[^commitbit]: 結構昔のことなので経緯はうろ覚えです。勝手にリリースしちゃったけどいいのかな……

タイトルでは「v3.0.0をリリースしました」と言っていますが、その前段階で v2.0.3 をリリースしているので、ついでにそれにも触れていきます。

## v2.0.3
この変更で行なったのは以下の2つです。

* Windows版buildの配布を追加
* deprecatedとなった`ioutil.ReadFile` の削除

### Windows版buildの配布を追加
僕はたまにWindows環境でwwwを使いたいことがあったのですが、リポジトリのreleaseにはLinuxとDarwin(macos)向けのビルド済みバイナリしか存在しませんでした。GoなのでWindows版バイナリを用意するのは簡単ですが、用意されているほうがありがたいですよね。

wwwはリリース作業に[GoReleaser](https://goreleaser.com/)を使用しているので、`.goreleaser.yaml` を用意してWindowsをtargetにしてやるだけで対応完了です。

ちなみにpull requestは1年以上放置していました。よくない。

### deprecatedとなった`ioutil.ReadFile` の削除
エディタで`main.go`を開いたときに気付いたのですが、内部で使用している`ioutil.ReadFile`がdeprecaredとなり警告が発生していました。

* [ioutil package - io/ioutil - Go Packages](https://pkg.go.dev/io/ioutil)
    * > Deprecated: As of Go 1.16, the same functionality is now provided by package io or package os, and those implementations should be preferred in new code.
* [io/ioutil の非推奨化について | text.Baldanders.info](https://text.baldanders.info/golang/deprecation-of-ioutil/)

これは単純に `os.ReadFile` に置き換えるだけで対応完了です。

## v2.1.0
HTTPSへの対応を追加しました。

### HTTPS対応

これについては、himanoaさんのこの発言を見たのが対応のきっかけです。

<iframe src="https://mstdn.maud.io/@himanoa/111889508277940941/embed" class="mastodon-embed" style="max-width: 100%; border: 0" width="400" allowfullscreen="allowfullscreen"></iframe><script src="https://mstdn.maud.io/embed.js" async="async"></script>

そんなわけで、 `--cert` と `--key` に証明書のpathをそれぞれ指定することでhttpsによるリクエストを送ることができるようになりました。このoptionは、両方を指定しないとエラーになるようにしています。

## まとめ
CHANGELOG.mdとかあったほうがいいのかな、という気もしてきましたが……そこまででもないかな？とにかく、[pocke/www](https://github.com/pocke/www)は便利なのでよろしくお願いします。
