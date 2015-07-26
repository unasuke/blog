---
title: Borland C++ CompilerとBCpadでGrWin
date: '2014-05-24'
tags:
- howto
- programming
---

## 完全なる身内記事

そもそも今どきBorland C++ CompilerとBCpadとGrWinの組み合わせでプログラミングする環境がいくつあるんだっていう話である。このご時世ならProcessingとか使うでしょう……そのほうが楽っていうかなんていうか。

### 書き直しでもある

実は同じ内容の記事をすでに書いてる。[GrWinの導入方法 うなすけとあれこれだったもの](http://d.hatena.ne.jp/yu_suke1994/20111026/1319631198)それを今更書き直す意味があるかというと、特に無い。でも(おそらく)先生が見たであろうこの記事には思い入れがあるので、書きなおしてみたくなった。

__※ただ書き直しただけなので、検証とかは一切行っていない__

## Borland C++ Compiler

今では配布元が変わり、エンバカデロになっている。
[C++コンパイラ（無償版） | 製品 - Embarcadero Technologies](http://www.embarcadero.com/jp/products/cbuilder/free-compiler)
なんとダウンロードには名前、メールアドレスのみならず住所までもが必須入力となっている。ちょっとこわい。~~どうしても入力はしたくないけど欲しい場合は僕のところまで来てください。悪態つきながら渡します。~~
インストールは特に言うことはない。あるとすれば「正しくインストールされなかった可能性があります」とか出てくるかもしれないので「正しくインストールされました」を選択する。

## BCpad

作者であるきときとさんのページにあるVectorのリンクからはダウンロードができなくなっているので、<a href="http://cpad.michikusa.jp/" target="_blank">CPad ダウンロードページ (一時退避場)</a>からダウンロードする。

## GrWin

[GrWin／GrWinC - 静岡大学](http://spdg1.sci.shizuoka.ac.jp/grwinlib/)
コンパイラによってダウンロードするファイルが異なります。
組み合わせ的に「Borland C++ & f2c」を選択。
![Borland C++ & f2c](grwin-01.png)

## BCpad側の設定

実行→設定の、設定タブにあるコンパイル時パラメータに以下の文字列を入力する。
`-w-8060 -WC GrWin.lib`
![実行の設定の](grwin-02.png)
![ここ](grwin-03.png)

以上。これでコンパイルができるようになっているはずである。
![実行可能になりました](grwin-04.png)
