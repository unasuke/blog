---
title: MacBookのXcodeでプログラミングをする人のためのBBUDebuggerTuckAway
date: '2014-03-04'
tags:
- howto
- mac
- programming
---

## Xcodeは素晴らしいIDEです

Xcodeは補完の強力な、iOS開発には欠かせない素晴らしいIDEです。が、MacBookで使うとなると、どうしても気になってくるのが__画面の狭さ__ですね。
![画面が狭い](bbudebuggertuckaway-01.jpg)

## BBUDebuggerTuckAway

[BBUDebuggerTuckAway](https://github.com/neonichu/BBUDebuggerTuckAway)は、入力を開始するとデバッグエリアを自動的に隠してくれるソフトウェアです。

## インストール方法

まず、適当なフォルダを作ります。~/workspaceでもなんでも。
```shell
$mkdir ~/workspace
```

次に、githubのプロジェクトをコピーします。
```shell```
$cd ~/workspase
$git clone https://github.com/neonichu/BBUDebuggerTuckAway.git
```

gitが入ってない場合やめんどくさい場合はgithubのDownload ZIPからZIPファイルをダウンロードして解凍すればまあ同じことです。[ここからもダウンロードできます(Download ZIPへの直リンク)](https://github.com/neonichu/BBUDebuggerTuckAway/archive/master.zip)
そしたらフォルダ内の.xcodeprojファイルを開いて……
![これを開く](bbudebuggertuckaway-02.jpg)
そしたらコンパイルしてXcodeを再起動すると……
![こうする](bbudebuggertuckaway-03.jpg)
[youtube](https://www.youtube.com/watch?v=rjygs4n6oIY)
このように、入力開始とともにデバッグエリアが自動的に隠れます。
