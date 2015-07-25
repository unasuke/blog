---
title: MacBookのXcodeでプログラミングをする人のためのBBUDebuggerTuckAway
date: '2014-03-04'
tags:
- howto
- mac
- programming
---

<h2>Xcodeは素晴らしいIDEです</h2>

Xcodeは補完の強力な、iOS開発には欠かせない素晴らしいIDEです。が、MacBookで使うとなると、どうしても気になってくるのが<strong>画面の狭さ</strong>ですね。
<a href="http://unasuke.com/wp/wp-content/uploads/2014/03/xcode.jpg"><img src="http://unasuke.com/wp/wp-content/uploads/2014/03/xcode-1024x629.jpg" alt="xcode" width="625" height="383" class="alignnone size-large wp-image-490" /></a>

<h2>BBUDebuggerTuckAway</h2>

<a href="https://github.com/neonichu/BBUDebuggerTuckAway" target="_blank">BBUDebuggerTuckAway</a>は、入力を開始するとデバッグエリアを自動的に隠してくれるソフトウェアです。

<h2>インストール方法</h2>

まず、適当なフォルダを作ります。~/workspaceでもなんでも。
<code>
$mkdir ~/workspace
</code>
次に、githubのプロジェクトをコピーします。
<code>
$cd ~/workspase
$git clone https://github.com/neonichu/BBUDebuggerTuckAway.git
</code>
gitが入ってない場合やめんどくさい場合はgithubのDownload ZIPからZIPファイルをダウンロードして解凍すればまあ同じことです。<a href="https://github.com/neonichu/BBUDebuggerTuckAway/archive/master.zip" target="_blank">ここからもダウンロードできます(Download ZIPへの直リンク)</a>
そしたらフォルダ内の.xcodeprojファイルを開いて……
[caption id="attachment_491" align="alignnone" width="798"]<a href="http://unasuke.com/wp/wp-content/uploads/2014/03/xcodeproj.jpg"><img src="http://unasuke.com/wp/wp-content/uploads/2014/03/xcodeproj.jpg" alt="これを開く" width="798" height="536" class="size-full wp-image-491" /></a> これを開く[/caption]
そしたらコンパイルしてXcodeを再起動すると……
<a href="http://unasuke.com/wp/wp-content/uploads/2014/03/7dd4c3f74f006b34bb1d70d7adebd54e.jpg"><img src="http://unasuke.com/wp/wp-content/uploads/2014/03/7dd4c3f74f006b34bb1d70d7adebd54e.jpg" alt="compile" width="974" height="562" class="alignnone size-full wp-image-492" /></a>
https://www.youtube.com/watch?v=rjygs4n6oIY
このように、入力開始とともにデバッグエリアが自動的に隠れます。
