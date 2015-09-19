---
title: vimべんきょうにっき その2
date: '2015-07-12'
tags:
- diary
- programming
- vim
---

![vim logo](2015/vimlogo.png)

## dotfilesの整理から

ukstudio先輩のdotfile([ukstudio/dotfiles](https://github.com/ukstudio/dotfiles))見てたら、stowを使ってdotfileへのsymlinkを貼っていてマジヤベエって気持ちになって、とりあえずstowを使えるようにしました。([Using stow instead of shell script:c97f1f8](https://github.com/unasuke/dotfiles/commit/c97f1f896958367e70ecb2b24279bc550b339802))


## lightlineの設定を見直す

[atomに代わってvimをメインのエディタにしていく決意をした](2015/atom-plugin)ので、本格的に環境を整えていくことにします。これが今までのstatuslineです。
![以前のstatusline](2015/vim-stepup-lightline-01.png)

とりあえず作者さんの、[作者が教える！ lightline.vimの導入・設定方法！ 〜 初級編 - インストールしよう - プログラムモグモグ](http://itchyny.hatenablog.com/entry/20130828/1377653592)を参考にして、サクッとvimrcをコピペした結果がこちらになります。([Update lightline setting:c2461db](https://github.com/unasuke/dotfiles/commit/c2461db6332fa71be1d951694ab9fd056ea338d2))
![statusline変更後](2015/vim-stepup-lightline-02.png)

こちらからは以上です。


<small>あの……fugitive使って現在のbranchを表示させるのってどうやって……</small>
