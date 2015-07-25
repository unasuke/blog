---
title: Borland C++ CompilerとBCpadでGrWin
date: '2014-05-24'
tags:
- howto
- programming
---

<h2>完全なる身内記事</h2>

そもそも今どきBorland C++ CompilerとBCpadとGrWinの組み合わせでプログラミングする環境がいくつあるんだっていう話である。このご時世ならProcessingとか使うでしょう……そのほうが楽っていうかなんていうか。

<h3>書き直しでもある</h3>

実は同じ内容の記事をすでに書いてる。<a href="http://d.hatena.ne.jp/yu_suke1994/20111026/1319631198" target="_blank">GrWinの導入方法 うなすけとあれこれだったもの</a>それを今更書き直す意味があるかというと、特に無い。でも(おそらく)先生が見たであろうこの記事には思い入れがあるので、書きなおしてみたくなった。

<strong>※ただ書き直しただけなので、検証とかは一切行っていない</strong>

<h2>Borland C++ Compiler</h2>

今では配布元が変わり、エンバカデロになっている。
<a href="http://www.embarcadero.com/jp/products/cbuilder/free-compiler" target="_blank">C++コンパイラ（無償版） | 製品 - Embarcadero Technologies</a>
なんとダウンロードには名前、メールアドレスのみならず住所までもが必須入力となっている。ちょっとこわい。どうしても入力はしたくないけど欲しい場合は僕のところまで来てください。悪態つきながら渡します。
インストールは特に言うことはない。あるとすれば「正しくインストールされなかった可能性があります」とか出てくるかもしれないので「正しくインストールされました」を選択する。

<h2>BCpad</h2>

作者であるきときとさんのページにあるVectorのリンクからはダウンロードができなくなっているので、<a href="http://cpad.michikusa.jp/" target="_blank">CPad ダウンロードページ (一時退避場)</a>からダウンロードする。

<h2>GrWin</h2>

<a href="http://spdg1.sci.shizuoka.ac.jp/grwinlib/" target="_blank">GrWin／GrWinC - 静岡大学</a>
コンパイラによってダウンロードするファイルが異なります。
組み合わせ的に「Borland C++ &amp; f2c」を選択。
<a href="http://unasuke.com/wp/wp-content/uploads/2014/05/20111026210432.png"><img src="http://unasuke.com/wp/wp-content/uploads/2014/05/20111026210432.png" alt="20111026210432" width="800" height="495" class="alignnone size-full wp-image-700" /></a>

<h2>BCpad側の設定</h2>

実行→設定の、設定タブにあるコンパイル時パラメータに以下の文字列を入力する。
<strong>-w-8060 -WC GrWin.lib</strong>
<a href="http://unasuke.com/wp/wp-content/uploads/2014/05/20111026210430.png"><img src="http://unasuke.com/wp/wp-content/uploads/2014/05/20111026210430.png" alt="20111026210430" width="800" height="447" class="alignnone size-full wp-image-701" /></a>
<a href="http://unasuke.com/wp/wp-content/uploads/2014/05/20111026210428.png"><img src="http://unasuke.com/wp/wp-content/uploads/2014/05/20111026210428.png" alt="20111026210428" width="800" height="452" class="alignnone size-full wp-image-702" /></a>

以上。これでコンパイルができるようになっているはずである。
<a href="http://unasuke.com/wp/wp-content/uploads/2014/05/20111026210435.png"><img src="http://unasuke.com/wp/wp-content/uploads/2014/05/20111026210435.png" alt="20111026210435" width="447" height="532" class="alignnone size-full wp-image-703" /></a>
