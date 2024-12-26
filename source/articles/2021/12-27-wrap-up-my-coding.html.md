---
title: "サーバーサイドエンジニアとして2021年に使った技術と来年の目標"
date: 2021-12-27 18:00 JST
tags: 
- programming
- diary
- yearly-wrap-up
---


![使用したプログラミング言語統計](2021/programming-language-stats.png)

昨年書いた[サーバーサイドエンジニアとして2020年に使った技術](/2020/wrap-up-my-coding/)[^potato4d]の2021年版となります。

[^potato4d]: 書くきっかけになったpotato4dは今年のは書かないのかな……？

昨年と同じく、冒頭の画像はwakatimeによる2021年1月1日から12月26日までのプログラミング言語使用率です。2位はTypeScript、3位はYAML、4位はTerraformです。

## 立場
フリーランスで、主にRailsやAWSを使用しているサービスの運用、開発に関わっています。いくつもの会社を見てきた訳ではなく、数社に深く関わっている1都合上、視野が狭いかもしれません。(昨年と同じ)

今年公開している成果については以下です。

- [Agones移行物語 - Kubernetes Meetup Tokyo 42 #k8sjp｜うなすけ｜note](https://note.com/unasuke/n/neddb8af116fd)
- [なぜ我々はクラウドゲーミング基盤をKubernetesに移行したのか #CNDT2021｜うなすけ｜note](https://note.com/unasuke/n/n861b9a5f1ebb)
- [Repro のサーバーサイド開発環境を M1 Mac に対応させるまでの道のり - Repro Tech Blog](https://tech.repro.io/entry/2021/11/19/150000)
- [Repro のサーバーサイド開発環境を M1 Mac に対応させるまでの道のり(撤退編) - Repro Tech Blog](https://tech.repro.io/entry/2021/12/14/100000)


## 利用した技術一覧
昨年の記事では「特記事項があるもの」を太字にしていましたが、今回は去年からの差分を太字にしました。

- Language
    - Ruby
    - TypeScript
    - **~~Python~~**
    - Go
    - **Java**
- Framework
    - Rails
    - React/**~~Vue~~**
        - Jest
    - **Tailwind CSS**
    - **Chakra UI**
- Middleware/Infrastructure
    - Docker
    - PostgreSQL
    - MySQL
    - AWS (略)
    - GCP (略)
    - Terraform
    - **Kubernetes**
    - **Kafka**
    - **Cassandra**
- CI
    - ~~**Travis CI**~~
    - CircleCI
    - GitHub Actions
- Monitoring
    - Datadog
    - Sentry
    - RollBar
    - **Prometheus**
    - **Grafana**
- OS
    - Linux
    - macOS
        - **M1**
    - Windows
- Editor (wakatimeによる使用時間合計順に並べました)
    - VS Code
    - IntelliJ Idea系
    - Vim
- 概念的なもの
    - WebRTC
    - microservices
    - REST API
    - **GraphQL**
    - **QUIC**
- その他
    - OBS
    - Illustrator

## Ruby/QUIC
今年はRubyKaigi Takeout 2021に登壇することができました。どのような経緯で何について話したかは以下記事に書きました。

[RubyKaigi Takeout 2021 で発表しました | うなすけとあれこれ](/2021/rubykaigi-takeout-2021/)

しかしRubyKaigi以降、Kaigi on Railsなど様々なイベントに関わっていたこともあり、今年はQUIC関連のことをこの発表以来全く触れられていない状況にあります。

自分への宿題としたOpenSSL gemのRactor関連タスクですが、Pull requestとして形に仕上げてmergeまで進められたのは以下の1つだけ[^openssl]となっています。

[Add test cases to OpenSSL::BN using ractor by unasuke · Pull Request #457 · ruby/openssl](https://github.com/ruby/openssl/pull/457)

[^openssl]: なんとクリスマスにリリースされたRuby 3.1に含まれています！しかしテストコードはリリースに含まれると言っていいものなのか……？

QUICについては、Ruby、Ractorとは別に、手元に書きかけのものがあるので形にして出したいと思っています。

## TypeScript
昨年の[「Railsを主戦場としている自分が今後学ぶべき技術について(随筆)」](/2020/i-have-to-learn-those-things-in-the-future/)にて以下のように書きました。

> まずはTypeScript。これは先程の文脈の通り。Webアプリケーションに関わる開発者なら、既に「書けないとまずい」という域になりつつあるだろう。では、具体的に「書けないとまずい」とはどのレベルを指して言うのだろう。自分は、(中略) 例えばいくつかのライブラリを組み合せて0からWebアプリを構築するということが苦手だ、というかできない。

今年は[ElectronでPocketのリーダーアプリを作り始めたり](/2021/electron-app-progress-report/)、[Rustと組み合わせてDeepLのデスクトップアプリを作ったり](/2021/create-deepl-client-app/)と、 **「0から(Web)アプリを構築する」** ということがそれなりにできたのではないかと思います。どちらのアプリもまだまだ開発途中で足りてない機能は山程あるので、2022年も引き続き開発していきたいです。

## Rust
TypeScriptの項でも触れた「DeepLのデスクトップアプリ」のメインプロセスはRustで書きました。Tauriというフレームワークを使っています。

これについて、なぜそういう選択をしたかについてはリリースしたときの記事に書きました。

[DeepLのデスクトップアプリをRustとPreactとTailwind CSSでつくった | うなすけとあれこれ](/2021/create-deepl-client-app/)

Rustは概念の習得も書くのも難しいですが、[The Rust Programming Language 日本語版](https://doc.rust-jp.rs/book-ja/)をしっかり読み込めばなんとなくわかるようになる & [rust-analyzer](https://rust-analyzer.github.io/)がとても優秀でどんどんコードを補完してくれる[^completion]ので書くのが楽しかったです。既存のプロダクトのRust版が出てくる理由がわかった気がします。

[^completion]: もしかしたらGitHub Copilotだったのかもしれないですが

## Kubernetes/Prometheus/Grafana
公開している成果にも挙げたように、「Black Game Streaming Engine v2」をKuberntes上に構築しました。

昨年「Fargate/ECSで要件を十分に満たすことができる」と書いたように、インフラをKubernetesに移行した記事に対し「Kubernetesである必要がないのでは」と言われたりすることもありますが、これはまさにKubernetesを採用する必要があった要件です。詳しくは以下の発表記事をご覧ください。

- [なぜ我々はクラウドゲーミング基盤をKubernetesに移行したのか #CNDT2021｜うなすけ｜note](https://note.com/unasuke/n/n861b9a5f1ebb)
    - 発表の録画 → [なぜ我々はクラウドゲーミング基盤をKubernetesに移行したのか | CloudNative Days Tokyo 2021](https://event.cloudnativedays.jp/cndt2021/talks/1192)
    - Blackのテックブログまとめ → <https://blog.by.black/>

僕がこのプロジェクトで主に担当したのは監視周りの構築になります。PrometheusとGrafanaの準備を行いました。Grafanaの前段にoauth2-proxyを置いてアクセス制限をしたり、cert-managerで証明書の自動更新をしたりという作業が地味に面倒で大変だった思い出があります。

## Java/Kafka/Cassandra
去年から増えたもののうち、めちゃくちゃ企業色の強いものです。項目として取り上げましたが、ヘビーに関わったということではなく「やっていくぞ！」という流れがあり書籍を何冊か購入し読書会をやったり、ハンズオンをしたりしてチーム内での経験値を上げている段階です。購入した本は以下になります。

- [Apache Kafka 分散メッセージングシステムの構築と活用（株式会社NTTデータ 佐々木 徹 岩崎 正剛 猿田 浩輔 都築 正宜 吉田 耕陽 下垣 徹 土橋 昌）](https://www.shoeisha.co.jp/book/detail/9784798152370)
- [Kafkaをはじめる - ぽんず堂 - BOOTH](https://booth.pm/ja/items/1855236)
- [Javaビルドツール入門 Maven/Gradle/SBT/Bazel対応 - 秀和システム](https://www.shuwasystem.co.jp/book/9784798049380.html)

## 来年がんばりたいこと
### Ruby/QUIC
やったことでも書いたように、RubyでQUICを話せるようにしてみたい、そのために小さくても一歩一歩前に進んでいきたいです。具体的にはInitial packet以降のフローに対応する、OpenSSL gemのRactorテストコードを書いていく、などです。あと書きかけのプロダクトも世に出したいです。

### TypeScript
ElectronによるPocketのリーダーアプリですが、今年後半は全く言っていいほど動けていませんでした。デザイナーさんにお願いしてアイコンやUIデザインについてのアドバイスを頂いたので、そのあたりをキレイにしてリリースしたいです。

DeepLクライアントアプリも、突貫で作ったのでローディングのスピナー表示などをやっていきたいと思います。

また急に作りはじめたVJアプリについても、高専DJ部開催のタイミングだけになるとは思いますが使いやすく、良い映像を出せるように細々とやっていきたいです。

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">p5.js + WebGL(react-vfx) + WebMIDI <a href="https://twitter.com/hashtag/kosendj?src=hash&amp;ref_src=twsrc%5Etfw">#kosendj</a> <a href="https://t.co/KBvy7odaXo">https://t.co/KBvy7odaXo</a></p>&mdash; うなすけ (@yu\_suke1994) <a href="https://twitter.com/yu_suke1994/status/1474665576518025221?ref_src=twsrc%5Etfw">December 25, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

### Community (Kaigi on Rails)
Kaigi on Railsに関しては引き続きオーガナイザーの一員として関わるのみでなく、できればProposalを提出したいです。ネタというかこういうことについて話したいというアイデアはありますが、話せるようになるまでコードをいっぱい書く必要があるので、コードをいっぱい書きたいと思います。

### English
せっかくDeepLのデスクトップアプリを作ったり、QUIC関連のことをやったりしていて、これらは別に内容が日本に閉じたものではないので、英語で情報発信をしていくということをやっていきたいです。そう思うようになったきっかけの1つは、角谷さんのKaigi on Rails 2021での発表があります。

![Polishing on "Polished Ruby Programming" #kaigionrails p37](2021/polishing_on_polished_ruby_programming_p37.png)

[Polishing on "Polished Ruby Programming" #kaigionrails / kaigionrails 2021 - Speaker Deck](https://speakerdeck.com/kakutani/kaigionrails-2021)

## まとめ
がんばります。
