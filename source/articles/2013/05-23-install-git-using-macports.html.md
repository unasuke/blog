---
title: Macで始めるGUIを使わないやさしくないGit
date: '2013-05-23'
tags:
- git
- howto
- programming
---

GUIを使わないのはついマウスに手が伸びる癖を何とかしたいから。

## MacPortsのインストール

Gitをインストールするために、まずはMacportsをインストールする。MacPortsのインストールにはXcodeが必要なのでそれはMacAppStoreからダウンロードとインストール。
[The MacPorts Project](http://www.macports.org)

## Gitのインストール

Gitのインストールの前に、まずはMacPortsを最新の状態にする。

```shell
$ sudo port selfupdate
```

何か言われたらそれもやっておく。

```shell
$ sudo port upgrade outdated</pre>
```

Gitをインストールするために以下のコマンドを実行。

```shell
$ sudo port install git-core</pre>
```

## Gitを使ってみる

まずは適当なフォルダに適当なコードを保存する。今回は試しにということで授業で出された課題である電話帳のプログラムでGitを使ってみた。
![finderで見るとこんな感じ](2013/git-install-01.png)
ホームフォルダの下に
`WorkSpase/database/database.c`と配置した。この場所はどこでもいいと思う。
そして。このフォルダに移動する。

```shell
$ cd WorkSpase/database
```

そしたらこのフォルダをGitで管理するために以下のコマンドを実行。

```shell
$ git init
```

でもこのままではまだ何も管理してくれないのでプログラムを登録する。

```shell
$ git add database.c
```

これファイル名のところを"."にするとそのフォルダに有るすべてのファイルを登録できるとか。便利。
じゃあ今どんな状態か見てみよう、と。

```shell
$ git status
# On branch master
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#  modified:   database.c
#
no changes added to commit (use "git add" and/or "git commit -a")
```

人によるかもしれないけどだいたいこんな感じの表示が出てくる。じゃあ、変更を登録しよう。

```shell
$ git commit -m "first commit."
```

"first commit"のところは変更点(どんな関数を追加したとか)を英語で書くといいかも。書かなくてもいいかも。ただ書いたほうが絶対にいい、かも。
で、状態をみてみると……

```shell
$ git status
# On branch master
nothing to commit, working directory clean
```

はい、記録されたようですね。じゃあ今までの履歴を見てみよう。

```shell
$ git log
commit 5b54c1047d3cbf5f3b828f8361c2cc49f83649e2
Author: unasuke
Date:   Fri May 24 00:45:39 2013 +0900

    add comment.

commit 6f517649010f2fe6177655951e1bcd21aa6d8347
Author: unasuke
Date:   Thu May 23 01:40:49 2013 +0900

    first commit.
```

僕は2回程度commitしたのでこんな感じになってるけどだいたいそんなような表示になったはず。
やったぜ！Git入門だ！

……で？これだけで何が嬉しいの？状態なのではやめにGitHubとあれこれさせたいところ。専門用語はあえて使わなかった。理解してからまたまとめ直すかもしれない。
