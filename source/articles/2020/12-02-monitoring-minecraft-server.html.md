---
title: "ナ組Minecraftサーバーの監視について —マイクラサーバー監視2020—"
date: 2020-12-02 19:37 JST
tags: 
- minecraft
- gcp
- prometheus
- grafana
---


## はじめに
皆さん、Minecraftしてますか。サーバー、立ててますか。監視、してますか？

この記事では、2020年10月末に爆誕したMinecraftサーバー「ナ組サーバー」について、僕が勝手に監視している方法について現時点での構成をまとめておくものです。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">なんか突然GCPを触りたくなったのでナ組マイクラ鯖を立てた</p>&mdash; 蜘蛛糸まな🕸️ / HolyGrail (@HolyGrail) <a href="https://twitter.com/HolyGrail/status/1322226459851677697?ref_src=twsrc%5Etfw">October 30, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 

## 注意
「マイクラサーバー監視2020」と題していますが、僕はこれまでにMinecraftのサーバーを運用した経験はありません。何ならここで言及するサーバーについても、構築したのは蜘蛛糸まな氏です。
単純に、今Minecraftサーバーの監視をするならどうするか、ということについて述べています。過去のベストプラクティスは知りません。

## ナ組サーバーとは
[ナナメさん (@7name_)](https://twitter.com/7name_) とそのお友達が遊んでいるMinecraftサーバーです。構築は前述の通り、蜘蛛糸まな氏です。GCP上に構築されています。

[#ナ組マイクラ - Twitter検索 / Twitter](https://twitter.com/hashtag/%E3%83%8A%E7%B5%84%E3%83%9E%E3%82%A4%E3%82%AF%E3%83%A9?src=hashtag_click)

<iframe width="560" height="315" src="https://www.youtube.com/embed/8cldPekgr4o" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

この動画の冒頭でも成り立ちについては述べられています。

僕は、このサーバーへのアクセス権を頂いているので、そこから色々な作業を行い監視環境を構築してみました。以下は行なったことについてのまとめとなります。

## 監視ツールについて
まず、サーバーの監視を行うときに「何でモニタリングするか」というのが大きな部分を占めるでしょう。SaaSであればMackerelやDatadog、GCP上のサーバーであればCloud Monitoringを使っておくのもありでしょう。自分で構築するのであれば、PrometheusやZabbixやNagiosなどの選択肢もあります。

今回は、Grafanaとの連携で見た目が良いこと、新しめのものであることから、Prometheusで監視、Grafanaで可視化という構成を採用しています。

* <https://prometheus.io/>
* <https://grafana.com/>

## MinecraftへのPluginの導入
先ほどPrometheusを導入することに決めた、と書きましたが、そもそもMinecraftサーバーの状態をPrometheusから取得することができなければ無意味です。

Minecraftに導入できるPrometheus exporterはいつくか存在します。

* <https://github.com/sladkoff/minecraft-prometheus-exporter>
* <https://github.com/cpburnz/minecraft-prometheus-exporter>

star数、ドキュメントの量から、 [sladkoff/minecraft-prometheus-exporter](https://github.com/sladkoff/minecraft-prometheus-exporter) を導入することに決めました。このようなexporterが存在していたことも、Prometheus採用の一因です。

MinecraftサーバーへのPluginの導入については、各サーバーによってまちまちだと思うので詳しくは触れませんが、今回は特定のディレクトリ以下へplugin本体を展開しておくだけで済みました。

plugin自体の設定はYAMLで記述することができるので楽ですね。いい感じにやっておきましょう。

## Prometheus, Grafana serverの構築
今回、MinecraftとPrometheus、及びGrafanaは同居させず、別のサーバーに分離することにしました。どちらもワンバイナリで動作するので、サーバーの適当なディレクトリに置いて起動させるだけで構築は大体完了です。追加でやることは、Prometheusの`scraping_configs`にMinecraftサーバーを追加で指定することと、Grafanaのdata sourceにPrometheusを追加すること程度です。

Webサーバー運用についてのHTTPS化などのエトセトラはここで詳細に記述することはしません。[^https]

## dashboardの作成
ここまででGrafanaを使用してダッシュボードを作成することができるようになっていはずなので、あとはチマチマと必要そうなグラフを並べたダッシュボードを作成します。ここで作成したダッシュボードの変化を見ているときが一番楽しいですね。

![ダッシュボード](2020/grafana-nagumi-dashboard.png)

このダッシュボードについてですが、MinecraftサーバーのIPアドレスがわかってしまうため、一般に公開はしていません。[^ipaddr]

## アラートの設定
サーバーというものは、いつ止まってもおかしくありませんし、止まってしまっているときには何らかの方法で通知が欲しいものです。

Prometheusによるアラートといえば、Alertmanagerがあります。Alertmanagerは様々な手段でアラートを送信することができますが、一番手軽なものはWebhookによる通知なのではないでしょうか。そこで、Webhookによる通知をAlertmanagerから送信しようとしてみましたが、これがDiscordのWebhookには対応していませんでした。[^discord]

[Alertmanager integration with Discord · Issue #1365 · prometheus/alertmanager](https://github.com/prometheus/alertmanager/issues/1365)

ナ組はコミュニケーションをDiscord上で行なっているので、そこに通知を集約できないのはつらいです。

しかし幸いなことに、Grafana自体のArert機能においては、DiscordのWebhookをサポートしていることが判明しました。

<https://grafana.com/docs/grafana/latest/alerting/notifications/#list-of-supported-notifiers>

そして、指定した閾値に達した場合に次のようにアラートをWebhook経由でDiscordに飛ばせることが確認できました。

![テストアラートの様子](2020/alert-from-grafana-to-discord.png)

ここでは、Minecraftが使用しているJVMのThread数が異常な値になった場合に通知をするという単純なルールになっています。

## まとめとアドベントカレンダーについて
このようにしてナ組のMinecraftサーバーは監視されています。Minecraftは10年近く遊ばれているゲームであり、インターネット上の情報も豊富ではあるものの古くなっている記述が沢山あります。監視に関する情報も、Prometheusを使用しているような比較的新しいものは見当らなかったので、こうやって記事にしてみました。

また、この記事は [whywaita Advent Calendar 2020](https://adventar.org/calendars/5082) の12/2を担当する記事となります。whywaitaさんは現在プライベートクラウドに関する仕事に関わっていたり、[過去にPrometheus clusterを破壊する](https://www.slideshare.net/whywaita/prometheus-monitoring-from-outside-of-kubernetes-kubernetesprometheus-prometheustokyo?ref=https://prometheus.connpass.com/event/127574/presentation/)などの輝かしい功績のあることですから、今回僕の行なった作業についても、より良い方法を知っているものと思います。一度、対面で教えていただきたいものですね。


[^https]: certbotを使用しています。それ以外の詳細については面倒になったので書きません。
[^ipaddr]: わからないようにできないか？とがんばってみましたが僕には無理でした。
[^discord]: 代替手段として <https://github.com/benjojo/alertmanager-discord> がありますが、コンポーネントを増やすことになるので導入はしませんでした。