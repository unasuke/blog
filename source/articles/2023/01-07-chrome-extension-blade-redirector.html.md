---
title: "Rubyのメーリングリストのアーカイブを、旧bladeから新bladeへ自動的にリダイレクトするChrome拡張を作った"
date: 2023-01-07 18:00 JST
tags:
- ruby
- javascript
---


![](2023/blade-redirector-screenshot.png)

## bladeとは
Ruby界隈における「blade」といえば、Rubyの各種メーリングリストのアーカイブを提供している、 <http://blade.nagaokaut.ac.jp/ruby> のことを指します。
> blade
> Ruby の各種メーリングリストのアーカイブ。
> 
> <https://docs.ruby-lang.org/ja/latest/doc/glossary.html#B>

これは長岡技術科学大学の原先生という方が運営されていたようなのですが、2022年8月頃にサーバーが壊れてしまいました。

[Rubyist Hotlinks 【第 21 回】 原信一郎さん](https://magazine.rubyist.net/articles/0023/0023-Hotlinks.html)

そこで、hsbtさんが取得していたバックアップ、ko1さんやshugoさんの保持していたデータから再構築されたのが <https://blade.ruby-lang.org> です。

* [Misc #18976: [ANN] blade.nagaokaut.ac.jp is down - Ruby master - Ruby Issue Tracking System](https://bugs.ruby-lang.org/issues/18976)
* [大阪から東京に戻ってきた, blade.ruby-lang.org を構築した - HsbtDiary(2022-12-11)](https://www.hsbt.org/diary/20221211.html#p02)

## リダイレクトしたい
さて移行されました、めでたしめでたし……ではあるのですが、インターネット上に残る `blade.nagaokaut.ac.jp` は自動的に `blade.ruby-lang.org` へ移動したりはしてくれません。URLは機械的に置き換えることができるので、手でURLを編集してしまえばいいのですが、やっぱり手間です。

そんなわけで、自動的にリダイレクトしてくれるChrome拡張機能を作りました。

* [Blade redirector - Chrome ウェブストア](https://chrome.google.com/webstore/detail/blade-redirector/cpgeohmncpielpaegfbdhkhaccoocbcc?hl=ja)
* <https://github.com/unasuke/blade-redirector>

Manifest V3で作成したのが仇となったのか、Firefoxではmanifest.jsonが不正として扱われてしまっています。EdgeはChrome web store経由で拡張機能をインストールできるんですね。

## Chrome拡張を作る
Chrome拡張を作成するのは、以下の記事たちを参考にしました。

* [Extensions - Chrome Developers](https://developer.chrome.com/docs/extensions/)
* [Chrome拡張 つくりかた 令和最新版](https://r7kamura.com/articles/2022-05-07-chrome-extension-dev-2022)
* [Chrome拡張をつくるチュートリアル](https://r7kamura.com/articles/2022-05-18-learn-chrome-extention-in-y-minutes)

## おまけ UserScript
ぶっちゃけ、ただURLを機械的に置換してリダイレクトする、なんてことをしてくれるのは既存のChrome拡張でもあるでしょうし、Tampermonkey(Greasemonkey)でも可能です。

という訳で、Tampermonkeyで使用できるUserScriptを以下に用意しました。リポジトリにも含めています。

<https://github.com/unasuke/blade-redirector/blob/main/misc/blade-redirector.user.js>

```javascript
// ==UserScript==
// @name         Blade ruby mailing list archive redirector
// @version      0.1.0
// @description  Redirect from blade.nagaokaut.ac.jp's ruby-core and ruby-dev mailing list archive that's no longer available to blade.ruby-lang.org that's the alternative.
// @author       unasuke (Yusuke Nakamura)
// @match        http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/*
// @match        http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-dev/*
// @icon         https://avatars.githubusercontent.com/u/4487291?v=4
// @updateURL    https://github.com/unasuke/blade-redirector/raw/main/misc/blade-redirector.user.js
// @downloadURL  https://github.com/unasuke/blade-redirector/raw/main/misc/blade-redirector.user.js
// @supportURL   https://github.com/unasuke/blade-redirector
// ==/UserScript==

(function () {
  "use strict";

  const dialog = (url) => {
    const anchor = `<a href="${url}">${url}</a>`;
    const elem = document.createElement("div");
    elem.innerHTML = `Redirect to <pre style="display: inline-block">${anchor}</pre> after 3 seconds.`;
    elem.setAttribute("style", "font-size: 20px; font-weight: bold");
    return elem;
  };

  const location = document.location.pathname;

  if (
    location.startsWith("/cgi-bin/scat.rb/ruby/ruby-dev/") ||
    location.startsWith("/cgi-bin/scat.rb/ruby/ruby-core/")
  ) {
    const newPath = location.replace("/cgi-bin/scat.rb/ruby/", "");
    const newUrl = `https://blade.ruby-lang.org/${newPath}`;
    const htmlBody = document.getElementsByTagName("body")[0];
    setTimeout(() => {
      htmlBody.prepend(dialog(newUrl));
    }, 500);

    setTimeout(() => {
      window.location.assign(newUrl);
    }, 3500);
  }
})();

```

じゃあなんでChrome拡張なんて作ったのか？それは……Chrome拡張機能を作ってみたかったからです。
