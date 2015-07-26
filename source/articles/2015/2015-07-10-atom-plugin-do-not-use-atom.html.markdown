---
title: atom plugin "do-not-use-atom"を作った
date: '2015-07-10'
tags:
- atom-io
- diary
- programming
---

![do-not-use-atom](do-not-use-atom-01.png)

## 結局vimを使おうという目標

結局、hackableなeditorとは言ってもかゆいところに手が届かない、という事態がありました。具体的には、「拡張子のない、とあるファイルをrubyとみなしてsyntax highlightしてほしい」という願いです。vimであれば、filetypedetectなどで設定できますが、atomだと……その手のプラグインを入れてみましたが、バグかなにかで期待通りの動作をしてくれませんでした。


vim(emacs)での設定法は後ろの席の人に聞けばすぐわかるのですが、atomだとどこを設定すればいいのかわからず、stackoverflowを見てもなにやらよくわからないディレクトリに潜って設定しなければいけないような解説がいくつも出てきて、結局わかりません。


やはり……vimか……


## atomを起動すると警告が出るatom package

そこで、「atomを起動すると警告が出るatom package」を作りました。と言いたいのですが、まだそこまではできていません。プラグインを起動するとアラートが出て、atomが閉じるプラグインを作りました。

[do-not-use-atom](https://atom.io/packages/do-not-use-atom)

![do-not-use-atom page](do-not-use-atom-02.png)


こんな感じで動作します。

![do-not-use-atom 動作](do-not-use-atom-03.gif)

ctrl + alt + o でアラートが出ます。閉じているのはatomのウィンドウのみで、プロセスは死んでいません。


## まとめ

機能増やすためにはatom使わなくちゃいけないしなんのために作ったか全くわからないのにもうstarが付いている。
