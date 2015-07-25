---
title: ".vimrcのset nocompatibleのお話とごめんなさいな話"
date: '2014-07-19'
tags:
- howto
- vim
---

<h2>半ばおまじないと化したset nocompatible</h2>

.vimrcを書くときに、僕達初心者は色々なサイトを巡って「これが良さそうだな」とか「これはみんな書いてるから書いとこう」とか考えて、設定をちまちま書いていく。
そのなかで、この設定を書く人も多いだろう。

<pre class="font-size:17 line-height:19 lang:vim decode:true " >set nocompatible</pre>

このコマンドは、vi互換の動作を無効にするコマンドである。

<h2>vim-jp/issuesを巡っていて</h2>

さて、この設定について、こんなissueがあった。
<a href="https://github.com/vim-jp/issues/issues/471" target="_blank">compatible について解説したほうが良いか? #471</a>
それに関連する形で、このURLが張られている。(issue内URLはリンク切れのため同等記事掲載)
<a href="http://vim-jp.org/vim-users-jp/2010/10/28/Hack-179.html" target="_blank">Hack #179: ‘cpoptions’, ‘compatible’について知る</a>

どうやら、.vimrcが存在するする時点でnocompatibleが成されているのと同じらしい。それに、履歴が20まで削られちゃうっぽいし、消してもいいんじゃね。

<h2>謝罪</h2>

commit messageにissueへのURLを張ったら、本家issueへreferencedとして表示されてしまうようになりました。
GitHubのシステムについて無知な故、これによって迷惑をかけた方々がいらっしゃいましたら、深く謝罪します。
