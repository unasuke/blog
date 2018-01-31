---
title: "Windows 10に開発環境を構築する in 2018年1月"
date: 2018-01-31 21:00 JST
tags:
- windows
- ruby
- golang
- Programming
---

![Powershell on ConEmu](2018/conemu-powershell-example.png)

Windowsネイティブな開発環境があるとよさそうという気持ちになったので、構築してみることにした記録です。

## 前提条件
- cygwinを使わない
- なるべくWindowsネイティブになるようにする
- いきづまったらdockerやWSLを使う

という条件のもと、Windows 10上にRubyおよびGolangの開発環境を構築しました。

## PowerShell

なるべくネイティブ環境を目指すので、cmd.exeもしくはPowerShellを用いることになります。なので、PowerShellを使用しました。ただ、powershell.exeをそのまま使うのはちょっとつらいので、ターミナルエミュレーターからPowerShellを使用します。ConEmuやcmderなどがありますが、今回はConEmuを使うことにしました。

### ConEmuの設定
ConEmuでは、colorschemeとしてSolarized Darkを、PowerShellの起動オプションとして`-executionpolicy remotesigned`を追加しました。

![ConEmu PowerShell 起動オプション](2018/conemu-powershell-launchargs.png)
![ConEmu PowerShell colorscheme](2018/conemu-solarized.png)

#### 参考
[Windows 10の開発環境を整えた - YAMAGUCHI::weblog](http://ymotongpoo.hatenablog.com/entry/2017/01/05/101233)

## Chocolatey

LinuxでのaptやDNF、macOSでのhomebrewのようなパッケージマネージャーは開発には欠かせません。
Windowsで使用できるパッケージマネージャーといえばChocolateyなので、インストールしました。インストールにあたって、WMF経由ではなく、Chocolatey公式サイトの手順に従いました。

### 参考
- [PackageManagement コマンドレットPackageManagement Cmdlets | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/wmf/5.0/oneget_cmdlets)
- [Installation - https://chocolatey.org/install](https://chocolatey.org/install)

### とりあえずインストールしたパッケージ
- poshgit
  - [Git - Git in Powershell](https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Powershell)
  - [Chocolatey Gallery | posh-git 0.7.1](https://chocolatey.org/packages/poshgit/0.7.1)
- gnuwin32-make.portable
  - [Chocolatey Gallery | GnuWin32 make for Windows (Portable) 3.81](https://chocolatey.org/packages/gnuwin32-make.portable)
- gpg4win-vanilla
  - [Chocolatey Gallery | Gpg4win Vanilla 2.3.4.20170919](https://chocolatey.org/packages/gpg4win-vanilla)


## Rubyのインストール
Rubyは、RubyInstallerを用いてインストールしました。場所はデフォルトのC直下にしています。

[RubyInstaller for Windows](https://rubyinstaller.org/)

## uru

Rubyのバージョンを切り替えて使いたいとなっても、rbenvやrvmはPowerShellでは動作しません。なので、uruを使用してRubyのバージョンを切り替えることにします。

### インストール

1. [jonforums / uru / wiki / Downloads — Bitbucket](https://bitbucket.org/jonforums/uru/wiki/Downloads) よりnupkgをダウンロードする
1. PowerShellでnupkgをダウンロードしたディレクトリに移動する
1. `choco install uru.0.8.4.nupkg` を実行する

インストールが終了したあとは、`uru admin add C:\Ruby25-x64\bin --tag 2.5.0` などでuruにRubyを追加し、 `.ruby-version` のあるディレクトリで `uru auto` を実行するとRubyのversionが切り替わります。

### 参考
- [jonforums / uru — Bitbucket](https://bitbucket.org/jonforums/uru)
- [WindowsにおけるRubyやRailsの環境構築方法をいろいろ調べてみた（2017年3月版） - Qiita](https://qiita.com/jnchito/items/9de9e515f82dc1969cc5)
- [uru - Windows用のRuby環境セレクター | ソフトアンテナブログ](http://www.softantenna.com/wp/review/uru/)

## Golang
Golangも、Rubyと同様にインストーラ(msi)を用いてインストールしました。

[Downloads - The Go Programming Language](https://golang.org/dl/)

## 環境変数

また、環境変数として、以下の値を登録しました。

- $GOPATH `C:\Users\unasuke`
- $HOME `C:\Users\unasuke`
- $Path(追記) `C:\Users\unasuke\bin`

### 参考
- [SettingGOPATH · golang/go Wiki](https://github.com/golang/go/wiki/SettingGOPATH#windows)


## Docker for Windowsのインストール

公式のインストーラを使用することで、PowerShellからdockerを使用することができるようになりました。

[Docker Community Edition for Windows - Docker Store](https://store.docker.com/editions/community/docker-ce-desktop-windows)

## Windows Subsystem for Linuxのインストール

ChocolateyやDockerの環境を構築しても、どうしてもLinux環境がないとどうにもならないことがあるので、WSLのインストールも行ないます。

ちなみに、このブログを書くためのmiddlemanはWSL環境でしか動作しませんでした。

これに関しては、必要になったタイミングで使うという方針なので、あまり環境構築に手間をかけないことにしました。

### 参考
- [Windows 10のWindows Subsystem for Linux（WSL）を日常的に活用する - ククログ(2017-11-08)](http://www.clear-code.com/blog/2017/11/8.html)


## 参考サイト一覧
- [Windows 10の開発環境を整えた - YAMAGUCHI::weblog](http://ymotongpoo.hatenablog.com/entry/2017/01/05/101233)
- [PackageManagement コマンドレットPackageManagement Cmdlets | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/wmf/5.0/oneget_cmdlets)
- [Installation - https://chocolatey.org/install](https://chocolatey.org/install)
- [RubyInstaller for Windows](https://rubyinstaller.org/)
- [jonforums / uru — Bitbucket](https://bitbucket.org/jonforums/uru)
- [WindowsにおけるRubyやRailsの環境構築方法をいろいろ調べてみた（2017年3月版） - Qiita](https://qiita.com/jnchito/items/9de9e515f82dc1969cc5)
- [uru - Windows用のRuby環境セレクター | ソフトアンテナブログ](http://www.softantenna.com/wp/review/uru/)
- [Downloads - The Go Programming Language](https://golang.org/dl/)
- [SettingGOPATH · golang/go Wiki](https://github.com/golang/go/wiki/SettingGOPATH#windows)
- [Docker Community Edition for Windows - Docker Store](https://store.docker.com/editions/community/docker-ce-desktop-windows)
- [Windows 10のWindows Subsystem for Linux（WSL）を日常的に活用する - ククログ(2017-11-08)](http://www.clear-code.com/blog/2017/11/8.html)
- [Git - Git in Powershell](https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Powershell)
- [Git - PowershellでGitを使う](https://git-scm.com/book/ja/v2/Appendix-A%3A-%E3%81%9D%E3%81%AE%E4%BB%96%E3%81%AE%E7%92%B0%E5%A2%83%E3%81%A7%E3%81%AEGit-Powershell%E3%81%A7Git%E3%82%92%E4%BD%BF%E3%81%86)
- [なぜ、PowerShellを使うのか？ - Qiita](https://qiita.com/lldev2/items/5e37d67d180faf36afdd)


## 当初はMSYS2でいくつもりだった
最初はMSYS2でやっていくつもりだったのですが、Docker for Windowsを入れたタイミングで`docker`コマンドがMSYS2で入れたzshから使用できなかった(PATHが通ってなかっただけ？)のでエイヤでPowerShellに切り替えました。

### MSYS2の環境構築で参考にしたサイト一覧
- [Windows10の開発環境をMSYS2で再構築 - Qiita](https://qiita.com/azk0305/items/a546da060f3ab8d6a8bf)
- [Windows7からGitHubへSSH接続する手順(プロキシ環境有) - Qiita](https://qiita.com/busonx/items/2efc10a18d7a46f14555)
- [msys2での$HOMEとOpenSSHでのホームディレクトリの違い - Qiita](https://qiita.com/nana4gonta/items/622571c66bfe7f1c7150)
- [MSYS2 による gcc 開発環境の構築 - Qiita](https://qiita.com/spiegel-im-spiegel/items/ba4e8d2418bdfe0c8049)
- [MSYS2で快適なターミナル生活 - Qiita](https://qiita.com/Ted-HM/items/4f2feb9fdacb6c72083c)
- [Home · msys2/msys2 Wiki](https://github.com/msys2/msys2/wiki)
- [Windowsで使えるターミナルとシェルのまとめ - Qiita](https://qiita.com/Ted-HM/items/9a60f6fcf74bbd79a904)
- [Windows 10 にアップデートしたので、開発環境を再構築しました - 破棄されたブログ](http://hateda.hatenadiary.jp/entry/win-10-devenv)
- [Windowsでもコマンドしたい！ConEmuとMSYS2を入れてみよう | コはコンピューターのコ](https://tech.matchy.net/archives/963)
