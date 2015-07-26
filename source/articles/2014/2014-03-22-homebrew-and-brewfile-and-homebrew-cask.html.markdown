---
title: Homebrewとbrewfileとhomebrew-caskでMacの環境構築
date: '2014-03-22'
tags:
- homebrew
- howto
- mac
- programming
- vim
---

![homebrew](homebrew-environment-setup.png)

## Homebrewとbrewfileとhomebrew-cask？

### Homebrewとは

[Homebrew](http://brew.sh/)
[パッケージ管理システム Homebrew](http://qiita.com/b4b4r07/items/6efebc2f3d1cbbd393fc)
以前、[OpenCVの導入](articles/2013/2013-05-26-opencv-testprogram-on-xcode)に使った[MacPorts](http://www.macports.org/)のようなまた別のパッケージ管理ソフト。MacPortsとは違い、依存関係をいちから導入するのではなく、元からインストールされているもので解決するためMacPortsより軽い……？

### brewfileとは

Homebrewのコマンドを羅列したテキストファイル。要するにシェルスクリプト。
[BrewfileでHomebrewパッケージを管理する](http://deeeet.com/writing/2013/12/23/brewfile/)

※__使えなくなります__(下記事参照) 2014-7-30追記
[Brewfileで管理するのはもうオワコン](articles/2014/2014-07-28-brewfile-is-outdated)

### homebrew-caskとは

[Homebrew Cask](http://caskroom.io/)
[phinze/homebrew-cask](https://github.com/phinze/homebrew-cask)
HomebrewをつかってChromeやVirtuaBoxなどのアプリケーションをインストールするための仕組み。
つまりは、これらでBoxenを置き換えることができる。

## 導入

### Boxenのアンインストール

```shell
$ script/nuke ---all ---force
```

このスクリプト、中身見れば分かるんだけどRubyで書かれてる。さらばBoxen。

### Homebrewのインストール

必要な物は

- Intel CPUのMac(OS X 10.5以上)
- XcodeとCommand Line Tools
- Java

Javaについては必須じゃないけど、それが必要なソフトをインストールするときに必要になる(あたりまえ)

#### XcodeとCommand Line Tools

XcodeはMac App Storeからインストールする。
Command Line ToolsはXcodeのPreferencesのDownloadsからインストール。
Mavericksの場合は

```shell
$ xcode-select --install
```

もしくは[Downloads for Apple Developers](https://developer.apple.com/downloads/index.action)から.dmgをダウンロードしてインストール。
その後、ライセンスに同意しておく。

```shell
$ sudo xcodebuild -license
```

#### Java

```shell
$ java -version
```

これで、Javaがインストールされていればバージョンが、インストールされていなければインストールを促すダイアログが出る。

#### Homebrew

[Homebrew](http://brew.sh/)の一番下のコマンドより、

```shell
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

を実行。なんて簡単なんだ。

### homebrew-caskのインストール

```shell
$ brew tap phinze/cask
$ brew install brew-cask
```

これでおしまい。もしくは、Brewfileに

```
tap phinze/homebrew-cask
install brew-cask
```

と記述して、同じディレクトリで

```shell
$ brew bundle
```

としても同じ。これがBrewfile。

#### homebrew-caskでインストールできるアプリケーション

[phinze/homebrew-cask/Casks](https://github.com/phinze/homebrew-cask/tree/master/Casks)
やたらある。MacPortsまである。

## インストール

とりあえず、自分がほしいものをいろいろ書いたBrewfileをつくった。
[unasuke/my-homebrew-setup](https://github.com/unasuke/my-homebrew-setup)

```shell
$ git clone https://github.com/unasuke/my-homebrew-setup.git
$ cd my-homebrew-setup
$ ./install.sh
$ brew bundle
```

これでHomebrewのインストールからhomebrew-caskの導入とインストールまでやってくれる。
install.sh内で`brew bundle`してもいいが、念のため`brew doctor`を挟んだ。`brew doctor`で指示されたことはやっておくこと。お医者さんの言いつけは守ろうね。

## 本末転倒

~~MacVim KaoriyaをsplhackさんのリポジトリにあるFormula[(splhack/homebrew-splhack)](https://github.com/splhack/homebrew-splhack)からビルドしようとしたけど、pythonのあたりでどうしてもこけるのでビルド済の.appをインストールするCasksを作っちゃいました。[unasuke/homebrew-unasuke](https://github.com/unasuke/homebrew-unasuke)
HomebrewでMacVim Kaoriyaがビルドできるようになったらリポジトリ消します。いや、消します。
ついでにビルドの仕方教えてください。~~
追記
tapするリポジトリをsupermomongaさんのforkの方にしたらビルドうまく行った。[(supermomonga/homebrew-splhack)](https://github.com/supermomonga/homebrew-splhack)
それに伴いBrewfileとかも書き換えた。
