---

title: "サーバーサイドエンジニアとして2023年に使った技術と来年の目標"
date: 2023-12-18 21:05 JST
tags:
- programming
- diary
---

![使用したプログラミング言語統計](2023/programming-language-stats.png)


## 4年目
今年は契約先が変わったのですが、新規契約先を探しているときに、「こういうのがあると非常に助かる」という声を頂いたので今年もやっていきます。

* [サーバーサイドエンジニアとして2020年に使った技術](/2020/wrap-up-my-coding/)
* [サーバーサイドエンジニアとして2021年に使った技術と来年の目標](/2021/wrap-up-my-coding/)
* [サーバーサイドエンジニアとして2022年に使った技術と来年の目標](/2022/wrap-up-my-coding/)

これまではこんな感じでした。

例によって冒頭の画像はwakatimeによる2023年1月1日から12月18日までのプログラミング言語使用率です。2位のOtherですが、内訳を見てみるとRBSやqlogやHamlやJsonnetでした。ReasonとなってるのはReasonでなく、Re:VIEWの `.re` がそう判定されているようです。(この統計には仕事で触れた言語は含まれていません)

## 立場(毎年同様)
フリーランスで、主にRailsやAWSを使用しているサービスの運用、開発に関わっています。いくつもの会社を見てきた訳ではなく、数社に深く関わっている都合上、視野が狭いかもしれません。

今年も仕事の成果として公表できるものはありませんでした。仕事ではありませんが、Kaigi on Rails 2023で使っていただいたconference-appはその大部分を書きました。

<https://github.com/kaigionrails/conference-app>

## 利用した技術一覧

- Language
    - Ruby
    - Python
    - TypeScript/JavaScript
    - C
- Framework
    - Rails
    - React
    - Tailwind CSS
    - Stimulus (new)
- Middleware/Infrastructure
    - Docker
    - PostgreSQL
    - MySQL
    - AWS
    - Cloudflare (new)
    - Terraform
    - Kubernetes
- CI
    - GitHub Actions
- Monitoring
    - Sentry
- OS
    - Linux
    - macOS
    - Windows
- Editor (wakatimeによる使用時間合計順)
    - VS Code
    - IntelliJ Idea系
    - Vim
- 概念的なもの
    - REST API
    - PWA (new)
        - Web Push
    - QUIC/TLS

昨年からのDiffとしては、Goは触った記憶がないので削除しました。TypeScriptとJavaScriptを併記していますが、conference-appのためにStimulusを書いた都合上、TypeScriptよりもJavaScriptを書いた比率のほうが大きいと思います。

## Python
昨年と比較して一番変化のある部分だと思います。これは明らかに[Rubyアソシエーション開発助成2022](/2023/personal-impressions-of-the-ra-grant-2022/)によるものです。とにかくPythonのQUIC実装をRubyに移植するという作業をしていました。とはいってもPythonを "書いた" ではなく "読んだ" というほうが正しいですね。DjangoやFlaskでWebアプリが書けるようになったとか、そういうわけではありません。

## QUIC/TLS
Python同様、イチから移植することで理解が深まったもののひとつです。昨年はここがQUICという表記でしたが、今年は明確にTLSを追加しました。実装の移植で行き詰まりRFC 8446 (TLS 1.3)を何度も読みました。

この活動がきっかけで[^yokohama]、今年3月からIETFに参加しはじめました。これ今年からなんですね……もう3回参加してるのでもっと前からのような気さえしてきます。

[^yokohama]: 116が横浜で開催されたという偶然もけっこう大きな要因ではあります

* [IETF 116 Yokohamaに参加してきました(IETF Meetingに参加しよう)](/2023/ietf-116-yokohama/)
* [IETF 117 San Franciscoにリモート参加しました](/2023/ietf-117-san-francisco/)
* [IETF 118 Pragueにリモート参加しました](/2023/ietf-118-prague/)

日本国外での開催に現地参加するかどうかは……ちょっと悩んでいます。お金がないというのもありますが、まだまだ英語のリスニングが甘いからというのも大きな理由です。

## conference-app
Kaigi on Rails 2023で皆さんに使っていただいたものです。これのおかげで、今年触った技術としてCloudflare、Stimulus、PWAを追加することができました。その後様々な方からのcontributeで、RBS(特にRailsに導入するもの)についてもちょっとわかるようになってきた、かもしれません。

## 来年頑張りたいこと
### Ruby/QUIC/TLS
今年はGrantでの移植以降、TLS 1.3をちゃんと学び直さないといけないと思い [RFC 8446: The Transport Layer Security (TLS) Protocol Version 1.3](https://datatracker.ietf.org/doc/rfc8446/) をアタマから読み直したり、日本語にしたりしていました。

RFCは、仕様として書かれているのでそういうものかもしれませんが、特にRFC 8446は読みづらかったです。後の章で解説される概念が冒頭で出てくることが何度もあるので、そのままの順序で読むと理解に苦労します。ということで、実装する立場でもうすこしわかりやすいものがあれば、と思いそれらしいものを書いている途中です。

そもそものQUIC実装にしても、RubyKaigi Takeout 2021からもう2年も経ってるのに……という状態であり、来年こそは何らかの成果を出したいところではあります。が、どうなることでしょうね。どうしても趣味でやっていることなので取れる時間が少ないのと、コミュニティ活動もあるのでなかなか進みが遅いですが、頑張りたいです。

QUIC実装、特にaioquicの移植としてそれなりの規模のコードを書いた感想としては、RBSはやっぱりあると便利ですね。なのでOtherが2位に上がってきたのだと思います。個人でgemを書くことがあれば、積極的にRBSは書いていこうと考えています。

### Kaigi on Rails
コミュニティ活動の筆頭と言えます。これは運営チームのみ見える形で「こんなことがしたい」というのを書いていて、それをやっていきたいですね。Proposalも……出せたらいいですね……

今年は初めてのin-person開催となりましたが、運営側からもそうですし、参加していただいた皆さんからも、成長する余地があることは感じられたかと思います。やっていかねば、いけませんね。

### C/Rust/Zig
昨年から何もできていないですね。本当に何もできていない。無です。多分来年もあんまりここに割ける時間はないんじゃないかと思いますが、気持ちだけはあります。本当です。

Pythonと同様に書くまではいかなくても、QUICやTLSの実装の参考として読むことは多いのではないかと考えてはいます。

### English
昨年、以下のようなことを書きました。

> あと海外カンファレンスにProposalを出せたらいいなとか考えていますが、果たして。

こちらは、出すには出したのですがRejectになってしまいました。

一方で、RubyKaigi 2023での登壇は英語でやることにし、その登壇記も英語で書きました(DeepLにおんぶにだっこではありますが)。

[RubyKaigi 2023 participation report](https://blog.unasuke.com/2023/rubykaigi-2023/)

RubyKaigiにおいて英語で話すことの一番のメリットは、同時通訳さんとの打ち合わせのために資料を事前に提出しなくてよくなることです。その代わり、発表練習は日本語で話すとき以上にみっちりやる必要がありますが。ただ、RubyKaigiの僕の発表資料作成は、まず話すことを文章にしたうえでスライドを作っていくというスタイルなので、この点は偶然にもうまくいっています。

そしてIETFに参加するようになり、例年以上に英語に触れる、特にリスニングの時間が増えているのを感じます、が、それに英語力の上達がついていっていない……どうしたものでしょうね。
