---
title: Cygwin使うならcyg-fastも
date: '2014-04-29'
tags:
- cyg-fast
- cygwin
- howto
- windows
---

## Cygwinのパッケージ管理

Cygwinは、それにインストールするパッケージをsetup.exeによって管理するようになっています。パッケージをインストールしたいときにはいちいちsetup.exeを起動して、あの重いパッケージ一覧の中からインストールするパッケージを指定しなければいけません。
![あの重い一覧](cyg-fast-01.png)

## apt-cygの登場

そこで、aptの使い心地をCygwinにも！ということで開発されたのがapt-cygです。(憶測)
だがこのapt-cygは遅いらしい。(伝聞)

## cyg-fastは速い

そんな遅い(要検証)apt-cygに代わって、lambdaliceさんによって開発されたのが[cyg-fast](https://github.com/lambdalice/cyg-fast)です。名前にfastなんて入っているあたり、速さには自信があるように感じます。

## cyg-fastのインストール

まずは、cyg-fastが動作するのに必要なパッケージをsetup.exeでインストールします。

- aria2c
- tar
- gawk

これらを検索してインストールする必要があります。setup.exeが必要なのはここまでです。もう捨てちゃいましょう。

次にgit cloneなりzipで落とすなりして本体を手に入れます。
[lambdalice/cyg-fast](https://github.com/lambdalice/cyg-fast)

そしたら`cyg-fast`を`C:\cygwin\bin`(cygwinのインストールディレクトリ\bin)にコピーします。(もしくはPATHが通っているところにコピー)
最後に、実行権限を付与します。

```shell
$ chmod chmod +x /cygdrive/c/cygwin/bin/cyg-fast
```

## cyg-fastの使い方

最初に起動したら、

```shell
$ cyg-fast build-deptree
```

を実行します。これにより依存関係のアレがソレされて速いっぽいです。
ただ、毎回聞いてくるので、rapidオプションをaliasしておくと良い(作者談)そうです。

```shell
$ alias cyg-fast='cyg-fast -r'
```

### パッケージを探す

```shell
$ cyg-fast find ruby
```

### パッケージの情報を見る

```shell
$ cyg-fast show ruby
```

### パッケージをインストールする

```shell
$ cyg-fast install ruby
```

### パッケージを削除する

```shell
$ cyg-fast remove ruby
```

使えるコマンドは引数なしで実行すると見れます。だいたいapt-cygと同じです。

## 本当にcyg-fastはapt-cygよりも速いのか？

計測してみましょう。どちらもデータベースは更新済みで、最新版を落とすのではなくキャッシュからの検索の時間を測りました。

まずはapt-cygでやってみます。

```shell
$ time apt-cyg -u find ruby
Working directory is /setup
Mirror is ftp://mirror.mcs.anl.gov/pub/cygwin
gpg: WARNING: unsafe permissions on homedir `/setup/.apt-cyg'
gpg: WARNING: unsafe permissions on homedir `/setup/.apt-cyg'

Searching for installed packages matching ruby:

Searching for installable packages matching ruby:
ruby
ruby-caca
ruby-debuginfo
ruby-doc
ruby-json
ruby-minitest
ruby-rake
ruby-rdoc
ruby-tcltk
subversion-ruby
weechat-ruby

real    0m0.304s
user    0m0.090s
sys     0m0.197s
```

次にcyg-fastはどうでしょう。

```shell
$ time cyg-fast -r find ruby
Working directory is /setup
Mirror is ftp://mirror.mcs.anl.gov/pub/cygwin

Searching for installed packages matching ruby:

Searching for installable packages matching ruby:
ruby
ruby-caca
ruby-debuginfo
ruby-doc
ruby-json
ruby-minitest
ruby-rake
ruby-rdoc
ruby-tcltk
subversion-ruby
weechat-ruby

real    0m0.140s
user    0m0.000s
sys     0m0.151s
```

約半分です。やっぱりcyg-fastは速いですね。
