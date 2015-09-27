---
title: vim-gnomeとvim-gtkの違い
date: '2014-02-24'
tags:
- info
- linux
- ubuntu
- vim
---

![vimの種類](2014/vim-kind.png)
vimが入っていないと、このようにインストールを促される。
これらのvimの違いはなんだろうか？

## vim

vim。

## vim-nox
GUIのないvim。今欲しいのはこれじゃない。

## vim-tiny

コンパクトなvim。これも今欲しいものじゃない。ってかubuntu系ならデフォで入ってる。

## vim-athena

![vim-athena](2014/vim-athena.png)
ちょっとお引き取り願えますか。

## vim-gnome

![vim-gnome](2014/vim-gnome.png)
うん。これが欲しかったんだ。

## vim-gtk

![vim-gtk](2014/vim-gtk.png)
えっ、さっきのと何が違うん？

## vim-gnomeとvim-gtkの違い

apt-cacheでそれぞれの違いを見てみよう。(少し整形)
vim-gnome

> Package: vim-gnome
> Priority: extra
> Section: editors
> Installed-Size: 2530
> Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
> Original-Maintainer: Debian Vim Maintainers <pkg-vim-maintainers@lists.alioth.debian.org>
> Architecture: amd64
> Source: vim
> Version: 2:7.4.000-1ubuntu2
> Provides: editor, gvim, vim, vim-lua, vim-perl, vim-python, vim-ruby, vim-tcl
> Depends: vim-gui-common (= 2:7.4.000-1ubuntu2),
> vim-common (= 2:7.4.000-1ubuntu2),
> vim-runtime (= 2:7.4.000-1ubuntu2),
> libacl1 (>= 2.2.51-8),
> libbonoboui2-0 (>= 2.15.1),
> libc6 (>= 2.15),
> libgdk-pixbuf2.0-0 (>= 2.22.0),
> libglib2.0-0 (>= 2.12.0),
> libgnome2-0 (>= 2.17.3),
> libgnomeui-0 (>= 2.22.0),
> libgpm2 (>= 1.20.4),
> libgtk2.0-0 (>= 2.24.0),
> libice6 (>= 1:1.0.0),
> liblua5.2-0,
> libpango-1.0-0 (>= 1.14.0),
> libperl5.14 (>= 5.14.2),
> libpython2.7 (>= 2.7),
> libruby1.9.1 (>= 1.9.2.0),
> libselinux1 (>= 1.32),
> libsm6,
> libtinfo5,
> libx11-6,
> libxt6,
> tcl8.5 (>= 8.5.0)
> Suggests: cscope, vim-doc, ttf-dejavu, gnome-icon-theme
> Filename: pool/main/v/vim/vim-gnome_7.4.000-1ubuntu2_amd64.deb
> Size: 1084468
> MD5sum: b6989046fc1929c55752133fc2f58417
> SHA1: 776f256a6b7c2cb88d737e2006f4056456ca6266
> SHA256: fd6f7bed4bfdaa13be8b24d3b738f309efb72b93818afd0effa047cc1530ec14
> Description-ja: Vi IMproved - enhanced vi editor - with GNOME2 GUI
>  Vim は、UNIX エディタ Vi のほぼ互換版です。
>  .
>  多くの新機能が追加されています: 多レベル undo、文法強調、コマンドライン
>  履歴、オンラインヘルプ、ファイル名補完、ブロック操作、畳み込み、Unicode 対応など。
>  .
>  This package contains a version of vim compiled with a GNOME2 GUI and
>  support for scripting with Lua, Perl, Python, Ruby, and Tcl.
> Description-md5: cd4a76134bce59404c52749b68c94208
> Homepage: http://www.vim.org/
> Description-md5: cd4a76134bce59404c52749b68c94208
> Bugs: https://bugs.launchpad.net/ubuntu/+filebug
> Origin: Ubuntu
> Supported: 9m

vim-gtk

> Package: vim-gtk
> Priority: extra
> Section: universe/editors
> Installed-Size: 2526
> Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
> Original-Maintainer: Debian Vim Maintainers <pkg-vim-maintainers@lists.alioth.debian.org>
> Architecture: amd64
> Source: vim
> Version: 2:7.4.000-1ubuntu2
> Provides: editor, gvim, vim, vim-lua, vim-perl, vim-python, vim-ruby, vim-tcl
> Depends: vim-gui-common (= 2:7.4.000-1ubuntu2),
> vim-common (= 2:7.4.000-1ubuntu2),
> vim-runtime (= 2:7.4.000-1ubuntu2),
> libacl1 (>= 2.2.51-8),
> libc6 (>= 2.15),
> libgdk-pixbuf2.0-0 (>= 2.22.0),
> libglib2.0-0 (>= 2.12.0),
> libgpm2 (>= 1.20.4),
> libgtk2.0-0 (>= 2.24.0),
> libice6 (>= 1:1.0.0),
> liblua5.2-0,
> libpango-1.0-0 (>= 1.14.0),
> libperl5.14 (>= 5.14.2),
> libpython2.7 (>= 2.7),
> libruby1.9.1 (>= 1.9.2.0),
> libselinux1 (>= 1.32),
> libsm6,
> libtinfo5,
> libx11-6,
> libxt6,
> tcl8.5 (>= 8.5.0)
> Suggests: cscope, vim-doc, ttf-dejavu, gnome-icon-theme
> Filename: pool/universe/v/vim/vim-gtk_7.4.000-1ubuntu2_amd64.deb
> Size: 1084618
> MD5sum: 5a27b6e1f70a2848a0787e81d89fa57c
> SHA1: cbe534640d1977e77874776b92f1be93125019b1
> SHA256: cfcb6c33b3dfa119d7fdc79a9397cb0493b172fc4748e280c28b840616a9dd4a
> Description-ja: Vi IMproved - 強化版 vim エディタ - GTK2 GUI 付き
>  Vim は、UNIX エディタの Vi とほぼ互換のバージョンのエディタです。
>  .
>  多くの新機能が追加されています: 複数回のアンドゥ、構文の強調、コマンド ライン履歴、オンラインヘルプ、ファイル名補完、ブロック操作、畳み込み、
>  Unicode 対応など。
>  .
>  本パッケージには GTK2 GUI と、Lua や Perl、Python、Ruby、Tcl でのスクリプ
>  ティングのサポート付きでコンパイルされたバージョンの vim が含まれます。
> Description-md5: 2c68094b1efcc4728d91370c494d0111
> Homepage: http://www.vim.org/
> Description-md5: 2c68094b1efcc4728d91370c494d0111
> Bugs: https://bugs.launchpad.net/ubuntu/+filebug
> Origin: Ubuntu

よく見ないとわからないが、依存するライブラリで差が生まれている。
vim-gnomeのほうが依存するライブラリが多く、__libbonoboui2-0__ と __libgnome2-0__ と __ibgnomeui2-0__ がvim-gtkで必要なライブラリに加えてインストールされる。
(どれもGNOME関係のライブラリ)

## どっちがいいのか

KDEやxfceなどのgnome以外のウィンドウマネージャを使っているならvim-gtk
gnome系ならどちらでもいい
……と思う。僕はvim-gtkにした。
