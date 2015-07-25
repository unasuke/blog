---
title: vimべんきょうにっき その2
date: '2015-07-12'
tags:
- diary
- programming
- vim
---

<a href="http://unasuke.com/wp/wp-content/uploads/2015/06/vimlogo-564x564.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/06/vimlogo-564x564.png" alt="vim" width="400" height="400" class="alignnone size-full wp-image-1181" /></a>
<h2>dotfilesの整理から</h2>
<p>
    ukstudio先輩のdotfile(<a href="https://github.com/ukstudio/dotfiles">ukstudio/dotfiles</a>)見てたら、stowを使ってdotfileへのsymlinkを貼っていてマジヤベエって気持ちになって、とりあえずstowを使えるようにしました。(<a href="https://github.com/unasuke/dotfiles/commit/c97f1f896958367e70ecb2b24279bc550b339802">Using stow instead of shell script:c97f1f8</a>)
</p>

<h2>lightlineの設定を見直す</h2>
<p>
    <a href="http://unasuke.com/diary/2015/do-not-use-atom-is-atom-plugin/">atomに代わってvimをメインのエディタにしていく決意をした</a>ので、本格的に環境を整えていくことにします。これが今までのstatuslineです。<a href="http://unasuke.com/wp/wp-content/uploads/2015/07/1__tmux.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/07/1__tmux-1024x27.png" alt="以前のstatusline" width="625" height="16" class="alignnone size-large wp-image-1246" /></a>
</p>
<p>
とりあえず作者さんの、<a href="http://itchyny.hatenablog.com/entry/20130828/1377653592">作者が教える！ lightline.vimの導入・設定方法！ 〜 初級編 - インストールしよう - プログラムモグモグ</a>を参考にして、サクッとvimrcをコピペした結果がこちらになります。(<a href="https://github.com/unasuke/dotfiles/commit/c2461db6332fa71be1d951694ab9fd056ea338d2">Update lightline setting:c2461db</a>)<a href="http://unasuke.com/wp/wp-content/uploads/2015/07/1__tmux1.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/07/1__tmux1-1024x25.png" alt="statusline変更後" width="625" height="15" class="alignnone size-large wp-image-1248" /></a>
</p>
<p>
    こちらからは以上です。
</p>
<p>
    <small>あの……fugitive使って現在のbranchを表示させるのってどうやって……</small>
</p>
