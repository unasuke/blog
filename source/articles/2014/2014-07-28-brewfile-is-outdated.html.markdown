---
title: Brewfileで管理するのはもうオワコン
date: '2014-07-28'
tags:
- homebrew
- info
- ruby
---

![brewfile is outdated](2014/brewfile-is-outdated.png)

## Brewfileでパッケージ管理していたあの頃

以前、こんな記事を書いた。
[Homebrewとbrewfileとhomebrew-caskでMacの環境構築](2014/homebrew-and-brewfile-and-homebrew-cask/)
Brewfileを使えば、

```shell
$ brew bundle Brewfile
```

これ一発で環境構築ができるという便利なコマンドだ。

## 今は もう うごかない その $ brew bundle

今、Homebrewで

```vim
$ brew bundle Brewfile
```

すると、冒頭画像のように

> Warning: brew bundle is unsupported and will be replaced with another,
> incompatible version at some point.
> Please feel free volunteer to support it in a tap.

と怒られてしまう。
[What?  "Warning: brew bundle is unsupported ..." · Issue #30815 · Homebrew/homebrew](https://github.com/Homebrew/homebrew/issues/30815)

![brewfile is dead](2014/brewfile-is-dead.png)

## どうすればいいのか

方法としては、2つある。

- 警告にもあるように、同じような働きをするコマンドを作ってtapする
- Brewfileをシェルスクリプト化する

1はちょっとハードル高い。
じゃあ、2かな。

Brewfileなんて、本質はbrewがないだけのシェルスクリプトみたいなものだ。ということで、こんなのを作った。

```ruby
#!/usr/local/bin/ruby
File::open( ARGV[0] ) {|brewfile|
  print "#!/bin/sh"
  brewfile.each_line {|line|
    if line[0] == "#"|| line.size == 1 then
      print line
    else
      print "brew " + line
    end
  }
}
```

[Gistにもあるよ](https://gist.github.com/unasuke/465d360e73a9718d8980)

こいつにBrewfileを渡せば、標準出力にシェルスクリプトとして出てくるので、適当な名前で保存して実行してやれば良い。

```shell
$ Brew2sh Brewfile > brewfile.sh
$ chmod +x brewfile.sh
$ ./brewfile.sh
```
