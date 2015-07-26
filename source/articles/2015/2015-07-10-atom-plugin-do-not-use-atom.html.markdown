---
title: atom plugin "do-not-use-atom"を作った
date: '2015-07-10'
tags:
- atom-io
- diary
- programming
---

<a href="http://unasuke.com/wp/wp-content/uploads/2015/07/Settings_-__Users_yusuke_src_github_com_unasuke_do-not-use-atom_-_Atom.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/07/Settings_-__Users_yusuke_src_github_com_unasuke_do-not-use-atom_-_Atom-1024x324.png" alt="do-not-use-atom" width="625" height="198" class="alignnone size-large wp-image-1211" /></a>
<h2>結局vimを使おうという目標</h2>
<p>
    結局、hackableなeditorとは言ってもかゆいところに手が届かない、という事態がありました。具体的には、「拡張子のない、とあるファイルをrubyとみなしてsyntax highlightしてほしい」という願いです。vimであれば、filetypedetectなどで設定できますが、atomだと……その手のプラグインを入れてみましたが、バグかなにかで期待通りの動作をしてくれませんでした。
</p>
<p>
    vim(emacs)での設定法は後ろの席の人に聞けばすぐわかるのですが、atomだとどこを設定すればいいのかわからず、stackoverflowを見てもなにやらよくわからないディレクトリに潜って設定しなければいけないような解説がいくつも出てきて、結局わかりません。
</p>
<p>    
    やはり……vimか……
</p>

<h2>atomを起動すると警告が出るatom package</h2>
<p>
    そこで、「atomを起動すると警告が出るatom package」を作りました。と言いたいのですが、まだそこまではできていません。プラグインを起動するとアラートが出て、atomが閉じるプラグインを作りました。
</p>
<p>    
    <a href="https://atom.io/packages/do-not-use-atom">do-not-use-atom</a>
</p>
<p>
    <a href="http://unasuke.com/wp/wp-content/uploads/2015/07/do-not-use-atom.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/07/do-not-use-atom-1024x541.png" alt="do-not-use-atom page" width="625" height="330" class="alignnone size-large wp-image-1213" /></a>
</p>
<p>
    こんな感じで動作します。
</p>
<p>
    <a href="http://unasuke.com/wp/wp-content/uploads/2015/07/aaaaaaa.gif"><img src="http://unasuke.com/wp/wp-content/uploads/2015/07/aaaaaaa.gif" alt="do-not-use-atom 動作" width="927" height="637" class="alignnone size-full wp-image-1217" /></a>
</p>
<p>
    ctrl + alt + o でアラートが出ます。閉じているのはatomのウィンドウのみで、プロセスは死んでいません。
</p>

<h2>まとめ</h2>
<p>
    機能増やすためにはatom使わなくちゃいけないしなんのために作ったか全くわからないのにもうstarが付いている。
</p>
