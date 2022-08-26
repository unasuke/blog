---

title: "RailsアプリをHerokuから移行するならどれがいいのか比較する"
date: 2022-05-09 15:40 JST
tags: 
  - heroku
  - fly
  - railway
  - rails
  - render
---

![今回つくったweb appのスクリーンショット](2022/heroku-alternatives-web-app.png)

## Herokuの移行先を考える
今運用しているアプリ達をすぐにHeroku以外に移すということはしないまでも、競合となるプロダクトの調査をしておくことは(特に後発のものについては)機能面で実はこんなに便利なものがあったのか、と気づくことにもなったりするので、やっておいて損はないかと思いました。

## 比較対象について
比較する対象としては、インターネットで最近見かけるPaaSを選定しました。同様のことができるIaaSのコンポーネントとして、AWS FargateやGoogle Cloud Runがありますが、そのようなIaaSの一部として提供されるものについては今回は比較対象とはしません。

今回の比較対象は以下3つです。

* Render <https://render.com>
* Railway <https://railway.app>
* Fly.io <https://fly.io>

## deployするRailsアプリについて
HerokuにdeployするようなRailsアプリに必要な要素とは何かを考えたとき、まずDBが必要なのは当たり前として、Active Job(Sidekiq)やAction Cableを使いたいからRedisも使えてほしいです。もともとHeroku上にファイルはアップロードできないのでオブジェクトストレージは不要としました。

そこで、簡単なチャット(？)アプリを作りました。GitHubアカウントでログインすると100文字以内の文字列を投稿できます。ログイン状態に関わらず、投稿は自動的に更新されます。この仕組みは勉強も兼ねてTurbo Streamsで構築しました。

* <https://github.com/unasuke/chachat>
* <https://chachatapp.herokuapp.com> ← Herokuにdeployしたアプリ

## Render

* <https://chachat.onrender.com> ← deployしたアプリ
* <https://render.com>

公式にもHeroku対抗を謳っているだけあり、とてもHerokuに似たサービスです。僕自身、以前の記事で採用したことがあります。

[Migrate from Heroku to Render | Render](https://render.com/docs/migrate-from-heroku)

実際、使い勝手としても、DBを作成すると環境変数 `DATABASE_URL` が自動的に追加されたりなどの挙動がHerokuと似ていて、新しく流儀を覚えなおす手間が少なくてよかったです。ただ、リソースは全てが一覧に出てきてアプリごとに管理するようなものではなかったです。deployはGitHubにpushすると自動で行われる感じでした。

![Renderのダッシュボード](2022/heroku-alternatives-render-dashboard.png)


Herokuにおける `app.json` と似たようなものとして、Blueprintという仕組みがあります。これによって、アプリで使用するリソース、接続情報などの環境変数、さらには接続を許可するIPアドレスなどをコードで管理できる(かつ、更新されたら自動で適用してくれる)のが便利でした。欲を言えばこのrender.yamlの書式が間違っている場合のエラーメッセージの親切さがもうちょっと欲しい[^blueprint]ところでした。

* <https://devcenter.heroku.com/articles/app-json-schema>
* <https://render.com/docs/infrastructure-as-code>
    * <https://render.com/docs/blueprint-spec>
    * <https://github.com/unasuke/chachat/blob/main/render.yaml>
        * 僕の作成したアプリで使っているblueprint

[^blueprint]: 僕の場合、不足しているkeyがない場合は何が不足しているかは教えてくれるものの、valueに明かに不正な値、例としてregionをtypoしている場合は全体がinvalidとなりどこがおかしかったのかがわかりませんでした。

価格ですが、DBにHeroku Postgresのような無料プランがなく、自動的に3ヶ月後から月$7になってしまいます。RailsとRedisは稼動している時間が制限内であれば無料のまま動かせるようなので、HerokuのHobbyプランを使っていると考えれば、まあ……というところでしょうか。

* <https://render.com/pricing>
* <https://render.com/docs/free>


![Renderの課金画面](2022/heroku-alternatives-render-billing.png)

また、今回deployしたアプリでは使いませんでしたが、Diskとminioを組み合わせたオブジェクトストレージを用意できるのは便利そうです。

## Railway

* <https://railway.app>
* <https://chachat.up.railway.app> ← deployしたアプリ

サービスとしてはコンテナやbuildpackによってビルドしたサービスをdeployできるPaaSです。

Herokuみたいな"Deploy on Railway"ボタンが作れるのもいいですね。

<https://railway.app/button>

また、公式及びコミュニティから提供されているStarterがかなり豊富です。

<https://railway.app/starters>

使い勝手としては、UIはすごくよくできてて操作が快適なのはよかったです。様々な言語、フレームワークに対応しているというか汎用的で、反面Herokuと比較すると自分で設定しないといけないことが多いように感じました。リソースもprojectごとにまとめて管理できるのがHerokuっぽくて良いです。deployはGitHubにpushすると自動で行われる感じでした。regionは現時点で選択できず、US-Westのみです。"We plan to add additional regions." と[公式FAQ](https://railway.app/help)にはあります。

![Railwayのダッシュボード](2022/heroku-alternatives-railway-dashboard.png)

公式CLIが、npmやyarn経由でインストールしても実行可能なバイナリが配置されず、GitHub releaseからダウンロードしないといけなかったりちょっと不安ですが……

UIがすごくよくできている、というかよくできすぎていて、DBの中身が見れちゃうのは凄いと思います、がそんなに気軽に見れちゃていいの……？

![DBの中身がカジュアルに見れる様子](2022/heroku-alternatives-railway-db.png)

価格体系がpricingページからはちょっとわかりづらいです。

<https://railway.app/pricing>

dashboradのbilingを見るとどのくらいのコストになるかが予測で表示されるのが嬉しいです。

![Railwayの課金画面](2022/heroku-alternatives-railway-billing.png)

サービスの使い勝手とは関係ないですが、内部の実装はJob descriptionを見るとBorgとMesosの論文から独自に開発しているようでアツいです。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">GoogleのBorgとSpanner、FacebookのTwineにインスパイアされて作ったPaaS基盤らしい。KubernetesではなくBorgとMesos論文もとにした独自のオーケストレーションエンジンを開発してるってJDに書いてあった。こりゃ面白いかもしれんね。 / “Railway” <a href="https://t.co/oWvwG73xQ8">https://t.co/oWvwG73xQ8</a></p>&mdash; inductor (@_inductor_) <a href="https://twitter.com/_inductor_/status/1520732890988167168?ref_src=twsrc%5Etfw">May 1, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

上記ツイートにぶら下げられているJob descriptionは今は見れません、以下に移動したようです。

<https://www.notion.so/Open-Jobs-bdc641c4b72947f2ab1e09bea5362363>

## Fly.io

* <https://fly.io>
* <https://chachat.fly.dev> ← deployしたアプリ

mizchiさんのこのブログ記事で聞いたことのあるという方は多いんじゃないでしょうか。僕もそのうちの一人です。

[Edge Worker PaaS の fly.io が面白い - mizchi's blog](https://mizchi.hatenablog.com/entry/2019/02/21/235403)

現在は公式サイトに "Run your full stack apps (and databases!) all over the world. No ops required." とあるように、マネージドなPostgreSQLも使えるようになっています。公式ドキュメントにもRailsをdeployする方法についての記載があります。

<https://fly.io/docs/getting-started/rails/>

感想としては、CLI (flyctl) から操作するのがメインだなという印象です。環境変数の追加も閲覧もWebからではできず、CLIからしか行うことができません。DBとしてPostgreSQLを追加するのはそんなに苦労しませんでしたが、Redisを追加するのに結構手間取りました(接続情報を自分でRails側に渡してあげないといけない)。deployも手元で `flyctl deploy` をするフローです。

![fly.ioのダッシュボード](2022/heroku-alternatives-fly-dashboard.png)

Herokuと比較した場合、東京リージョン(nrt)があるのが嬉しさでしょうか。

価格はこのようになっています。Herokuと比較してどうなるのかというのは一見ではわかりません。Usageを見ると現時点でのリソース消費量がわかります。

<https://fly.io/docs/about/pricing/>

![fly.ioの課金画面](2022/heroku-alternatives-fly-billing.png)

また、これはサービスの使い勝手とは関係ありませんが、アプリケーションがFirecracker上で動くのはアツいですね。メトリクスにもFirecrackerの状態が出ています。

<https://fly.io/docs/reference/architecture/>

![fly.ioのFirecrackerに関するメトリクス](2022/heroku-alternatives-fly-firecracker-metrics.png)

## 総評
自分がHerokuに慣れているというのもあるせいか、どうしても、どれもHerokuより多少なりとも複雑だなあという印象です。これらで、僕が移行するなら以下の順で検討すると思います。

1. Railway
    - サービス毎にリソースをまとめて見られる、UIが快適なのが1番として選んだ理由
2. Render
3. Fly.io

また今回、Herokuから移行するなら、という点でサービスを選定しましたが、これは複数人で管理していく[^team]ことも考慮しています。要するに、本気でお金をかけたくないのであれば複数のサービスを組み合わせて運用するのも選択肢としてあると思います。

[^team]: 具体的にはKaigi on Railsとして運用しているHeroku appがいくつか存在しています。

[個人開発のサービスをVPSからVercelとCloud Runに移行した話](https://zenn.dev/hokaccha/articles/81d0545c1517f1)

今回deployしたアプリは今後数ヶ月ほどはそのまま動かしておいて価格がどうなるかを見たいと思います。その後は落とすかもしれませんし、データもバックアップはしません。

## 参考URL
- [個人開発のコストはDB次第 - laiso](https://laiso.hatenablog.com/entry/nope-sql)
- [個人開発を黒字にする技術 - k0kubun's blog](https://k0kubun.hatenablog.com/entry/surplus)
- [なるべくお金をかけずに個人アプリを運用したい - くりにっき](https://sue445.hatenablog.com/entry/2022/05/06/170001)
- [次世代Herokuと噂のRender.comで、Railsアプリをデプロイしてみる](https://zenn.dev/katsumanarisawa/articles/c9da48652f399d)
- [render.comのここがよい · hoshinotsuyoshi.com - 自由なブログだよ](https://hoshinotsuyoshi.com/post/render_com/)
- [Edge Worker PaaS の fly.io が面白い - mizchi's blog](https://mizchi.hatenablog.com/entry/2019/02/21/235403)
- [個人開発のサービスをVPSからVercelとCloud Runに移行した話](https://zenn.dev/hokaccha/articles/81d0545c1517f1)
- [猫でもわかるHotwire入門 Turbo編](https://zenn.dev/shita1112/books/cat-hotwire-turbo)
