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

<a href="http://unasuke.com/wp/wp-content/uploads/2014/03/Untitled.png"><img src="http://unasuke.com/wp/wp-content/uploads/2014/03/Untitled.png" alt="Homebrew" width="600" height="380" class="alignnone size-full wp-image-562" /></a>

<h2>Homebrewとbrewfileとhomebrew-cask？</h2>

<h3>Homebrewとは</h3>

<a href="http://brew.sh/">Homewbrew</a>
<a href="http://qiita.com/b4b4r07/items/6efebc2f3d1cbbd393fc">パッケージ管理システム Homebrew</a>
以前、<a href="http://unasuke.com/howto/2013/opencv-testprogram-on-xcode/">OpenCVの導入</a>に使った<a href="http://www.macports.org/">MacPorts</a>のようなまた別のパッケージ管理ソフト。MacPortsとは違い、依存関係をいちから導入するのではなく、元からインストールされているもので解決するためMacPortsより軽い……？

<h3>brewfileとは</h3>

Homebrewのコマンドを羅列したテキストファイル。要するにシェルスクリプト。
<a href="http://deeeet.com/writing/2013/12/23/brewfile/">BrewfileでHomebrewパッケージを管理する</a>
<del datetime="2014-12-31T23:54:21+00:00">tcnksm/dotfiles/Brewfile上の記事を書いた<a href="https://twitter.com/deeeet">@deeeet</a>さんのbrewfile</del>

※<strong>使えなくなります</strong>(下記事参照) 2014-7-30追記
<a href="http://unasuke.com/info/2014/brewfile-is-outdated/" title="Brewfileで管理するのはもうオワコン" target="_blank">Brewfileで管理するのはもうオワコン</a>

<h3>homebrew-caskとは</h3>

<a href="http://caskroom.io/">Homebrew Cask</a>
<a href="https://github.com/phinze/homebrew-cask">phinze / homebrew-cask</a>
HomebrewをつかってChromeやVirtuaBoxなどのアプリケーションをインストールするための仕組み。
つまりは、これらでBoxenを置き換えることができる。

<h2>導入</h2>

<h3>Boxenのアンインストール</h3>

<pre class="lang:sh decode:true " >$ script/nuke ---all ---force</pre>

このスクリプト、中身見れば分かるんだけどRubyで書かれてる。さらばBoxen。

<h3>Homebrewのインストール</h3>

必要な物は

<ul>
<li>Intel CPUのMac(OS X 10.5以上)</li>
<li>XcodeとCommand Line Tools</li>
<li>Java</li>
</ul>

Javaについては必須じゃないけど、それが必要なソフトをインストールするときに必要になる(あたりまえ)

<h4>XcodeとCommand Line Tools</h4>

XcodeはMac App Storeからインストールする。
Command Line ToolsはXcodeのPreferencesのDownloadsからインストール。
Mavericksの場合は

<pre class="lang:sh decode:true " >$ xcode-select --install</pre>

もしくは<a href="https://developer.apple.com/downloads/index.action">Downloads for Apple Developers</a>から.dmgをダウンロードしてインストール。
その後、ライセンスに同意しておく。

<pre class="lang:sh decode:true " >$ sudo xcodebuild -license</pre>

<h4>Java</h4>

<pre class="lang:sh decode:true " >$ java -version</pre>

これで、Javaがインストールされていればバージョンが、インストールされていなければインストールを促すダイアログが出る。

<h4>Homebrew</h4>

<a href="http://brew.sh/">Homwbrew</a>の一番下のコマンドより、

<pre class="lang:sh decode:true " >$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"</pre>

を実行。なんて簡単なんだ。

<h3>homebrew-caskのインストール</h3>

<pre class="lang:sh decode:true " >$ brew tap phinze/cask
$ brew install brew-cask</pre>

これでおしまい。もしくは、Brewfileに

<pre class="lang:sh decode:true " >tap phinze/homebrew-cask
install brew-cask</pre>

と記述して、同じディレクトリで

<pre class="lang:sh decode:true " >$ brew bundle</pre>

としても同じ。これがBrewfile。

<h4>homebrew-caskでインストールできるアプリケーション</h4>

<a href="https://github.com/phinze/homebrew-cask/tree/master/Casks">phinze/homebrew-cask/Casks</a><br/>
やたらある。MacPortsまである。

<h2>インストール</h2>

とりあえず、自分がほしいものをいろいろ書いたBrewfileをつくった。
<a href="https://github.com/unasuke/my-homebrew-setup">unasuke/my-homebrew-setup</a></p>

<pre class="lang:sh decode:true " >
$ git clone https://github.com/unasuke/my-homebrew-setup.git
$ cd my-homebrew-setup
$ ./install.sh
$ brew bundle
</pre>

これでHomebrewのインストールからhomebrew-caskの導入とインストールまでやってくれる。
install.sh内で<code>brew bundle</code>してもいいが、念のため<code>brew doctor</code>を挟んだ。<code>brew doctor</code>で指示されたことはやっておくこと。お医者さんの言いつけは守ろうね。

<h2>本末転倒</h2>

<del datetime="2014-03-23T23:40:40+00:00">MacVim KaoriyaをsplhackさんのリポジトリにあるFormula<a href="https://github.com/splhack/homebrew-splhack">(splhack/homebrew-splhack)</a>からビルドしようとしたけど、pythonのあたりでどうしてもこけるのでビルド済の.appをインストールするCasksを作っちゃいました。<a href="https://github.com/unasuke/homebrew-unasuke">unasuke/homebrew-unasuke</a>
HomebrewでMacVim Kaoriyaがビルドできるようになったらリポジトリ消します。いや、消します。
ついでにビルドの仕方教えてください。</del>
追記
tapするリポジトリをsupermomongaさんのforkの方にしたらビルドうまく行った。<a href="https://github.com/supermomonga/homebrew-splhack" target="_blank">(supermomonga/homebrew-splhack)</a>
それに伴いBrewfileとかも書き換えた。
