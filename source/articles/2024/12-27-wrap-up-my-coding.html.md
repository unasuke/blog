---

title: "サーバーサイドエンジニアとして2024年に使った技術と来年の目標"
date: 2024-12-27 00:26 JST
tags: 
- programming
- diary
- yearly-wrap-up
---

![使用したプログラミング言語統計](2024/programming-language-stats.png)


## まとめ始めて5年目

* [サーバーサイドエンジニアとして2020年に使った技術](/2020/wrap-up-my-coding/)
* [サーバーサイドエンジニアとして2021年に使った技術と来年の目標](/2021/wrap-up-my-coding/)
* [サーバーサイドエンジニアとして2022年に使った技術と来年の目標](/2022/wrap-up-my-coding/)
* [サーバーサイドエンジニアとして2023年に使った技術と来年の目標](/2023/wrap-up-my-coding/)

なんとこれを書き始めてから5年目です。早いものですね。全部 [yearly-wrap-upというタグ](/tag/yearly-wrap-up/)でまとめることにしました。

例年同様、冒頭の画像はwakatimeによる2024年1月1日から12月25日までのプログラミング言語使用率です。業務で触れたコードは含まれていません。やっぱり不動の1位はRuby。次がYAMLなんですが、これはKaigi on Rails 2024の公式サイトのデータソースにYAMLを使っていたり、あとはGitHub Actionsとかですね。"Other" となってるものの大半はRBSでした。

### 追記 2025-12-26

[Code stats for all users in 2024 - WakaTime](https://wakatime.com/a-look-back-at-2024/37308ca7-0bc2-43dd-bdd9-cd213e3f62b1/qovduiycwq)

WakaTimeによる "真の" 2024年のまとめが生成されていました。

## 立場(毎年同様)
フリーランスで、主にRailsやAWSを使用しているサービスの運用、開発に関わっています。いくつもの会社を見てきた訳ではなく、数社に深く関わっている都合上、視野が狭いかもしれません。

今年仕事で書いた記事はこれです。

[AWS Lambda RuntimeをRuby3.3にしたら外部エンコーディングが変化した話 - Repro Tech Blog](https://tech.repro.io/entry/2024/12/11/155730)

プライベートだと、Kaigi on Rails 2024でも続投したconference-appにはまとまった量のコードを書いたのと、他にもGitHubのkaigionrails org以下でいくつかコードを書いて公開しています。

<https://github.com/kaigionrails/conference-app/graphs/contributors?from=2024%2F01%2F01>

## 利用した技術一覧
仕事で触れたものは覚えている範囲で書いています

- Language
    - Ruby
    - TypeScript/JavaScript
    - Java (ちょっとだけ)
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
    - Vim
    - IntelliJ Idea系
- 概念的なもの
    - REST API
    - GraphQL
    - PWA 
    - QUIC/TLS

昨年からのDiffとして、Python、Kubernetes、Cを削除しました。コンテナオーケストレーションはECSしか触ってない1年だったような気がします。使用しているエディタの順は、とうとうVS Codeが1位となりました。

エディタなんですが、プライベートでは主にWindows機(たまにmacbook)を使っており、コードは家の中にあるLinux機に対してSSHして書く、というスタイルでここ数年はやっていってます。そんなスタイルだと、VS CodeのRemote SSHが本当に便利なんですよね。IntelliJ系もJetBrains Gatewayを使えば同じようなことはできるんですが、手軽さと(感覚ですが)ハマることが少ないのでもっぱらVS Codeでやってます。

新しく触れてる技術があまりなく、例年とそんなに代わり映えしないところに若干の不安を覚えなくはないです。そういうものと言われてしまえばそれまでですが。

## QUIC/TLS/IETF

* [IETF 119 Brisbaneにリモート参加しました | うなすけとあれこれ](/2024/ietf-119-brisbane/)
* [IETF 120 Vancouverにリモート参加しました | うなすけとあれこれ](/2024/ietf-120-vancouver/)
* [IETF 120 Vancouverにリモート参加しました その2 | うなすけとあれこれ](/2024/ietf-120-vancouver-2/)
* [IETF 121 Dublinにリモート参加しました | うなすけとあれこれ](/2024/ietf-121-dublin/)

なんかすっかりまとめ記事を書くのが定番になったような気がしますが、始めてまだ2年目だというのがびっくりですね。

TLSについては[同人誌を書くのにいっぱいっぱいだった](/2024/techbookfest16-tlsbook/)ので実装は全然進んでおりません。あーあー。しかも同人誌は公開すると言いながらそれも全然進められていませんし。この記事を書いてる数日前からようやく実装を再開したという体たらくです。

## Ruby on Rails (conference-app)
Kaigi on Rails 2024ではアプリ側のコードは大したことはやってないですが、[インフラをHerokuからAWS ECSに載せかえてTerraform管理にしたり](https://unasuke.fm/ep/10)、サイネージ(実装が雑！)をつくったりしました。

あとはまあ、お仕事は大抵Railsなので、そんな感じです。

## 来年頑張りたいこと
### Ruby/QUIC/TLS
いい加減……実装を……はい……

### Kaigi on Rails
やるぞ！！！！

……何を？(Kaigi on Rails 2025をお楽しみに)

### English
今年は何度か「海外カンファレンス行かないの？」と言われたので、2025年はひとつくらい参加するのを目標にしてもいいかな？と考えてはいます。行くとしたらやっぱりRails Worldでしょうけど、被ってないとはいえKaigi on Rails 2025が近いのでどうなることやら。
