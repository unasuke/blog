---
title: Boxenの導入……ができない助けて
date: '2014-03-21'
tags:
- boxen
- git
- howto
- mac
- programming
---

## Boxenとは

まずBoxenとはなんぞや？
[BOXEN](http://boxen.github.com/)
なるほど、わからん。
次にこっちを見てほしい。
[Boxen使わなくても許されるのは2012年までだよね](http://qiita.com/yuku_t/items/c6f20de0e4f4c352046c)

つまり、OS installerにとってはありがたいツールであるということだ。2012年も過ぎ去ったし、導入しない手はないだろう。

## How to Use BOXEN?

Boxenを使うには、次のものが必要である。

- mac
- githubアカウント

導入だが、[Boxen使わなくても許されるのは2012年までだよね](http://qiita.com/yuku_t/items/c6f20de0e4f4c352046c)と、GitHubの公式マニュアルを見つつ順を追って僕がやったことを説明していく。複数のやり方がある時は公式マニュアル通りにやった。
~~今は2014年だし今更解説記事書いてるあたり許されないと思った。~~

### Xcodeのインストール

基本的にまっさらな状態からつくり上げることとする。だからすでにhomebrewが入ってたりしたら消さなきゃダメかもね。しらんけど。
で、まずはAppStoreからXcodeをインストールする。インストールが終わったら環境設定からCommand Line Toolsをダウンロードとインストール。
![まっさら](2014/how-to-use-boxen-01.png)
バッテリーは%表示になってないし壁紙は銀河だし本当にOSインストール直後にやってる

<h4>Mavericksの場合</h4>

Mavericksから、Command Line ToolsがXcodeからインストールできなくなっている。
![command line toolsがない](2014/how-to-use-boxen-02.png)
なので、ターミナルで
```shell
$ xcode-select --install
```
と入力し、インストールしなければならない。
[Xcode 5.0 Error installing command line tools](http://stackoverflow.com/questions/19066647/xcode-5-0-error-installing-command-line-tools)
[Mavericks上のXcode 5.0でCommand Line Toolsがない場合](http://qiita.com/marqs/items/bd43a031c0398d3ddecf)

### Boxenフォルダの作成

Boxenがいろいろダウンロードしたり実行したりするフォルダを作る。(と思い込んでる)
ターミナルで、

```shell
$ sudo mkdir -p /opt/boxen
$ sudo chown ${USER}:staff /opt/boxen
```

mkdirのpオプションはサブフォルダも一気に作るということ。chownでそのフォルダの所有者を自分に、グループをstaffに設定。間違ってる可能性大。不安なら自分で調べてほしい。

### 設定の編集

まずはGitHubのほうでリポジトリを作る。中身は空で。
![ここから](2014/how-to-use-boxen-03.png)
![こんなかんじで](2014/how-to-use-boxen-04.png)

```shell
$ git clone https://github.com/boxen/our-boxen /opt/boxen/repo
$ cd /opt/boxen/repo
$ git remote rm origin
$ git remote add origin <the location of my new git repository>
$ git push -u origin master
```

大本の[boxen/our-boxen](https://github.com/boxen/our-boxen)からそっくり引っ張ってきて、そのままだとpushする先が大元様なのを削除→自分のリポジトリに変更。そんでもってpushする。-uはupstreamの意味。これにより、大元様の変更を取り込むことができる……っぽい？
実際はこんな感じ。

![ちょっと表示が乱れている](2014/how-to-use-boxen-05.png)

### puppetに書き込む

Boxenでは内部で[Puppet](http://puppetlabs.com/)を使用している。それに関連するファイルなのだろう。Puppetについての詳しくは[gihyo](https://gihyo.jp/admin/serial/01/puppet)で。
boxenフォルダの中にPuppetfileというファイルがある。それを編集していく。

```puppet
# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.
--中略--
## unasuke setting
# web browser
github "chrome",      "1.1.2"
github "firefox",     "1.1.8"
github "opera",       "0.3.2"

# voip
github "skype",       "1.0.8"

# memo
github "evernote",    "2.0.5"

# player
github "vlc",         "1.0.5"

# utility
github "dropbox",     "1.2.0"
github "keyremap4macbook",    "1.2.2"
github "better_touch_tools",  "1.0.0"

# editor
github "sublime_text_2",      "1.1.2"
github "macvim_kaoriya",      "1.1.0",  :repo => "boxelly/puppet-macvim_kaoriya"
```

パッケージ名の横の数字はここから取ってくる。
![最新のやつを選べば大丈夫か？](2014/how-to-use-boxen-06.png)
最新のやつを選べば大丈夫か？

### 自分用の設定を書いていく

さて、Puppetfileで記述したパッケージを、実際にインストールさせるという記述をしなければならない。なんでだ……
個人用の設定は`modules/people/manifests/hoge.pp`に書いていく。ここでhogeはgithubのアカウント名。自分の場合だとこう編集する。

```shell
$ vim /opt/boxen/repo/modules/people/manifests/unasuke.pp
```

ほいで、中身はこれ。

```puppet
class people::unasuke{
  # core modules
  #include xquartz

  # web browser
  include chrome
  include firefox
  include opera

  # voip
  include skype

  # memo
  include evernote

  # player
  include vlc

  # utility
  include dropbox
  include virtualbox
  include keyremap4macbook
  include better_touch_tools

  # editor
  include sublime_text_2  
  include macvim_kaoriya  

  # raw package
  package{
    # japanese ime
    'GoogleJapaneseInput':
    source      => "http://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg",
    provider    => pkgdmg;

    # markdown editor
    'Kobito':
    source      => "http://kobito.qiita.com/download/Kobito_v1.2.0.zip",
    provider    => compressed_app;

    # ssd trim
    'Trim Enabler':
    source      => "https://s3.amazonaws.com/groths/TrimEnabler.dmg",
    provider    => pkgdmg;

    # scroll setting
    'Scroll Reverser':
    source      => "https://d20vhy8jiniubf.cloudfront.net/downloads/ScrollReverser-1.6.zip,      provider    => compressed_app;

    # typing sound
    # noisy typer
  }
}
```

それぞれに書いてあることは冒頭で紹介したQiitaの記事を見てほしい。簡単に説明すると、上からPuppetfieでincudeしたパッケージのインストール、webのアドレスからダウンロードしてインストールの指定をしている。

### site.ppの編集

さて、このファイルにはすべてのPCに適用される設定が書かれている。というのも、Boxenがもともとチーム向けに作られたものだから。
中を見てみると、複数のバージョンがインストール指定されている部分がある。互換性など配慮しているのだろうが、個人用途というか僕にとっていらないので最新のバージョンのみインストールするようにしてもいいが、なんかあったら嫌なので放っておいた。
<br>
ひととおり設定し終わったらgit addとgit commitとgit push origin masterしておく。

### インストール

では設定のとおりにBoxenに仕事してもらおう。

```shell
$ cd /opt/boxen/repo/
$ script/boxen --no-fde
```

--no-fdeは暗号化無しの場合につけるオプション
すると、こんなのがでた。

```shell
$ script/boxen --no-fde
Need to install Bundler for system ruby, password for sudo:
Fetching: bundler-1.3.6.gem (100%)
Successfully installed bundler-1.3.6
1 gem installed
Gem::Installer::ExtensionBuildError: ERROR: Failed to build gem native extension.
/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby extconf.rb
creating Makefile

make "DESTDIR="
compiling generator.c
linking shared-object json/ext/generator.bundle
clang: error: unknown argument: '-multiply_definedsuppress' [-Wunused-command-line-argument-hard-error-in-future]
clang: note: this will be a hard error (cannot be downgraded to a warning) in the future
make: *** [generator.bundle] Error 1


Gem files will remain installed in /opt/boxen/repo/.bundle/ruby/2.0.0/gems/json-1.8.1 for inspection.
Results logged to /opt/boxen/repo/.bundle/ruby/2.0.0/gems/json-1.8.1/ext/json/ext/generator/gem_make.out
An error occurred while installing json (1.8.1), and Bundler cannot continue.
Make sure that `gem install json -v '1.8.1'` succeeds before bundling.
Can't bootstrap, dependencies are outdated.
```

どうやらjsonのバージョン1.8.1が必要な様子。そこでインストールしようとすると……

```shell
$ sudo gem install json -v '1.8.1'
Fetching: json-1.8.1.gem (100%)
Building native extensions. This could take a while...
ERROR: Error installing json:
ERROR: Failed to build gem native extension.

/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby extconf.rb
creating Makefile

make "DESTDIR="
compiling generator.c
linking shared-object json/ext/generator.bundle
clang: error: unknown argument: '-multiply_definedsuppress' [-Wunused-command-line-argument-hard-error-in-future]
clang: note: this will be a hard error (cannot be downgraded to a warning) in the future
make: *** [generator.bundle] Error 1


Gem files will remain installed in /Library/Ruby/Gems/2.0.0/gems/json-1.8.1 for inspection.
Results logged to /Library/Ruby/Gems/2.0.0/gems/json-1.8.1/ext/json/ext/generator/gem_make.out
```

失敗する。

#### Mavericksの場合

どうやらライセンスに同意しないといけないっぽい。
[MavericksでC拡張を含むgemをインストールできない場合の対処法](http://qiita.com/yuku_t/items/30015dba2b6497b80074)

```shell
$ sudo xcodebuild -license
```

このコマンドでダーーッと出てくるライセンスを読んで最後にagreeと入力。
さてやり直すか。

```shell
$ sudo gem install json -v '1.8.1'
Building native extensions. This could take a while...
ERROR: Error installing json:
ERROR: Failed to build gem native extension.

/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby extconf.rb
creating Makefile

make "DESTDIR="
compiling generator.c
linking shared-object json/ext/generator.bundle
clang: error: unknown argument: '-multiply_definedsuppress' [-Wunused-command-line-argument-hard-error-in-future]
clang: note: this will be a hard error (cannot be downgraded to a warning) in the future
make: *** [generator.bundle] Error 1


Gem files will remain installed in /Library/Ruby/Gems/2.0.0/gems/json-1.8.1 for inspection.
Results logged to /Library/Ruby/Gems/2.0.0/gems/json-1.8.1/ext/json/ext/generator/gem_make.out
```

は？
どうやらclangのところで警告が出ているので、無視するために以下のコマンドで実行。

```shell
$ sudo ARCHFLAGS=-Wno-error=unused-command-line-argument-hard-error-in-future gem install json -v '1.8.1'
Building native extensions. This could take a while...
Successfully installed json-1.8.1
Parsing documentation for json-1.8.1
unable to convert "\xCF" from ASCII-8BIT to UTF-8 for lib/json/ext/generator.bundle, skipping
unable to convert "\xCF" from ASCII-8BIT to UTF-8 for lib/json/ext/parser.bundle, skipping
Installing ri documentation for json-1.8.1
1 gem installed
```

成功した。
[Ruby Gem install Json fails on Mavericks and Xcode 5.1 - unknown argument: '-multiply_definedsuppress'](http://stackoverflow.com/questions/22352838/ruby-gem-install-json-fails-on-mavericks-and-xcode-5-1-unknown-argument-mul)
ちなみにこのまま`script/boxen`しても同じ警告で止まるので、同様に`ARCHFLAGS=-Wno-error=unused-command-line-argument-hard-error-in-future`を付加して実行する必要がある。
[Ruby Gem install Json fails on Mavericks and Xcode 5.1 - unknown argument: '-multiply_definedsuppress' #528](https://github.com/boxen/our-boxen/issues/528)
が、しかし。

### help me

```shell
$ ARCHFLAGS=-Wno-error=unused-command-line-argument-hard-error-in-future ./script/boxen --no-fde
--> Hey, I need your current GitHub credentials to continue.

GitHub login: |unasuke| unasuke
GitHub password: *
/opt/boxen/repo/.bundle/ruby/2.0.0/gems/librarian-puppet-0.9.10/vendor/librarian/lib/librarian/dsl/receiver.rb:119:in `instance_binding': undefined method `guthub' for #<Librarian::Dsl::Receiver:0x007f962b822c10> (NoMethodError)
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/librarian-puppet-0.9.10/vendor/librarian/lib/librarian/dsl/receiver.rb:33:in `eval'
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/librarian-puppet-0.9.10/vendor/librarian/lib/librarian/dsl/receiver.rb:33:in `run'
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/librarian-puppet-0.9.10/vendor/librarian/lib/librarian/dsl.rb:81:in `block in run'
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/librarian-puppet-0.9.10/vendor/librarian/lib/librarian/dsl.rb:71:in `tap'
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/librarian-puppet-0.9.10/vendor/librarian/lib/librarian/dsl.rb:71:in `run'
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/librarian-puppet-0.9.10/vendor/librarian/lib/librarian/dsl.rb:17:in `run'
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/librarian-puppet-0.9.10/vendor/librarian/lib/librarian/environment.rb:115:in `dsl'
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/librarian-puppet-0.9.10/vendor/librarian/lib/librarian/specfile.rb:14:in `read'
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/librarian-puppet-0.9.10/vendor/librarian/lib/librarian/action/resolve.rb:16:in `run'
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/librarian-puppet-0.9.10/vendor/librarian/lib/librarian/cli.rb:161:in `resolve!'
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/librarian-puppet-0.9.10/lib/librarian/puppet/cli.rb:63:in `install'
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/thor-0.18.1/lib/thor/command.rb:27:in `run'
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/thor-0.18.1/lib/thor/invocation.rb:120:in `invoke_command'
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/thor-0.18.1/lib/thor.rb:363:in `dispatch'
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/thor-0.18.1/lib/thor/base.rb:439:in `start'
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/librarian-puppet-0.9.10/vendor/librarian/lib/librarian/cli.rb:29:in `bin!'
from /opt/boxen/repo/.bundle/ruby/2.0.0/gems/librarian-puppet-0.9.10/bin/librarian-puppet:9:in `<top (required)>'
from /opt/boxen/repo/bin/librarian-puppet:16:in `load'
from /opt/boxen/repo/bin/librarian-puppet:16:in `<main>'
Can't run Puppet, fetching dependencies with librarian failed.
```

どうしてもCan't run Puppet, fetching dependencies with librarian failed.で実行ができない。
[Can't run Puppet, fetching dependencies with librarian failed #78](https://github.com/boxen/our-boxen/issues/78)
[Unable to find module 'boxen/puppet-github_for_mac' on https://github.com Can't run Puppet, fetching dependencies with librarian failed. #313](https://github.com/boxen/our-boxen/issues/313)
[苦悶に満ちて溢れ出した Boxen のお話 (Winter ver.) - 弐](http://baqamore.hatenablog.com/entry/2013/12/17/205925)
など参考にしたが、効果はなかった。
誰か助けて……
参考までに僕のboxen→[unasuke/unasuke-boxen](https://github.com/unasuke/unasuke-boxen)
