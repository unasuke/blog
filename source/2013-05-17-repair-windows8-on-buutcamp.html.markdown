---
title: MacにBootcampでWindows8をインストールした後にパーティションを追加するとWindows8が起動しなくなる問題の解決法
date: '2013-05-17'
tags:
- howto
- mac
- windows
---

タイトルが長い。
MacにBootcampを使ってWindowsをインストールすると、標準ではMacとWindowsの2つのパーティションができる。しかし、どちらもどちらのファイルシステム(HFS+とNTFS)を読み書きすることができないので、データの共有は外部保存領域を使用せねばならない。これは面倒である。まあ再起動も面倒ではあるのだが。
そこで、ディスクユーティリティ.appを用いて共有パーティション(exFAT)を作成したのだが、Windowsが起動ディスク選択画面で見えなくなってしまった。

[caption id="attachment_22" align="alignnone" width="300"]<a href="http://unasuke.com/wp/wp-content/uploads/2013/05/69b486dbedb3a2fa3b8ef68cf57c2dab.png"><img class="size-medium wp-image-22" alt="共有パーティションを作成した例" src="http://unasuke.com/wp/wp-content/uploads/2013/05/69b486dbedb3a2fa3b8ef68cf57c2dab-300x259.png" width="300" height="259" /></a> 共有パーティション作成後の様子(win起動化済み)[/caption]

そこで、Windows8のインストールディスクを挿入し、optionキーを押しながら起動。この時の起動ディスクは光学メディアの形のUEFIではなく、光学メディアの形のWindowsである。そしてコンピュータの修復から自動修復を選択し、あとは待っていれば自動修復が完了しWindowsが起動できるようになる。
