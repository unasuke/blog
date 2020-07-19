---
title: "unasuke.fmの再始動"
date: 2020-07-19 23:00 JST
tags: 
- unasukefm
- podcast
- javascript
- typescript
- programming
---

![unasuke.fm](2020/unasuke-fm-top.png)


## 再始動
<https://unasuke.fm> を公開しました。ロゴは[衰咲ふち(@otoroesaki)](https://twitter.com/otoroesaki)さんに作成していただきました。この場を借りてお礼申しあげます。ありがとうございます。

一旦は今までのエピソードを聞けるようにした**だけ**になります。今後、エピソードごとのサマリやshownoteの記載、RSS feedの公開などの改善を進めていきます。

加えて、次の収録についても日程含め検討中になります。

## プラットフォームに乗るかどうか
Podcastは、なぜだかまたブームが来ているようで、AnchorやTransistor、stand.fmなどのプラットフォームが登場しています。
プラットフォームに依存することで、労力の削減や便利な機能を使うことができますが、自分はいちから構築することにしました。

自分が発信する場を他人に委ねる怖さ、というものも多分どこかにあって、一度Twitterのアカウントが凍結されたときにはそれはもう気が気ではありませんでした。ブログをMiddlemanでbuildしてS3にホストしているのも、大して有効活用できていないMastodonを維持し続けているのも、そのためかもしれません。

## Next.js を選択した理由と、時間がかかった理由
今回は今までの自分の選択であるMiddlemanによる構築ではなく、Next.jsによる構築を選択しました。

理由は、Webサイトをつくるのであれば、Webの一級市民言語であるJavaScriptでつくるほうがいいのではないかという判断、自分の技術の幅を広げたくて、まだ仕事でも触ったことのないReactに慣れておきたかったという学習目的の2つが主です。また、Next.js を選択するのであれば、素JavaScriptよりは、TypeScriptで書くほうがいいと思い、そのようにしました。

そうなると、TypeScriptとReactとNext.jsの3つを初めて触ることになるので、[２つのことを同時に学ばない (by ところてん)](https://link.medium.com/BTmqWCJDa8)ようにするどころか3つのことを同時に学ぼうとしてしまっています。
実際、書いては思うように動かず、何度も友人に助けを求めたり、ひたすらWeb上の記事を読んだりして、それでも全然わからず、多忙を言い訳にしてしばらく放置してしまったりしました。

<img width="925" alt="image.png (23.1 kB)" src="https://img.esa.io/uploads/production/attachments/11214/2020/07/19/3132/ec97a735-07cc-4881-88cc-fb582219ad9d.png">

半分エタりかけていましたが、公式ドキュメントを何度も何度も読んでいくうちになんだかある程度「わかる」ようになりました。結局自分は、悩んで泥臭く試行錯誤を繰り返して手を動かさないと技術を身に付けることはできないんじゃないかと思います。

正直まだまだ機能面や見た目の面でも足りていない部分が多く構築中ですが、オリジナルのファイルがSoundCloud上にもう存在しないので、とりあえずWeb上に参照可能な形で復活させることを優先しました。RSSもないのでPodcastとしては片手落ちですが、"Done is better than perfect" と言いますし、まずは公開することにしました。

## 使用している技術
まず、Next.jsを静的サイトジェネレーターとして採用しました。そうなると必然、Viewを記述するためにReactを採用することになります。また前述のように、主にTypeScriptで記述しています。ESLintとPrettierを用いてコードフォーマットをしています。

音声ファイルのホスティングについては、転送量による課金のないWasabiを、WebサイトそのもののホスティングについてはFirebase Hostingを選択し、DeployはGitHub Actions経由で行うようにしました。確認用にmaster branchをNetlifyにてHostingしています。

また Content Security Policy を有効化にし、Report Onlyの状態にして report-uri.io に収集させるようにしました。

余談ですが、開発はほぼ全てをWindows 10(not WSL)上で行いました。開発環境において特にハマることはありませんでしたが、ESLintのruleに改行コードをUnix styleかWindows Styleかに設定するものがあり、これの扱いが悩ましいところでした。

- <https://nextjs.org/>
- <https://ja.reactjs.org/>
- <https://www.typescriptlang.org/index.html>
- <https://eslint.org/>
- <https://prettier.io/>
- <https://wasabi.com/>
- <https://firebase.google.com/products/hosting>
- <https://www.netlify.com/>
- <https://report-uri.com/>

## 参考にした記事・コード
- [Getting Started | Next.js](https://nextjs.org/docs/getting-started)
- [大幅にリニューアルされた Next.js のチュートリアルをどこよりも早く全編和訳しました - Qiita](https://qiita.com/thesugar/items/01896c1faa8241e6b1bc)
- [TypeScriptでNext.js 9を触った感想 | What Kohei Asai wrote](https://www.kohei.dev/posts/7-tips-of-next-js-9-with-typescript)
- [コンポーネントと props – React](https://ja.reactjs.org/docs/components-and-props.html)
- [ESLint と Prettier の共存設定とその根拠について - blog.ojisan.io ](https://blog.ojisan.io/eslint-prettier)
- [コンテンツセキュリティポリシー (CSP) - HTTP | MDN](https://developer.mozilla.org/ja/docs/Web/HTTP/CSP)
- [Content Security Policy(CSP) 対応と report-uri.io でのレポート収集 | blog.jxck.io](https://blog.jxck.io/entries/2016-03-30/content-security-policy.html)
- [SameSite cookies explained - web.dev](https://web.dev/samesite-cookies-explained/)
- [Podbase - Podcast Validator](https://podba.se/validate/)
- [Podcast プロバイダのための RSS ガイド - Podcast Connect ヘルプ](https://help.apple.com/itc/podcasts_connect/#/itcb54353390)
- <https://github.com/inabagumi/shinju-date>
- <https://github.com/inabagumi/renovate-config>
- [ホームページのパッケージ更新をrenovateに移した - naoty.dev](https://naoty.dev/posts/112.html)
