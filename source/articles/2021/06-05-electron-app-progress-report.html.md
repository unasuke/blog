---
title: "Electronで作っているPocketリーダーアプリの近況報告"
date: 2021-06-05 22:07 JST
tags: 
- pocket
- electron
- programming
- javascript
- typescript
- react
---

![screenshot](2021/getlight_screenshot.png)

## 何

[ElectronでPocketリーダーアプリを作っています | うなすけとあれこれ](/2021/pocket-client-app-using-electron-in-development/)

PocketのリーダーアプリをElectronで開発しています。 commit logを見返すと昨年11月頃から開発を進めており、bosyuでベータテスターとして何名かの方々に試してもらってからは、2週間くらいに1度の頻度リリースを行っており、現在 v0.16.0 になっています。


<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">開発中のアプリのベータテスターを募集します！「あとで読む」の管理などにPocketを使っている方をお待ちしています～～～～<br><br>Pocketリーダーアプリのベータテスター募集！ | うなすけ <a href="https://twitter.com/yu_suke1994?ref_src=twsrc%5Etfw">@yu\_suke1994</a><br> <a href="https://t.co/EHMUPSyXft">https://t.co/EHMUPSyXft</a> <a href="https://twitter.com/hashtag/bosyu?src=hash&amp;ref_src=twsrc%5Etfw">#bosyu</a></p>&mdash; うなすけ (@yu\_suke1994) <a href="https://twitter.com/yu_suke1994/status/1347856483950620674?ref_src=twsrc%5Etfw">January 9, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

アプリ自体は、Pocketに保存している、あとで読むための記事をサクサクと読んでいくことにフォーカスしています。キーボードのみで記事リストを上下、アーカイブし、マウスで記事そのもののスクロールができるようになっています。具体的にどのようなものかは、以下の動画で大体掴めると思います。

<iframe width="560" height="315" src="https://www.youtube.com/embed/97n1HQ8TCyA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


さてbosyuがサービスをクローズするということになったので、このタイミングで進捗報告を兼ね、Discordに移行することにしました。以下から参加することができます。

<https://discord.gg/5jjPx26x25>

bosyuがやりとりが2週間途絶えるとやりとりができなくなる仕様ということもあり、それが締め切りの役割となってこれまでリリースを重ねてこれた部分があると思っています。それがDiscordに移行してその制限がなくなったときに、同じようなペースでリリースをできるかどうかはちょっとわかりません。

そしてゆくゆくは何らかの形で有料化するつもりでいます。とはいえ、試しに触ってもらってお金を払うに値するかどうか決められるようになっていて欲しく、そして一体何を課金要素とするのかについては何も考えられていません。

## electron-jp

少し話がずれるのですが、electon-jpというSlackがあり、一時期は盛り上がっていたのですが、今ではただのRSS feedが流れるだけの場所になってしまっており、悲しみを感じています。ぽつぽつでもいいから、また人々の交流する場になってほしいと思っています。
