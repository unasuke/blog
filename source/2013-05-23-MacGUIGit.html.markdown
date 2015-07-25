---
title: Macで始めるGUIを使わないやさしくないGit
date: '2013-05-23'
tags:
- git
- howto
- programming
---

GUIを使わないのはついマウスに手が伸びる癖を何とかしたいから。

<h2>MacPortsのインストール</h2>

Gitをインストールするために、まずはMacportsをインストールする。MacPortsのインストールにはXcodeが必要なのでそれはMacAppStoreからダウンロードとインストール。
<a href="http://www.macports.org">The MacPorts Project</a>

<h2>Gitのインストール</h2>

Gitのインストールの前に、まずはMacPortsを最新の状態にする。

<pre class="lang:default highlight:0 decode:true " >$ sudo port selfupdate</pre>

何か言われたらそれもやっておく。

<pre class="lang:default highlight:0 decode:true " >$ sudo port upgrade outdated</pre>

Gitをインストールするために以下のコマンドを実行。

<pre class="lang:default highlight:0 decode:true " >$ sudo port install git-core</pre>

<h2>Gitを使ってみる</h2>

まずは適当なフォルダに適当なコードを保存する。今回は試しにということで授業で出された課題である電話帳のプログラムでGitを使ってみた。
[caption id="attachment_58" align="alignnone" width="300"]<a href="http://unasuke.com/wp/wp-content/uploads/2013/05/aa47117198cba644e936c1d214099b3d.png"><img src="http://unasuke.com/wp/wp-content/uploads/2013/05/aa47117198cba644e936c1d214099b3d-300x196.png" alt="finderで見るとこんな感じ" width="300" height="196" class="size-medium wp-image-58" /></a> プログラムを配置[/caption]
ホームフォルダの下に
<code>WorkSpase/database/database.c</code>
と配置した。この場所はどこでもいいと思う。
そして。このフォルダに移動する。

<pre class="lang:default highlight:0 decode:true " >$ cd WorkSpase/database</pre>

そしたらこのフォルダをGitで管理するために以下のコマンドを実行。

<pre class="lang:default highlight:0 decode:true " >$ git init</pre>

でもこのままではまだ何も管理してくれないのでプログラムを登録する。

<pre class="lang:default highlight:0 decode:true " >$ git add database.c</pre>

これファイル名のところを"."にするとそのフォルダに有るすべてのファイルを登録できるとか。便利。
じゃあ今どんな状態か見てみよう、と。

<pre class="lang:default highlight:0 decode:true " >$ git status
# On branch master
# Changes not staged for commit:
#   (use "git add &lt;file&gt;..." to update what will be committed)
#   (use "git checkout -- &lt;file&gt;..." to discard changes in working directory)
#
#  modified:   database.c
#
no changes added to commit (use "git add" and/or "git commit -a")</pre>

人によるかもしれないけどだいたいこんな感じの表示が出てくる。じゃあ、変更を登録しよう。

<pre class="lang:default highlight:0 decode:true " >$ git commit -m "first commit."</pre>

"first commit"のところは変更点(どんな関数を追加したとか)を英語で書くといいかも。書かなくてもいいかも。ただ書いたほうが絶対にいい、かも。
で、状態をみてみると……

<pre class="lang:default highlight:0 decode:true " >$ git status
# On branch master
nothing to commit, working directory clean</pre>

はい、記録されたようですね。じゃあ今までの履歴を見てみよう。

<pre class="lang:default highlight:0 decode:true " >$ git log
commit 5b54c1047d3cbf5f3b828f8361c2cc49f83649e2
Author: unasuke
Date:   Fri May 24 00:45:39 2013 +0900

    add comment.

commit 6f517649010f2fe6177655951e1bcd21aa6d8347
Author: unasuke
Date:   Thu May 23 01:40:49 2013 +0900

    first commit.
</pre>

僕は2回程度commitしたのでこんな感じになってるけどだいたいそんなような表示になったはず。
やったぜ！Git入門だ！

……で？これだけで何が嬉しいの？状態なのではやめにGitHubとあれこれさせたいところ。専門用語はあえて使わなかった。理解してからまたまとめ直すかもしれない。
