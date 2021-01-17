---
title: "ElectronでPocketリーダーアプリを作っています"
date: 2021-01-17 22:14 JST
tags: 
- pocket
- electron
- programming
- javascript
- typescript
- react
---

![開発中のアプリのスクリーンショット](2021/pocket-client-app-screenshot.png)

## どんなものを作っているのか
Pocketというサービスをご存知でしょうか。あとで読みたい記事を保存しておけるサービスです。僕はこのサービスのヘビーユーザー[^heavy]で、Feedリーダーからほぼ毎日何かの記事を保存し、また保存しているリストから記事を読んでいます。

この、Pocketにストックしてある記事を手軽にサクサクと読んでいきたいと思い、手の配置を固定したままどんどんと記事を読んでいけるリーダーを作成しています。(右手で記事リストを移動、左手で記事ページをスクロール)

## 動機
このPocketですが、利用にあたってはiOSアプリ、Androidアプリ、macOSアプリ、公式Webアプリがあるものの、Windowsには公式のアプリが存在していません。FAQでも、"Under Consideration" のままずっとステータスが変化していません。またサードパーティー製のものも見付かりません。

Webアプリを使えば済む話ではありますが、Webでは記事を都度別タブで開いて読んだら閉じてアーカイブ、というのを繰り返す必要があり、だんだんと未読消化が億劫になってきます。

macアプリのようなものがWindowsにもあれば……というのが主な開発の動機です。

また、自分のスキルとして、JavaScriptでアプリケーションをイチから構築したことがなく、そのスキルを向上させたいという思い[^skill]もありました。

## 構成
electron-forgeから提供されている Webpack+TypeScript templateをベースに、React、Redux、Chakra UIを使用して開発しています。どれも仕事ではあまり触れたことがなく、探り探り実装を進めています。

- <https://www.electronforge.io>
- <https://reactjs.org>
- <https://redux.js.org>
- <https://chakra-ui.com>

## ベータテスター募集中

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">開発中のアプリのベータテスターを募集します！「あとで読む」の管理などにPocketを使っている方をお待ちしています～～～～<br><br>Pocketリーダーアプリのベータテスター募集！ | うなすけ <a href="https://twitter.com/yu_suke1994?ref_src=twsrc%5Etfw">@yu\_suke1994</a><br> <a href="https://t.co/EHMUPSyXft">https://t.co/EHMUPSyXft</a> <a href="https://twitter.com/hashtag/bosyu?src=hash&amp;ref_src=twsrc%5Etfw">#bosyu</a></p>&mdash; うなすけ (@yu\_suke1994) <a href="https://twitter.com/yu_suke1994/status/1347856483950620674?ref_src=twsrc%5Etfw">January 9, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

現時点で、本当に基本的な機能の実装は完了しています。今年中の正式公開を目指して、不具合の修正、完成度の向上を行っている途中です。あと数人ほどベータテスターを募集していますので、気になる方はよろしくお願いします。

[^heavy]: 2017年にPocketから読んだ記事数が全ユーザーのtop 1%以内に入ったというメールが来たくらいには。
[^skill]: [Railsを主戦場としている自分が今後学ぶべき技術について(随筆)](/2020/i-have-to-learn-those-things-in-the-future/)
