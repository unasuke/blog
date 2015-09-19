---
title: vimべんきょうにっき その1
date: '2015-06-14'
tags:
- diary
- programming
- vim
---

![vim logo](2015/vimlogo.png)

## きっかけ

<blockquote class="twitter-tweet" lang="ja"><p lang="ja" dir="ltr">あこがれの先輩とペアでvimの練習とかしてた</p>&mdash; うなすけ(偏差値5) (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/status/609344859283980288">2015, 6月 12</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

## べんきょう
### Vim plugin

新しくNERDTree([scrooloose/nerdtree](https://github.com/scrooloose/nerdtree))と、vim-slim([slim-template/vim-slim](https://github.com/slim-template/vim-slim))と、vimshell.vim([Shougo/vimshell.vim](https://github.com/Shougo/vimshell.vim))をインストールした。


NERDTreeの設定も先輩のからもってきて、space+eで開閉できるようにした。
 
```vim
nmap <silent> <Space>e :NERDTreeToggle<CR>

autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

let g:NERDTreeShowHidden=1
```



また、インストールしたきり設定が書いてないneocompleteの設定も行った。


他にも、ウィンドウ分割の方法など教えて頂いた。


## まとめ

ペアvim前 .vimrc
 
```vim
"neobundle.vimの設定
if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

"install plugins
NeoBundle 'Shougo/vimproc.vim', {
	\ 'build' : {
	\	'windows' : 'make -f make_mingw32.mak',
	\	'cygwin' : 'make -f make_cygwin.mak',
	\	'mac' : 'make -f make_mac.mak',
	\	'unix' : 'make -f make_unix.mak',
	\	},
	\}

NeoBundle 'Shougo/unite.vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'wakatime/vim-wakatime'

call neobundle#end()
NeoBundleCheck

"help language use Japanese
set helplang=ja,en

"vimを使ってくれてありがとう!!!!!!!!!!
set notitle

"Ricty
set guifont=Ricty\ 11

"use UTF-8
set encoding=UTF-8

"syntax
syntax on

"line number
set number

"indent setting
set autoindent
set smartindent
filetype plugin indent on

"no more swapfile
set noswapfile
set nobackup

"status line setting
set laststatus=2
let g:lightline = {
	\ 'colorscheme' : 'solarized' ,
	\}

"colorscheme setting
set t_Co=256
set background=dark
colorscheme solarized

"convert file encode
function SetUU()
	set ff=unix
	set fenc=utf8
endfunction
command -nargs=0 SetUU call SetUU()

"use backspace
set backspace=indent,eol,start
```


ペアvim後 .vimrc
```vim
"neobundle.vimの設定
if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

"install plugins
NeoBundle 'Shougo/vimproc.vim', {
	\ 'build' : {
	\	'windows' : 'make -f make_mingw32.mak',
	\	'cygwin' : 'make -f make_cygwin.mak',
	\	'mac' : 'make -f make_mac.mak',
	\	'unix' : 'make -f make_unix.mak',
	\	},
	\}

NeoBundle 'Shougo/unite.vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'wakatime/vim-wakatime'
NeoBundle 'slim-template/vim-slim'
NeoBundle 'scrooloose/nerdtree' 
NeoBundle 'Shougo/vimshell.vim'

call neobundle#end()
NeoBundleCheck

"help language use Japanese
set helplang=ja,en

"vimを使ってくれてありがとう!!!!!!!!!!
set notitle

"Ricty(only gvim?)
set guifont=Ricty:h16

"use UTF-8
set encoding=UTF-8

"syntax
syntax on

"line number
set number

"indent setting
set autoindent
set smartindent
filetype plugin indent on
set expandtab
set shiftwidth=2
set softtabstop=2

"no more swapfile
set noswapfile
set nobackup

"status line setting
set laststatus=2
let g:lightline = {
	\ 'colorscheme' : 'solarized' ,
	\}

"colorscheme setting
set t_Co=256
set background=dark
colorscheme solarized

"convert file encode
function SetUU()
  set ff=unix
  set fenc=utf8
endfunction
command -nargs=0 SetUU call SetUU()

"use backspace
set backspace=indent,eol,start

"Neocomplete
source ~/.neocomplete.vim

"NerdTree
source ~/.nerdtree.vim
```


当該コミット
[github.com/unasuke/dotfiles pair vim lesson](https://github.com/unasuke/dotfiles/commit/5cae399797e8e2d71abb0af7d98da24c88d343e4)
