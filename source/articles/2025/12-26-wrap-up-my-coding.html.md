---
title: "サーバーサイドエンジニアとして2025年に使った技術と来年の目標"
date: 2025-12-26 01:40 JST
tags: 
- programming
- diary
- yearly-wrap-up
---

![使用したプログラミング言語統計](2025/programming-language-stats.png)


## まとめ始めて6年目

* [サーバーサイドエンジニアとして2020年に使った技術](/2020/wrap-up-my-coding/)
* [サーバーサイドエンジニアとして2021年に使った技術と来年の目標](/2021/wrap-up-my-coding/)
* [サーバーサイドエンジニアとして2022年に使った技術と来年の目標](/2022/wrap-up-my-coding/)
* [サーバーサイドエンジニアとして2023年に使った技術と来年の目標](/2023/wrap-up-my-coding/)
* [サーバーサイドエンジニアとして2024年に使った技術と来年の目標](/2024/wrap-up-my-coding/)

6年目か……。上にもリンクは貼っていますが、[yearly-wrap-upというタグも付けています](/tag/yearly-wrap-up/)。

例年同様、冒頭の画像はWakaTimeによる2025年のプログラミング言語使用率なんですが、今回は前回のまとめを書いた2024年12月28日から2025年12月25日までのプログラミング言語使用率です。微々たる差ですが、昨年のまとめ記事を書いた時点からの計測ということになります。なお業務で触れたコードは含まれていません。Rubyは例年通り不動の1位。次がERBになったのが昨年との差ですね。昨年はYAMLが2位だったんですが、今年は3位になりました。ERBの順位が上がったのはKaigi on Rails 2025の公式サイトで使ったり、conference-appのだったりかな？と思っています。他にはTypeScriptがランキングから外れました。

ちなみに、WakaTimeは "真の" 2025年まとめを生成してくれるのですが、これは本当に2025年が終わるまでの瞬間まで集計対象となるのでまだ生成されていません。2026年になったら共有リンクを追記しようと思います。そして2024年のまとめは生成されているので、去年の記事に追記しておきました。

### 追記 2026-01-10

[Code stats for all users in 2025 - WakaTime](https://wakatime.com/a-look-back-at-2025/37308ca7-0bc2-43dd-bdd9-cd213e3f62b1/jcjdqwfihv)

WakaTimeによる "真の" 2025年のまとめが生成されていました。OSがLinuxとmacOSだけになっていますが、"Linux" という判定のほぼ全てが手元のWindows機からのSSHになっていると思います。


## 立場(毎年同様)
フリーランスで、主にRailsやAWSを使用しているサービスの運用、開発に関わっています。いくつもの会社を見てきた訳ではなく、数社に深く関わっている都合上、視野が狭いかもしれません。

今年仕事で書いた記事はこの2本です。

* [EmbulkからMySQLに日本語のデータを挿入するときの落とし穴 - Repro Tech Blog](https://tech.repro.io/entry/2025/04/10/093753)
* [Amazon BedrockでesaからKnowledge Baseを構築し、Slackから問い合わせるようにしてみたらどうだった？ - Repro Tech Blog](https://tech.repro.io/entry/2025/07/15/133716)

もう1本くらい書きたい気持ちはあったものの、2025年は2本という結果になりました。

プライベートだと、QUICの実装だったり、Kaigi on Rails 2025関連でいろいろやったりしました。

* <https://github.com/unasuke/raiha>
* <https://github.com/kaigionrails/conference-app>
* <https://github.com/kaigionrails/shirataki>
* <https://github.com/kaigionrails/terraform>

## 利用した技術一覧
仕事で触れたものは覚えている範囲で書いています

- Language
    - Ruby
    - TypeScript/JavaScript
    - Go
- Framework
    - Rails
    - React
    - Tailwind CSS
    - Stimulus
- Middleware/Infrastructure
    - Docker
    - PostgreSQL
    - MySQL
    - AWS
        - ECS
        - Lambda
        - Bedrock
    - Cloudflare
    - Terraform
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
    - Cursor
    - Vim
- 概念的なもの
    - REST API
    - GraphQL
    - PWA 
    - QUIC/TLS
    - Server-sent events (SSE)

昨年からのDiffとして、Go、Lambda、Bedrock、SSE、Cursorを追加、IntelliJ Idea系を削除しました。

Goについては仕事で触れる機会があったので追加したのと、SSEはKaigi on Rails 2025の字幕システムで触りました。Bedrockは仕事でもKaigi on Rails 2025でも活用しました。Cursorはこんなに使ってる印象がないんですがランクインしましたね。もっぱらVS Codeでコードを書いています。それもありIntelliJ Idea系エディタはとんと触らなくなってしまいました。Lambdaは仕事で書いた記事にもあるように触る機会が増えたので追加しました。

## QUIC/TLS/IETF

* [IETF 122 Bangkokにリモート参加しました | うなすけとあれこれ](/2025/ietf-122-bangkok/)
* [IETF 123 Madridにリモート参加してませんでした | うなすけとあれこれ](/2025/ietf-123-madrid/)
* [IETF 124 Montreal個人的まとめ | うなすけとあれこれ](/2025/ietf-124-montreal/)

今年もIETF Meetingのまとめを都度書いていました。が、リアルタイムで聞けたセッションはほぼなかったのと、そもそもIETF 124はチケットの入手すらしていないというありさま。まあタイムゾーンや別イベントとの兼ね合いがあってしょうがないといえばしょうがないのですが。

* [QUIC実装月報 2025年3月 | うなすけとあれこれ](/2025/quic-impl-monthly-report-202503/)
* [QUIC実装月報 2025年4月 | うなすけとあれこれ](/2025/quic-impl-monthly-report-202504/)
* [QUIC実装月報 2025年5月 | うなすけとあれこれ](/2025/quic-impl-monthly-report-202505/)
* [QUIC実装月報 2025年6月 | うなすけとあれこれ](/2025/quic-impl-monthly-report-202506/)
* [QUIC実装月報 2025年7月 | うなすけとあれこれ](/2025/quic-impl-monthly-report-202507/)
* [QUIC実装月報 2025年8月 | うなすけとあれこれ](/2025/quic-impl-monthly-report-202508/)
* [QUIC実装月報 2025年10月 | うなすけとあれこれ](/2025/quic-impl-monthly-report-202510/)

あと、今年からはQUIC実装の進捗を月報として書くようになり、少し手が動くようになった……ような気がしています。そうはいっても9月と11月のぶんがありませんが。12月のまとめはこの後に書きます。来年も続けるつもりです。

## Ruby on Rails
Kaigi on Rails 2025ではRailsをがっつり、というよりはFalconを試行錯誤しながら、という感じでの手の動かしかたをしていました。詳しいことは[北陸Ruby会議01の発表資料](https://slide.rabbit-shocker.org/authors/unasuke/hokurikurk01/)を見ていただければと思います。

引き続きRuby on Railsでお仕事を請けていく予定です。今のところは自分が提供できるリソースと市場の需要が一番マッチしているのがこの分野なので。

## AI coding
北陸Ruby会議01の発表でも触れましたし、仕事でもそうなんですが、今年は特にAIによるコーディング支援にお世話になることが多かったです。そもそもClaude Codeのリリースが今年2月ですし。

[Claude 3.7 Sonnet and Claude Code \ Anthropic](https://www.anthropic.com/news/claude-3-7-sonnet)

普段使いはClaude Codeばかりで、CodexやGeminiと比較してどうか、みたいなことはしていません。BedrockはKaigi on Railsでもこれから活用していくシーンがありそうなので引き続きゆるりとキャッチアップしていきたいです。

## 来年頑張りたいこと
### Ruby/QUIC/TLS
月報を書くようになり、それが締め切り的なプレッシャーになってくれて少し手が動くようになったのですが、それでもまだまだですね。2026年はAIも活用しつつ実装をより進めていけたらと思っています。思っているんです。

### Kaigi on Rails
ふつうの運営業務以外のところだと、Shirataki(字幕システム)をより堅牢にしていきたいと考えています。

### English
今年も日本の外には出ませんでした。そもそも海外カンファレンスにプロポーザルも出してないし。ただ、いっこネタは思いついたので実装できればプロポーザルを出そうとは思います。でもそのくらいかな。それが通らなければ2026年も国外に行くことはないんじゃないかと思っています。
