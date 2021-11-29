---
title: "DeepLのデスクトップアプリをRustとPreactとTailwind CSSでつくった"
date: 2021-11-30 02:45 JST
tags: 
- deepl
- preact
- react
- tailwind
- rust
- javascript
- typescript
- programming
---

![app screenshot](2021/deplore_screenshot.png)

## これはなに

- <https://github.com/unasuke/deplore>
- <https://github.com/unasuke/deplore/releases/tag/v0.1.0>

DeepLのAPI keyを使って翻訳を行う、DeepLが公式に提供しているデスクトップアプリのようなものの個人開発版です。

UI部分にPreactとTailwind CSS (Tailwind UI)、アプリケーションの土台やAPIとの通信部分にはRust (Tauri)を使っています。

名前は、DeepLのアプリなので、 `^d.*p.*l.*$` にマッチする英単語から適当に選んで "deplore" としました。

## 動機
英語は英語のまま理解できるのがもちろん一番いいのですが、長すぎる英文の概要だけでもサッとつかみたい場合などは機械翻訳は非常に役立ちます。

近年、機械翻訳ではDeepLの精度がとても素晴らしく、僕もPro planを契約して日常的に使っていました。しかし、DeepLの個人向けライセンスは、一度に1端末からしかアクセスできないという制限があります。

> 個人向けのライセンスでは、1名のみDeepL Proをご利用いただけます。この1名は、複数のデバイスからDeepL Proにアクセスできますが、一度に1つのデバイスからのみアクセスできます。
>
> [個人向けプランとチーム向けプランの違い – DeepLヘルプセンター](https://support.deepl.com/hc/ja/articles/360019893160-%E5%80%8B%E4%BA%BA%E5%90%91%E3%81%91%E3%83%97%E3%83%A9%E3%83%B3%E3%81%A8%E3%83%81%E3%83%BC%E3%83%A0%E5%90%91%E3%81%91%E3%83%97%E3%83%A9%E3%83%B3%E3%81%AE%E9%81%95%E3%81%84)

チーム向けのプランにすると料金は2名からとなってしまい、価格が倍となってしまいます。これはつらいです。

複数端末でDeepLを使っているとこの制限にとても頻繁にひっかかり、フラストレーションが溜まります。一時期、ログインセッションが切れる度にツイートしていました。

[from:yu_suke1994 deepl session - Twitter検索 / Twitter](https://twitter.com/search?q=from%3Ayu_suke1994%20deepl%20session&src=typed_query&f=live)

さすがにしんどくなったので、API planを契約して同じようなことができるデスクトップアプリを作ることにしました。

## Why tauri, what's tauri
アプリケーションの作成にはTauriを使うことにしました。

[Build smaller, faster, and more secure desktop applications with a web frontend | Tauri Studio](https://tauri.studio/en/)

Tauriは、Rust製のデスクトップアプリケーションフレームワークで、UIの部分にはWeb技術を使用することができます。

- [reddit で話題になった Tauri と NEON についてのメモ、ついでに template-rust-backend-with-electron-frontend の開発理由についてのメモ - C++ ときどき ごはん、わりとてぃーぶれいく☆](https://usagi.hatenablog.jp/entry/2020/03/21/130854)
- [Rust+Webフロントの最前線！tauriを試してみた | Technology | KLablog | KLab株式会社](https://www.klab.com/jp/blog/tech/2020/0914-tauri.html)

当初はElectronでサッと作れればいいかな？と思いましたが、以下のような理由からTauri(Rust)を採用することにしました。

- やることが小さい
    - ので、配布されるバイナリサイズも小さくしたかった
- Blink依存の何かを書くことがない
    - WebUSBなどを使う訳ではない
- Blinkのみを想定したコードを書く必要はなさそう
    - CSSでのStylingやJavaScriptの挙動について複雑なことをしない

Tauriは、OSのwebviewを使用するため、Blinkを同梱するElectronよりバンドルサイズを削減することができます。

- <https://webview.dev/>
- [webview/webview: Tiny cross-platform webview library for C/C++/Golang. Uses WebKit (Gtk/Cocoa) and Edge (Windows)](https://github.com/webview/webview)
- [WebView2 と Electron | Electron](https://www.electronjs.org/ja/blog/webview2)

もっともその分、WebKitやBlinkでの挙動の違いを考慮する必用はありますが、EdgeがBlinkベースになったのでそこまで大変ということもないと判断しました。

あと、Rustを書いてみたかった[^rust]、という理由もあります。

[^rust]: [Railsを主戦場としている自分が今後学ぶべき技術について(随筆) | うなすけとあれこれ](/2020/i-have-to-learn-those-things-in-the-future/)

## その他技術選定
フロントエンド部分については、Preactを選択しました。Tauriのフットプリントの軽さを活かしたかったのと、Preactで困ることがないだろうという理由です。

<https://preactjs.com/>

状態管理に関しては、新しめであり、使ってみたかったという理由でRecoilを選択しました。

<https://recoiljs.org/>

デザインに関しては、Tailwind CSS、と言うよりTailwind UIを選択(購入)しました。Tailwind CSSを使ってみたかったのと、出来合いのコンポーネントの質が非常に良いからです。

- [Tailwind CSS - Rapidly build modern websites without ever leaving your HTML.](https://tailwindcss.com/)
- [Tailwind UI - Official Tailwind CSS Components](https://tailwindui.com/)

また、bundlingに関してはその速さが界隈で話題なのもあり、Viteを選択しました。

<https://vitejs.dev/>

ちなみにこれらは、 `yarn create tauri-app` から  create-vite  → preact-ts という選択をすることで簡単に導入することができました。

## 苦労部分
とにかくRustの並行処理、所有権のあたりが壊滅的にわかりませんでした。rust-analyzerとGitHub Copilotにおんぶにだっこ状態でコードを書いていました。"The Rust Programming Language" には現在主流となっている(？)Futureについての入門的記載が見当らず、またTauriのdocumentやRustのdocumentの土地勘がなく、reqwestを用いた非同期なAPI requestを行うまでにとても苦労しました。

- [The Rust Programming Language 日本語版 - The Rust Programming Language 日本語版](https://doc.rust-jp.rs/book-ja/title-page.html)
- [Rustの非同期プログラミングをマスターする - OPTiM TECH BLOG](https://tech-blog.optim.co.jp/entry/2019/11/08/163000)
- [Rustの未来いわゆるFuture - OPTiM TECH BLOG](https://tech-blog.optim.co.jp/entry/2019/07/05/173000)
- [async/awaitで躓いて学んだ、「オレは雰囲気でRustをしている！」からの脱し方。 - CADDi Tech Blog](https://caddi.tech/archives/1997)
- [2019 年の非同期 Rust の動向調査 - Qiita](https://qiita.com/legokichi/items/53536fcf247143a4721c)

開発に、大体1ヶ月くらいはかかりました。Rustの記事をとにかく読み漁っていました。

## コントリビューション歓迎
RustもReactも習熟しているとは言い難いので、ある程度の経験がある方から見るとなんでこんなことになってるんだ！！なコードだらけかと思います。またエラー処理や、APIのレスポンス待ちにspinnerを出したりなど足りてない機能が沢山あります。皆さんのコントリビューションをお待ちしています！！！！！
