---
title: "Itamaeの次回リリースに含まれる非互換な挙動について"
date: 2022-07-04 22:23 JST
tags: 
- ruby
- itamae
- programming
---

![](2022/itamae-logo.png)

## Itamaeとは
Itamaeというのは、構成管理ツールです。Ruby DSLで構成を定義することができます。Rubyで書けるAnsible[^ansible]と言ってしまうのがわかりやすいかもしれません。

[^ansible]: この手のツールはすっかりAnsible一強となってしまった感じがありますが、Itamaeもなかなかいいものなので使ってみてほしいです。これは我々のドキュメントや広報不足などでの努力不足な面もあるとは思いますが。

- <https://itamae.kitchen>
- [Itamaeが構成管理を仕込みます！ ～新進気鋭の国産・構成管理ツール～：連載｜gihyo.jp … 技術評論社](https://gihyo.jp/admin/serial/01/itamae)
- [導入しやすく軽量な構成管理ツール「Itamae」を使ってみよう | さくらのナレッジ](https://knowledge.sakura.ad.jp/4341/)

## `local_ruby_block` が実行ディレクトリの指定を考慮していなかった、という問題
さて、タイトルにもある「非互換な挙動」について説明します。

まず、Itamaeにはresourceというものがあります。これはdirectory resourceであればディレクトリの存在を定義でき、execute resourceであれば与えられたコマンドが実行されることを定義できます。resourceの一覧は以下Wikiにまとまっています。

<https://github.com/itamae-kitchen/itamae/wiki/Resources>

それらresourceのなかに `local_ruby_block` というものがあります。これは与えられたRubyのコードブロックを実行するものです。これにより、単にfile resourceでファイルを作成する場合と比較して、より柔軟にファイルの中身を制御するなどの様々なことが可能になります。

そしてresourceは、いくつかの属性を設定することができ、そのひとつに `cwd` という、そのresourceがどこで実行されるか(current working directory)というものがあります。

この `cwd` が、 `local_ruby_block` で機能していない、というのがissueとして報告されました。

[`cwd` does not work in `local_ruby_block` · Issue #353 · itamae-kitchen/itamae](https://github.com/itamae-kitchen/itamae/issues/353)

この問題の原因は、`local_ruby_block` を実行するItamaeのプロセスのworking directoryが `cwd` で指定されたものに移動していないからだ、と自分は考えました。

よって、この挙動を修正し、 `cwd` に移動した状態で `local_ruby_block` を実行するようにしたItamaeが、v1.14.0としてリリースされる予定です。mitamae側も、itamae側とタイミングを合わせてリリースします。

- [Execute local\_ruby\_block code inside of chdir-ed block if cwd presented by unasuke · Pull Request #355 · itamae-kitchen/itamae](https://github.com/itamae-kitchen/itamae/pull/355)
- [Execute local\_ruby\_block code inside of chdir-ed block if cwd presented by unasuke · Pull Request #122 · itamae-kitchen/mitamae](https://github.com/itamae-kitchen/mitamae/pull/122)

## この挙動は2015年から存在していた
さて、このような挙動になっていたのはいつからでしょうか。これは、調べてみると `cwd` の属性が全てのresource typeで使用できるようになった、 2015年にリリースされた v1.4.0 からであることがわかりました。

[Make `cwd` a common attribute. (idea by @tacahilo ) by ryotarai · Pull Request #146 · itamae-kitchen/itamae](https://github.com/itamae-kitchen/itamae/pull/146)

2015年から今までの間にこの問題が報告されなかったということは、`local_ruby_block` を `cwd` つきで使用する人が今まで居なかったのか、それとも現在の挙動で問題無いと考える人しかいなかったのか……どちらなのかはわかりません。しかし、GitHubに存在するコードを検索した結果、 `local_ruby_block` と `cwd` の組み合わせが使われているコードは見当たりませんでした。

<https://github.com/search?q=language%3Aruby+local_ruby_block&type=code>

よってこの挙動の変更による影響はそこまで大きくないと見積もることができます。

## 問題はあなたの手元にある公開されていないコード
さて、Itamaeは構成管理ツールです。そのことを考えると、公開されていないItamaeのrecipe(構成を定義したコードのことをItamaeではこう呼びます)のほうが、遥かに多いはずです。それなりに長い歴史のある挙動を変更するので、既存のrecipeがこの挙動に依存しているかもしれません。

そのため、お手元のrecipeが以前の挙動に依存していて、かつ変更されると困る場合は、Itamae側に報告してください。この記事がその周知となれば幸いです。
