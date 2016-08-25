---
title: 静的Webサイトのつくりかた その2
date: 2016-03-13 00:34 JST
tags:
- howto
- Programming
- ruby
- middleman
- html
- css
- static-web-page
---

![n0h0.com](2016/n0h0-com-2.png)

## つくりかた記事リスト
- [静的Webサイトのつくりかた その1](/2016/how-to-make-static-website-part1/)
- [静的Webサイトのつくりかた その2](/2016/how-to-make-static-website-part2/)
- [静的Webサイトのつくりかた その3](/2016/how-to-make-static-website-part3/)

## あまりにもはしょりすぎていた
> あとは、あなたが好きなようにslimを書き、scssを書き、ページを作っていくだけです。

と前回書きましたが、あまりにもはしょりすぎている感じがあるので、どういう風に僕が[n0h0.com](https://n0h0.com/)を書いていったかを説明します。

以下、前回の続きとしてslimとscssで書いていきます。

## 画像を置く
middlemanでは、`source/images`以下に置いた画像を、

```ruby
= image_tag "source/images以下のpath"
```

で参照することができます。例えば`source/images/n0h0.png`というファイルは、

```ruby
= image_tag "n0h0.png"
```

と書くことで、

```html
<img src="/images/n0h0.png" />
```

になります。

## 真ん中に置く
次に、この画像を画面の上下左右中央に配置したいと思います。

さて、block要素に対して、次のようなstyleを適用すると、その要素は親要素の上下左右から中央に配置されます。

```scss
.element {
  position: absolute;
  width: 100px;
  height: 100px;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  margin: auto;
}
```

※このとき、親要素には`position: relative;`があたっているとよい

### 参照
- [ブロックレベル要素 - HTML | MDN](https://developer.mozilla.org/ja/docs/Web/HTML/Block-level_elements)
- [position: absolute; の指定で要素が上下左右中央配置になる理由 | WWW WATCH](https://hyper-text.org/archives/2014/08/position_absolute_center_layout.shtml)

ところで、`<img>`要素は`inline-block`要素なので、このように書いてやります。

```scss
.element {
  display: block;
  position: absolute;
  width: 100px;
  height: 100px;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  margin: auto;
}
```

n0h0.comでは、`<img>`に対して直接このstyleをあてています。これは、ページ内(body以下)には`<img>`しか存在しないのでいいかなと思ってのことです。ですが、出来る限りclassを付与して、そのclassに対してstyleをあてるべきでしょう。

## 画像を回す
さて、のほ君のアイコンを回したくなりましたね？そこで、CSSアニメーションを使います。

### 参照
- [CSS アニメーション - CSS | MDN](https://developer.mozilla.org/ja/docs/Web/CSS/CSS_Animations/Using_CSS_animations)
- [CSS Animation for Beginners](https://robots.thoughtbot.com/css-animation-for-beginners)

画像の要素に対して、次のようなプロパティを指定します。

```scss
.element {
  display: block;
  position: absolute;
  width: 100px;
  height: 100px;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  margin: auto;

  // ここから下が追加したプロパティ
  animation: spin 10s linear infinite;

  @keyframes spin {
    0% {
      transform: rotate(0deg);
    }

    100% {
      transform: rotate(360deg);
    }
  }
}
```

これで永遠に回り続けるのほ君が完成しました。

## CSSフレームワークを使う
さて、ここまではCSSを全ていちから書いてきましたが、場合によってはCSSフレームワークを使うと便利な場合があります。定番のところでは、bootstrapを使ってレスポンシブなwebページを作成したりでしょうか。

有名どころのCSSフレームワークを以下に挙げます。

- [Bootstrap · The world's most popular mobile-first and responsive front-end framework.](http://getbootstrap.com/)
- [Bourbon - A Lightweight Sass Tool Set](http://bourbon.io/)
- [Pure](http://purecss.io/)
- [Foundation | The most advanced responsive front-end framework in the world.](http://foundation.zurb.com/)

### bootstrapのインストール
例として、おそらく一番有名である？bootstrapのインストール方法について解説します。

`<head>`のどこかにこの行を追加すれば完了です。(これはslimの書き方ではないことに注意してください)

```html
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
```

CSSフレームワークの使い方については、今回は触れません。

## 次回予告
次回こそ、ドメインを取ることと、サーバーを借りてssh接続するところまでやりたいと思います。
