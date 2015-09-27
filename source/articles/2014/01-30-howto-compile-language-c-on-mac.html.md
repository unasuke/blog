---
title: MacでC/C++を書いてコンパイルするなら？(授業の課題程度)
date: '2014-01-30'
tags:
- howto
- mac
- programming
---

## コンパイラ

Macで使えるC/C++のコンパイラはgccとclangの2種類ある。どちらがどう優れているかは授業の課題軽度では比較できない。
あえておすすめするならAppleが力を入れているclangがいいのではないだろうか。

### インストール

まずXcodeを立ち上げ、「Xcode」から「Preferences...」をクリックする。
![手順1](2014/mac-compiler-setup-01.png)

設定画面が開くので、「Downloads」から「Command Line Tools」をダウンロード&インストールする。これでOK。
![手順2](2014/mac-compiler-setup-02.png)

## エディタ

[Macを購入したら絶対に導入したい！私が3年間で厳選した超オススメアプリ10選！](http://blog.supermomonga.com/articles/vim/startdash-with-mac.html)
この記事に載っていないものでおすすめしたいのが[mi](http://www.mimikaki.net/)である。
モードを設定すれば自動インデントもしてくれるし色分けもしてくれる。軽いのでささっと手軽なプロクラムを書くには向いているのではないだろうか。

## コンパイルと実行

ここではclangのやり方で書くが、「clang」をそのまま「gcc」と書き換えても動く。
たとえばこんなコードを書いたとする。

```c
#include<stdio.h>
int main( void )
{
    printf( "Hello World! );
    return 0;
}
```

これをコンパイルするには、

```shell
$ clang Test.c
```

とタイプする。
するとこんなエラーが出る。

```shell
$ clang Test.c
Test.c:4:13: warning: missing terminating '"' character [-Winvalid-pp-token]
    printf( "Hello World! );
    ^
Test.c:4:13: error: expected expression
1 warning and 1 error generated.
```

これを繰り返して何も表示されなくなったらコンパイル成功である。

```c
#include<stdio.h>
int main( void )
{
    printf( "Hello World!\n" );
    return 0;
}
```

実行するには、

```shell
$ ./a.out
```

と入力する。すると

```shell
$ ./a.out
Hello World!
$
```

こうなる。
また、ここで-oオプションを使って、実行ファイルの名前を好きに設定できる。

```shell
$ clang Test.c -o Test
$ ./Test
Hello World!
$
```

C++をコンパイルするときは、コマンドを「clang++」(g++)に書き換える。
以上！
