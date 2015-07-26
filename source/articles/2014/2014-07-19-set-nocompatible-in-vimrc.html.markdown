---
title: ".vimrcのset nocompatibleのお話とごめんなさいな話"
date: '2014-07-19'
tags:
- howto
- vim
---

## 半ばおまじないと化したset nocompatible

.vimrcを書くときに、僕達初心者は色々なサイトを巡って「これが良さそうだな」とか「これはみんな書いてるから書いとこう」とか考えて、設定をちまちま書いていく。
そのなかで、この設定を書く人も多いだろう。

```vim
set nocompatible
```

このコマンドは、vi互換の動作を無効にするコマンドである。

## vim-jp/issuesを巡っていて

さて、この設定について、こんなissueがあった。
[compatible について解説したほうが良いか? #471](https://github.com/vim-jp/issues/issues/471)

それに関連する形で、このURLが張られている。(issue内URLはリンク切れのため同等記事掲載)
[vim-jp » Hack #179: ‘cpoptions’, ‘compatible’について知る](http://vim-jp.org/vim-users-jp/2010/10/28/Hack-179.html)

どうやら、.vimrcが存在するする時点でnocompatibleが成されているのと同じらしい。それに、履歴が20まで削られちゃうっぽいし、消してもいいんじゃね。

## 謝罪

commit messageにissueへのURLを張ったら、本家issueへreferencedとして表示されてしまうようになりました。
~~GitHubのシステムについて無知な故、これによって迷惑をかけた方々がいらっしゃいましたら、深く謝罪します。~~
そんな深刻な問題でもない気がしてきた。
