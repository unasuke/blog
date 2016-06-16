---
title: '開発環境 2016年6月時点'
date: 2016-06-16 16:19 JST
tags:
- diary
- Programming
---

![termのスクショ](2016/development-environment-term-screen.png)

## 会社ブログに書きました
[spicelifeのエンジニアは、どんな開発環境で仕事をしているの？ - スパイスな人生](http://blog.spicelife.jp/entry/2016/06/16/152330)を書きました。

自分のことについてはあまり深く突っ込んで書いていないので、ここで詳細を書くことにします。

これ以降はOS Xについて主に書いていきます。なぜならwindowsを持っていないからです。linuxは常用する暇がなくなったからです。

## shell
iTerm2の上でzshが動き、その上でtmuxを起動してワイワイやっています。colorschemeはsolarizedです。

登録しているaliasesは、現時点では以下のとおりです。

[dotfiles/aliases.zsh at 285a411b96 · unasuke/dotfiles](https://github.com/unasuke/dotfiles/blob/285a411b9644231c01e733ac2f1e1d0900415bbe/zsh/.zsh.d/aliases.zsh)

```zsh
#alias
#ls
alias la='ls -alGh'
alias ll='ls -lGh'

#git
alias g='git'
compdef g=git

#peco
#cd repository
alias e='cd $(ghq list -p | peco)'

#bundler
alias bi='bundle install'
alias be='bundle exec'

#vim
alias vi='vim'
```

## editor
主にvimを使っていますが、ごくたまにatomを起動し、ちょちょっとしたメモが欲しい時はCotEditorを使います。

### vim

vimのプラグイン管理は[Shougo/neobundle.vim](https://github.com/Shougo/neobundle.vim)[Shougo/dein.vim](https://github.com/Shougo/dein.vim)に乗り換えました。

よく使うプラグインは[scrooloose/nerdtree](https://github.com/scrooloose/nerdtree)で、`space`+`e`で開閉するようにしています。
あと、[ctrlpvim/ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim)がインストールされていることをよく忘れます。

他によく使うキーバインドは、`space`+`t`で`:tabnew`で、`space`+`j`と`space`+`l`でタブの移動をしています。

ウィンドウの分割は、vimで行うよりはtmuxで分割することにしています。理由は特に無いです。

### atom
vim-modeで使っています。特筆することはないです。有名ドコロのpackageは一通り入っていると思います。

## git
抜粋してこんな感じです。

[dotfiles/.gitconfig at 285a411b96 · unasuke/dotfiles](https://github.com/unasuke/dotfiles/blob/285a411b9644231c01e733ac2f1e1d0900415bbe/git/.gitconfig)

```
[color]
  ui = true
[push]
  default = simple
[core]
  excludesfile = ~/.gitignore_global
  precomposeunicode = true
  quotepath = false
[ghq]
  root = ~/src
[alias]
  s = status
  sh = stash
  shu = stash -u
  shp = stash pop
  c = commit -v
  l = log --oneline --decorate --color --graph
  l = log --oneline --decorate --color --graph --all
  pl = pull
  ps = push
  ch = checkout
  chb = checkout -b
  ad = add
  d = diff
  dc = diff --cached
  fe = fetch --prune
  me = merge
  miku = !git stash 1> /dev/null && echo 'もうしょうがないにゃぁ、この変更はみくが覚えておくにゃ！'
  g = grep
  branches = branch -a
  tags = tag
  stashes = stash list
  unstage = reset -q HEAD --
  discard = checkout --
  uncommit = reset --mixed HEAD~
  amend = commit --amend -v
[rebase]
  autostash = true
[stash]
  showPatch = true
[diff]
  algorithm = patience
  compactionHeuristic = true
[pager]
  log = diff-highlight | less
  show = diff-highlight | less
  diff = diff-highlight | less
[interactive]
  diffFilter = diff-highlight
```

よく使うaliasは`s`、`sh`、`c`、`ch`、`ad`ですね。最近、[人間らしいGitのエイリアス | プログラミング | POSTD](http://postd.cc/human-git-aliases/)からいくつか拝借しました。

## ruby
[rbenv/rbenv-default-gems](https://github.com/rbenv/rbenv-default-gems)を入れて、よく使うrubygemsはrubyをインストールした時に同時に入るよう設定しています。
あと、[amatsuda/gem-src](https://github.com/amatsuda/gem-src)を使って、rubygemsのソースを同時に`git clone`するようにしています。

## ghq
ソースコードの管理は[motemen/ghq](https://github.com/motemen/ghq)で行っています。上のgem-srcもghqを使用して、いい感じのディレクトリにcloneするよう設定しています。

ディレクトリの移動は[peco/peco](https://github.com/peco/peco)による絞込で行っています。

## 物理環境 at 会社
<iframe src="http://rcm-fe.amazon-adsystem.com/e/cm?lt1=_blank&bc1=FFFFFF&IS2=1&bg1=FFFFFF&fc1=000000&lc1=0000FF&t=yusuke199403-22&o=9&p=8&l=as4&m=amazon&f=ifr&ref=ss_til&asins=B000HCPX58" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>

これを机に設置すると無限に便利です。

![卓上コンセント](2016/development-environment-outlet.jpg)

### macのACアダプタの巻き方
macのACアダプタには、「どうぞここにコードを巻き付けてください」と言わんばかりの部位があるけれど、あそこに巻きつけているとコードの癖がひどいし、断線もしやすくなると思うのです。(主観)

なので、僕はこう巻きます。

![ACアダプタとコード](2016/development-environment-mac-ac-adapter.jpg)
