---
title: Macでpkgからインストールしたアプリケーションを削除するpkgUninstallerを作りました
date: '2014-03-13'
tags:
- howto
- mac
- programming
- ruby
---

![pkgUninstaller](2014/pkguninstaller.png)

## pkgからのインストール

Macでpkgからアプリケーションのインストールをした時に、アンインストーラがついてくるものとついてこないものがあります。
ただ.appを削除すればいいというものではなく、他のディレクトリにもいろいろインストールしてくれるので不要なファイルが残ります。

## pkgutil

pkgutilコマンドを使えば、そのアプリケーションがどのようなファイルをどこにインストールしたのかがわかります。アンインストールするコマンドオプションもあったようですが、現在は削除されています。
参考:[新・OS X ハッキング! (94) pkgutilでインストーラパッケージを削除する   マイナビニュース](http://news.mynavi.jp/column/osxhack/094/)

## pkgUninstaller

上リンクでもスクリプトを用いてアプリケーションのアンインストールを行う方法を解説してはいますが、見る限りどうも怪しいです。
そこで、Rubyの勉強も兼ねて、pkgからインストールしたアプリケーションのアンインストールを行うpkgUninstaller.rbを作りました。
[unasuke/pkgUninstaller](https://github.com/unasuke/pkgUninstaller)

## 使い方

__こちらでも動作のテストはしていますが、予期せぬシステムの破損やデータの消去が発生する可能性があります。実行は自己責任でお願いします。__
まず、-sコマンドを用いてアンインストールするパッケージのIDを探します。部分一致で判定するので、メーカー名やアプリケーション名(アルファベット)を入力して下さい。
例

```shell
$ ruby pkgUninstaller.rb -s goo
shell(#<Th:0x007fcf090bc8b0>): /usr/sbin/pkgutil --pkgs
com.google.pkg.GoogleJapaneseInput
com.google.pkg.GoogleVoiceAndVideo
com.google.pkg.Keystone
```

お目当てのパッケージIDが見つかったら、-uコマンドでアンインストールを行います。まずは、--noopもつけて、実際にどのようなファイルやディレクトリが削除されようとしているのかを確認して下さい。
例

```shell
$ ruby pkgUninstaller.rb -u com.google.pkg.GoogleJapaneseInput -n
delete /Library/Input Methods/GoogleJapaneseInput.app/Contents/Resources/GoogleJapaneseInputConverter.app/Contents/Frameworks/GoogleBreakpad.framework/Versions/A/Resources/Reporter.app/Contents/Resources/English.lproj/Localizable.strings
delete /Library/Input Methods/GoogleJapaneseInput.app/Contents/Resources/GoogleJapaneseInputRenderer.app/Contents/Frameworks/GoogleBreakpad.framework/Versions/A/Resources/Reporter.app/Contents/Resources/English.lproj/Localizable.strings
delete /Library/Input Methods/GoogleJapaneseInput.app/Contents/Resources/GoogleJapaneseInputTool.app/Contents/Frameworks/GoogleBreakpad.framework/Versions/A/Resources/Reporter.app/Contents/Resources/English.lproj/Localizable.strings
delete /Library/Input Methods/GoogleJapaneseInput.app/Contents/Resources/GoogleJapaneseInputConverter.app/Contents/Frameworks/GoogleBreakpad.framework/Versions/A/Resources/Reporter.app/Contents/Resources/English.lproj/Breakpad.nib
delete /Library/Input Methods/GoogleJapaneseInput.app/Contents/Resources/GoogleJapaneseInputRenderer.app/Contents/Frameworks/GoogleBreakpad.framework/Versions/A/Resources/Reporter.app/Contents/Resources/English.lproj/Breakpad.nib
delete /Library/Input Methods/GoogleJapaneseInput.app/Contents/Resources/GoogleJapaneseInputTool.app/Contents/Frameworks/GoogleBreakpad.framework/Versions/A/Resources/Reporter.app/Contents/Resources/English.lproj/Breakpad.nib
delete /Library/Input Methods/GoogleJapaneseInput.app/Contents/Resources/GoogleJapaneseInputConverter.app/Contents/Frameworks/GoogleBreakpad.framework/Versions/A/Resources/Reporter.app/Contents/Resources/ReporterIcon.icns
中略
delete /Applications/GoogleJapaneseInput.localized
/Applications/GoogleJapaneseInput.localized is not empty.
delete /Library/Input Methods
/Library/Input Methods is not empty.
delete /Library/LaunchAgents
/Library/LaunchAgents is not empty.
delete /Applications
/Applications is not empty.
delete /Library
/Library is not empty.
160 files and 0 directories deleted.
```

ほにゃららis not empty.と書かれているディレクトリは、中身が空でないため削除されないディレクトリです。(実際の実行ではないため、本当に削除されないことを保証するものではありません)

それでは実際にアンインストールを行いますが、この時、管理者権限で実行しないとパッケージの情報の削除を行わないままファイルの削除がなされるため、えらいことになります。どんなことになるのかは僕も怖くてやったことがないのでわかりません。
例

```shell
$ sudo ruby pkgUninstaller.rb -u com.google.pkg.GoogleJapaneseInput
delete /Library/Input Methods/GoogleJapaneseInput.app/Contents/Resources/GoogleJapaneseInputConverter.app/Contents/Frameworks/GoogleBreakpad.framework/Versions/A/Resources/Reporter.app/Contents/Resources/English.lproj/Localizable.strings
delete /Library/Input Methods/GoogleJapaneseInput.app/Contents/Resources/GoogleJapaneseInputRenderer.app/Contents/Frameworks/GoogleBreakpad.framework/Versions/A/Resources/Reporter.app/Contents/Resources/English.lproj/Localizable.strings
delete /Library/Input Methods/GoogleJapaneseInput.app/Contents/Resources/GoogleJapaneseInputTool.app/Contents/Frameworks/GoogleBreakpad.framework/Versions/A/Resources/Reporter.app/Contents/Resources/English.lproj/Localizable.strings
delete /Library/Input Methods/GoogleJapaneseInput.app/Contents/Resources/GoogleJapaneseInputConverter.app/Contents/Frameworks/GoogleBreakpad.framework/Versions/A/Resources/Reporter.app/Contents/Resources/English.lproj/Breakpad.nib
delete /Library/Input Methods/GoogleJapaneseInput.app/Contents/Resources/GoogleJapaneseInputRenderer.app/Contents/Frameworks/GoogleBreakpad.framework/Versions/A/Resources/Reporter.app/Contents/Resources/English.lproj/Breakpad.nib
中略
delete /Applications/GoogleJapaneseInput.localized
/Applications/GoogleJapaneseInput.localized is not empty.
delete /Library/Input Methods
/Library/Input Methods is not empty.
delete /Library/LaunchAgents
/Library/LaunchAgents is not empty.
delete /Applications
/Applications is not empty.
delete /Library
/Library is not empty.
160 files and 52 directories deleted.
```

これでアンインストールが完了しました。それでも削除しきれないディレクトリなどが残ることがあるので、明らかに不要だと思われるものは手動で削除して下さい。

## コマンドオプション

### --serach(-s)

パッケージのIDを検索します。部分一致で検索します。

### --unlink(-u)

インストールされたファイルとディレクトリを削除します。

### --noop(-n)

--unlinkオプションと併用した時、ファイルとディレクトリの変更、及びパッケージ情報の削除を行いません。最後に削除されたファイル、ディレクトリ数を出力しますが、これは--noopオプション無しの実行と必ずしも一致しません。

### --quiet(-q)

--unlinkオプションと併用した時、削除されるファイルとディレクトリの名前、ディレクトリが空かどうかなどの情報を出力しません。削除されたファイル、ディレクトリ数は出力します。

### --help(-h)もしくはオプション無し

オプション一覧を出力します。

## 最後に

アンインストーラが付属する場合(virtualboxなど)は付属のそれを使って下さい。
