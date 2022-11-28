---
title: "RubyKaigi 2022の会場ネットワークリポジトリを読み解く"
date: 2022-11-29 01:30 JST
tags:
- ruby
- rubykaigi
- internet
---

![機材](2022/rubykaigi-2022-network.jpg)

## 私がこれを書く動機
私はKaigi on Railsのオーガナイザーのひとりです。Kaigi on Rails 2023は物理会場にて開催されることが公開されました。そうなるともちろん、会場でのインターネットについてはどうなる、どうする、という問題が出てきます。それに備えて、先輩イベントであるRubyKaigiを参考にしようというわけで、自分の理解のために書くことにしました。

## おことわり
私はRubyKaigi 2022のネットワークをお手伝いしましたが、ケーブルの巻き直し、APの設営、撤収時の諸々を手伝ったのみです。よってこれから言及する内容については、一般参加者に毛が生えた程度の事前知識しかありません。

またこれから読み解くコードにおいて、コメントする内容の正確性は一切ないものと思って読んでください。

## RubyKaigiのネットワークについて
RubyKaigiのネットワークにおけるL3(OSI参照モデルで言うネットワーク層以上)より上の構成(多分)については、このリポジトリで公開されています。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">何とは言わんが現場絶賛公開中なんだよな、宿題を放置した自分が全部悪いといいながらやってます <a href="https://t.co/J6SoHxBd4P">https://t.co/J6SoHxBd4P</a> <a href="https://t.co/GcPJLU69Rn">https://t.co/GcPJLU69Rn</a></p>&mdash; そらは (@sora\_h) <a href="https://twitter.com/sora_h/status/1566015189795110918?ref_src=twsrc%5Etfw">September 3, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

今回は、2022年の会場ネットワークの構築が始まったあたりからのcommitを順を追う形で読み解いていきます。

### [e419d86](https://github.com/ruby-no-kai/rubykaigi-nw/commit/e419d86e19343425de14f59bbd7c841588b05bf8) destroy itamae/ and start from scratch
今回のネットワークの準備はここから開始したと見られます。これ以前にもcommitsはあるのですが、それらは2019年以前のものをimportしたもののようなので、今年には関係ないとして無視します。
実際、このcommitでもitamaeのrecipeを削除してscratchからやりなおす、という意図を感じられます。

### [073c8e71](https://github.com/ruby-no-kai/rubykaigi-nw/commit/073c8e71bd115dd6601f41cab831ef1da9dd39b2) onpremises subnet
subnetを3つ、route_tableをひとつ定義しています

### [260fc96f](https://github.com/ruby-no-kai/rubykaigi-nw/commit/260fc96f1d3395fa2600c8b012bd4a562d15e0ad) dxg

AWS Direct Connect ゲートウェイを定義しています。AWS Direct Connectとは……

> AWS Direct Connect は、お客様の内部ネットワークを AWS Direct Connect ロケーションに、標準のイーサネット光ファイバケーブルを介して接続するサービスです。
> <https://docs.aws.amazon.com/ja_jp/directconnect/latest/UserGuide/Welcome.html>

とのことです。(今知った)

### [3c07751](https://github.com/ruby-no-kai/rubykaigi-nw/commit/3c07751025daae7e4bb13f6caa10d5bf351eda8c) rubykaigi.net route53 zones

Route 53に `rubykaigi.net` のZoneを定義しています。ネットワーク関係の色々は `*.rubykaigi.net` で提供されました。

### [6e1f798da](https://github.com/ruby-no-kai/rubykaigi-nw/commit/6e1f798dafa9a04c1beed2a1cbccda1ad86acf70) setup bastion instance
踏み台インスタンスを定義しています。関連するIAM roleであったり、SSH loginできるユーザーの公開鍵の設定などもあります。

### [b29183d](https://github.com/ruby-no-kai/rubykaigi-nw/commit/b29183d68547e7ca3b4def51aa1489f31a11f635) aws_route53_zone.ptr-10 => 10.in-addr.arpa. 
DNSの逆引きを設定しているんだと思います。この記載で `10.0.0.0` になるってこと……？

<https://manual.iij.jp/dpf/help/19004700.html>

### [c3a8f29c1](https://github.com/ruby-no-kai/rubykaigi-nw/commit/c3a8f29c1ec9a5243104a6c8abc0e3653df91739) mv terraform/ => tf/core/ in order to have multiple tfstates 
これは単純にTerraformのdirectory構成の変更ですね。

### [4dd4bae2](https://github.com/ruby-no-kai/rubykaigi-nw/commit/4dd4bae2e08f27b703b0e9118f2e2e891cc91c4b) create hosts DNS records with terraform

様々な機器のDatacenter、Network、CIDR、IP等を定義したhosts.txtを作成(というより更新)し、その内容から `aws_route53_record` を作成するRuby scriptを経由してRoute 53にTerraformからrecordを登録するようにしています。まあこれは手では書いていられないですね……最終的なhosts.tfは1400行弱になっています。

### [8fcc2cf](https://github.com/ruby-no-kai/rubykaigi-nw/commit/8fcc2cf5c6994efc4e034244d35489658cf77ad2) remove route53/ (roadworker)
Roadworkerを削除しています。RoadworkerはRubyによるRoute 53をDSLによって管理できるgemです。Terraformによる管理に乗り換えたから、ということなんでしょう。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">aws_route53_record 大量に発生すると一瞬で terraform apply 遅すぎてやってられん状態になるし roadworker はなんだかんだ捨てられないなぁ</p>&mdash; そらは (@sora\_h) <a href="https://twitter.com/sora_h/status/1561825685869838341?ref_src=twsrc%5Etfw">August 22, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

### [01b95c6](https://github.com/ruby-no-kai/rubykaigi-nw/commit/01b95c63fb4e5889f9f71ebec8e7af818e4f6cc4) enable nat gateway 
NAT Gatewayが有効になりました。


### [687e37b](https://github.com/ruby-no-kai/rubykaigi-nw/commit/687e37b0c65792a88759990df9f8197b3c10e3bf) initialize k8s cluster 
EKSによるKubernetes clusterが爆誕しました。というか、Cookpad org以下にterraform moduleが公開されているんですね。

<https://github.com/cookpad/terraform-aws-eks>

注目すべきは、このクラスタは全部ARM instanceで稼動するような設定になっているところです。


### [a8b808f6](https://github.com/ruby-no-kai/rubykaigi-nw/commit/a8b808f6dcf94c0c0bcc13b8df3639500bfae1e6) aws\_vpn\_gateway\_route\_propagation (import) 
VPN間でのrouteのpropagationを設定しています。


### [dd6967e](https://github.com/ruby-no-kai/rubykaigi-nw/commit/dd6967e13a1d777847b45302c66398e9235c3ac0) provision node groups
K8s clusterに属するnodeの設定です。


### [14e22a3](https://github.com/ruby-no-kai/rubykaigi-nw/commit/14e22a331565cc12351f6e7b1c195d2170c5714c) deploy node-termination-handler
<https://github.com/aws/aws-node-termination-handler> をHelm経由でdeployしています。こんなのがあるんですね。

* [Amazon EKS で EC2 スポットインスタンスを使用するためのベストプラクティス](https://aws.amazon.com/jp/premiumsupport/knowledge-center/eks-spot-instance-best-practices/)
* [AWS Node Termination Handlerの新機能について - Gunosy Tech Blog](https://tech.gunosy.io/entry/aws-node-termination-handler-new-feature)

### [ddb5c69](https://github.com/ruby-no-kai/rubykaigi-nw/commit/ddb5c6978d0656f056612e8fb22a9246ccaad0c1) deploy aws-load-balancer-controller

AWS Load Balancer Controllerをclusterにdeployしています。

[AWS Load Balancer Controller アドオンのインストール - Amazon EKS](https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/aws-load-balancer-controller.html)

### [ff3f013](https://github.com/ruby-no-kai/rubykaigi-nw/commit/ff3f01374866b127fec5808073eb127523779387) addcreate shared ALB (ops-lb.rubykaigi.net) 
証明書とALBを作成して `*.rubykaigi.net` ないくつかのhostを定義しています。こんなの生えてたのか。


### [144b3b6](https://github.com/ruby-no-kai/rubykaigi-nw/commit/144b3b65b834223c0afea2954c80fa0544c4475f) deploy dex at idp.rubykaigi.net

dexをdeployしています。dexというのは <https://dexidp.io/> です。 これで何をしたいかというと、  `*.rubykaigi.net` でhostされているいくつかのresources(例えば `grafana.rubykaigi.net` )へのアクセス権限を絞るためです。今回はGitHubの特定teamに所属しているメンバーに対しての許可を与えるような設定が書かれています。

また主にこのcommit以降からだと思いますが、K8sで使用するYAMLをJsonnetから生成するようになっています。

### [f5d628c](https://github.com/ruby-no-kai/rubykaigi-nw/commit/f5d628ced9a63ffdeb969f8480b8cebb0d0795f8)  test.rubykaigi.net with authenticate_oidc action through dex
で、そのテスト用のendpointを作成しています。ちゃんとAuthrorizeされていれば画像が見れるはず、というやつ。

### [9cb14e1](https://github.com/ruby-no-kai/rubykaigi-nw/commit/9cb14e18431331e9419a33cc86d3012d592134b0) add wgbridger
wgbridgerを導入しています。wgbridgerというのは、

> build L2 bridge using Wireguard to bring NGN to behind IPv4 NAPT only environment...

というもの(？) これはあれかな、準備作業中に見せてくれた、どこでもNGNに繋がる便利Raspberry Piの実体かな？


### [43c0b1a](https://github.com/ruby-no-kai/rubykaigi-nw/commit/43c0b1a8462e8cac9c086d65023edc1584dd18a8)  amc: to gain access to AWS through dexidp
dexをOIDC準拠IdPとして使用した認証を利用し、AWS Management Consoleへのアクセス権限を特定のIAM Roleによって行えるような機構、AMCを用意しています。つまりどういうことかというと、あるGitHub teamに所属している場合、その認証情報を用いてAWSのConsoleに入れる仕組みです。 `tf/amc/src/app.rb` がキモだと思うんですが、難しいよぉ……

* [Application Load Balancer を使用してユーザーを認証する - Elastic Load Balancing](https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/application/listener-authenticate-users.html)


### [5d66255](https://github.com/ruby-no-kai/rubykaigi-nw/commit/5d66255a338f1c964537a02ae2bec3d540190c92) amc: enhance readme
AMCのREADMEに追記が行われています。


### [1db6e03](https://github.com/ruby-no-kai/rubykaigi-nw/commit/1db6e03594dc9f9d029815eb72d9b7dab0358654) amc(ca_thumbprint): validate certificate chain
AMCに関連する処理のなかで、curlによる証明書チェーンが正当かどうかの検証を追加しています。

### [dc4ec4d](https://github.com/ruby-no-kai/rubykaigi-nw/commit/dc4ec4df11056bce67fc61b4965a3d77eab79e0b) build kea Docker image 
ここからKeaのための準備が始まります。Keaが何者かというと、DHCP serverです。このcommitでは、Docker imageのbuildやKeaを起動するためのscriptなどの準備をしています。

<https://www.isc.org/kea/>

### [cd4d420](https://github.com/ruby-no-kai/rubykaigi-nw/commit/cd4d4209d19c29604dc3079d3b4a9ffceda3d330) create kea backend rds 
これはKeaのためのAuroraを準備しています。

### [bf917ef](https://github.com/ruby-no-kai/rubykaigi-nw/commit/bf917ef03c09bbe58c932eaf3602e845e6a40962)  gen-k8s: use rsync instead of rm -rf & cp 

JsonnetをYAMLにするscript内部で、生成したファイルの扱いがちょっと変更されています。rsyncにしたのは更新日時とかそのあたりの都合？


### [857d625](https://github.com/ruby-no-kai/rubykaigi-nw/commit/857d6253cc212b52841fd1dac5c1e29cf51d49e3) deploy kea-dhcp4
Keaが運用され始めました。

### [f64e1a1](https://github.com/ruby-no-kai/rubykaigi-nw/commit/f64e1a1c5c77c2ea2df3c1d46b76e8653379024c)  dhcp: add health check server for NLB
Keaに対するhealthcheck用のendpointを用意しています、Rustで。Healthcheckそうやってやるんだ……なるほど……？

### [36c0f97](https://github.com/ruby-no-kai/rubykaigi-nw/commit/36c0f97a159918bfdf83c0562e4dedc04dcba500) NocAdmin: allow elasticloadbalancing:*
NocAdmin roleに対してロードバランサーへの権限を解放しています。


### [04171ac](https://github.com/ruby-no-kai/rubykaigi-nw/commit/04171aca162a5c79c5acac2acead5080b4fd4b15) dhcp: roll c866cff
Kea関連のdeploymentで参照しているcommit hashを更新しています。


### [7a7a1c3](https://github.com/ruby-no-kai/rubykaigi-nw/commit/7a7a1c37f59c66cc2e1e39c6baa57f66d5925cb2) nocadmin: grant rds:* 
NocAdmin roleに対してRDSへの権限を解放しています。


### [cc0d6cb](https://github.com/ruby-no-kai/rubykaigi-nw/commit/cc0d6cb9b7b78ddeaa0af61bccac80dbc286fe38)  employ permission boundary on NocAdminBase policy
これはちょっとわからない……NocAdminBaseとNocAdminに権限を分離して、権限昇格を防いでいるんだと思いますが多分。

[権限の昇格を防ぎ、アクセス許可の境界で IAM ユーザー範囲を限定する](https://aws.amazon.com/jp/premiumsupport/knowledge-center/iam-permission-boundaries/)

### [cf56dd4](https://github.com/ruby-no-kai/rubykaigi-nw/commit/cf56dd4c007afd81f7d25b61d469931926d23b2a) copypasta
🍝


### [4756245](https://github.com/ruby-no-kai/rubykaigi-nw/commit/47562454af2a08a8776345e633116009aa7a8a22) NocAdmin: grant more iam permissions 
NocAdminに対して許可するiamへの権限をいっぱい追加しています。


### [2c09e19](https://github.com/ruby-no-kai/rubykaigi-nw/commit/2c09e19336d5a15d79f28c44de4ee1640f1d83dd) tf/k8s: arm64 support has been merged but not yet released
687e37bで導入されたterraform moduleをfork先のものからfork元のものを使うよう修正しています。ARM対応がmergeされたのがこのタイミングだったのかな。


### [d5c2a75](https://github.com/ruby-no-kai/rubykaigi-nw/commit/d5c2a75275139bde882f88439716d17e8cd2feaa) tf: No YAML! 
Terraformのexternal data sourceとして、Jsonnetを指定してJSONを吐くときに使うためのRuby scriptを定義しています。

* [external\_data-sources | Data Sources | hashicorp/external | Terraform Registry](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/data_source)


### [9743d8f](https://github.com/ruby-no-kai/rubykaigi-nw/commit/9743d8fe8ca7fbea6e0fd1cb38060be0adb6840c) tf/core: ALB rules for prometheus/alertmanager 
このあたりからPrometheusの設定が始まります。ここではALBのための設定を作成しています。これらのendpointもdexを経由して認証されるようにしていますね。


### [6cf6189](https://github.com/ruby-no-kai/rubykaigi-nw/commit/6cf618963bfb9a15d852dc870ea36fde743789f4)  tf/k8s-prom: install kube-prometheus-stack
Helm経由でPrometheusをK8s clusterにdeployしています。


### [9020ef2](https://github.com/ruby-no-kai/rubykaigi-nw/commit/9020ef2b0e8f159e4c5bcd5aab1e5bfd3a0da6fc) tf/k8s-prom: Install prometheus-blackbox-exporter chart
blackbox exporter を用意しています。ICMP (ping)でどこかを監視する用かな。

### [6e086c7](https://github.com/ruby-no-kai/rubykaigi-nw/commit/6e086c7a910ddc432bc0ef98d15a05a886cee324) k8s/prom: Probes
`8.8.8.8` に対して60秒ごとにICMPを投げるように設定しています。これはインターネットへの疎通確認かな？


### [287eba2](https://github.com/ruby-no-kai/rubykaigi-nw/commit/287eba20ae1f413c7ad42588983a9f413a0eac81) tf/k8s-prom: Set retention to 30 days
Prometheusのdata retensionを1分から30日に変更しています。


### [f86fb99](https://github.com/ruby-no-kai/rubykaigi-nw/commit/f86fb99a03184ad82ca04d2011cd75ae8431333e) tf/k8s: Export cluster config
clusterへの設定を他のtfから参照できるようにoutputしています。


### [7c1f56c](https://github.com/ruby-no-kai/rubykaigi-nw/commit/7c1f56c3d6f6edef7f749fa3d09406140a808a99)  tf/k8s-prom: Import cluster config via terraform\_remote\_state
ハードコードしていた設定値を、先ほどoutputしたclusterの設定を用いた形に書き換えています。


### [025d95](https://github.com/ruby-no-kai/rubykaigi-nw/commit/025d95b058d21b2b7deb39d94751ba778bb1ad71) update hosts.txt
hosts.txtが更新されました


### [f52e1bc](https://github.com/ruby-no-kai/rubykaigi-nw/commit/f52e1bc3be246129cb14038c7fbe32ab92375cd5) tf/k8s: snmp-exporter
snmp-exporterを設定しています。SNMPはSimple Network Management Protocolのこと。CiscoのWireless LAN ControllerやNECのIX Routerの監視に用いていたのかな。


### [22b1104](https://github.com/ruby-no-kai/rubykaigi-nw/commit/22b11049c8c5d2f29612643b9f1680bb3caae839) k8s/prom: Example config for blackbox/snmp probes
先のcommitで作成した設定値をprometheus側に反映されるようにK8sのmanifestを設定している、という理解でいいのかな


### [743b14b](https://github.com/ruby-no-kai/rubykaigi-nw/commit/743b14bb16a6e4ae6cab33a7392a600900a79bbb) tf/k8s-prom: Grafana 
Grafanaです。


### [218ec5](https://github.com/ruby-no-kai/rubykaigi-nw/commit/218ec524adc95a8cf33640ccfdd06eec467a9e59) k8s/dhcp: Monitor kea4
Keaの監視もPrometheusで行うようになりました


### [99cb633](https://github.com/ruby-no-kai/rubykaigi-nw/commit/99cb6338da8903a0c2fe41f382e08f4525b8eb07) wgbridger: increase wg0 mtu
wgbridgerのためにMTU値を上げています

### [034fe8f](https://github.com/ruby-no-kai/rubykaigi-nw/commit/034fe8f7f4ad302be15a6cc46c40bbe1e4762f6f) wlc.rubykaigi.net
Wireless LAN Controllerにアクセスできるようになりました。


### [42df8b0](https://github.com/ruby-no-kai/rubykaigi-nw/commit/42df8b0cdca21501a38c5bbec32700b37bf36378) k8s-prom: Slack alert
PrometheusからのアラートがSlackに送られるようにしています。


### [c89d220](https://github.com/ruby-no-kai/rubykaigi-nw/commit/c89d2201c33190de2e9ec665fe7383d8c2564bb5) jsonnetfmt -i **/*.jsonnet
Jsonnetに対してformatterをかけています。


### [dd79016](https://github.com/ruby-no-kai/rubykaigi-nw/commit/dd79016129f70cb4f513c3cadf20caf3deec7fe5) prom: scrape-interval 20s
Prometheusがmetricsをscrapeする間隔を60秒から20秒に変更しています。


### [d397d5a](https://github.com/ruby-no-kai/rubykaigi-nw/commit/d397d5a5a1b68dd6f578d1a46beeb031d0e27d12) tf/k8s: Export cluser OIDC config
clusterでのOIDC configを別tfから参照できるようにexportしています

### [0344245](https://github.com/ruby-no-kai/rubykaigi-nw/commit/0344245723c108754fdab7b3922bf400f4e6aac5) nocadmin: dynamodb:*
NocAdmin roleに対してDynamoDBに関する権限を解放しています。なんかで使うんでしょう。


### [68781de](https://github.com/ruby-no-kai/rubykaigi-nw/commit/68781de387398d2a6ce4c365e3b7610b50bbae4b) tf: state lock
なるほど、State lockでDynamoDBを使うためだったんですね。

[Backend Type: s3 | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/language/settings/backends/s3)

### [3fa3622](https://github.com/ruby-no-kai/rubykaigi-nw/commit/3fa362232f5ae8bc3ff55af28d5a40d12702f3b4) noadmin: Allow iam:UpdateAssumeRolePolicy
NocAdmin roleに対して `iam:UpdateAssumeRolePolicy` を許可するよう変更しています。

### [a5268cf](https://github.com/ruby-no-kai/rubykaigi-nw/commit/a5268cf2d39090e599185c49aa1081f426693360) prom: cloudwatch_exporter
cloudwatch_exporterを有効にしています。AWSのresourceもPrometheusでモニタリングするためでしょうね

### [d36e815](https://github.com/ruby-no-kai/rubykaigi-nw/commit/d36e815134cf2cfb541d7c313fb4a8e6d25f8303) update hosts.txt
hosts.txtを更新しています。IPv6の指定が増えてますね。

### [18af871](https://github.com/ruby-no-kai/rubykaigi-nw/commit/18af8719fbd4d2f881c588a5537171d7cf2aac0d) update hosts.txt
さらにhosts.txtの更新。もりっとhostが追加されています。


### [3902ba6](https://github.com/ruby-no-kai/rubykaigi-nw/commit/3902ba6a1b09ae1c2ac07990263f6d13e47576d5) hosts\_to\_tf: fix error that single name allowed only single rrtype
hosts.txtからtfに変換するscriptを修正しています。IPv6の取り扱いとかに修正が入ってますね。


### [fd15430](https://github.com/ruby-no-kai/rubykaigi-nw/commit/fd15430ea91ef49fb1aec83e6a464781d67532fe) update hosts.txt (typo)
typo


### [e21aec7](https://github.com/ruby-no-kai/rubykaigi-nw/commit/e21aec77e08e42ff4221eaeae20fbc45a8be2937) script to generate tunnel iface configurations...
これは……なんだろう、多分何かの機器用の設定を生成するためのscript。NECのルーターだと思うけど。

[マニュアル : UNIVERGE IXシリーズ | NEC](https://jpn.nec.com/univerge/ix/Manual/index.html)


### [6febb97](https://github.com/ruby-no-kai/rubykaigi-nw/commit/6febb97e935ba5dfe1f406ad43a4125a6850dbd6) nocadmin: Allow s3:* on rk-syslog bucket
Syslogを置くためのS3 bucketへの権限をNocAdmin roleに付けています

### [335669f](https://github.com/ruby-no-kai/rubykaigi-nw/commit/335669fa2fdcb5240b40d3731a0cfea6b9e70cd1) tf/syslog: init
Syslog関連のterraformのための場所を作っています。

### [8440359](https://github.com/ruby-no-kai/rubykaigi-nw/commit/84403599afd45330f7a8a04c8c1bda55220e4937) tf/syslog: ECR repo for custom fluentd image
Syslogのためのfluentdを置くECR repositopryを定義しています

### [dbc46d8](https://github.com/ruby-no-kai/rubykaigi-nw/commit/dbc46d87d08085765fa0e04070dc978b4d51c06b) docker: custom fluentd image
Syslogのためのfluentd containerを作成しています。GitHub Actionsでdocker buildをしていますね。

### [9eef1d4](https://github.com/ruby-no-kai/rubykaigi-nw/commit/9eef1d444d7aef3962e43c4692054eeaa4ff6d8a) Use https transport for cnw submodule to allow unauthenticated checkout
git submoduleのrepository URLをssh形式からhttps形式に変更しています。鍵がない環境でcloneできないから、でしたっけ。たぶんGitHub Actionsで不都合になったのか……？


### [d89649d](https://github.com/ruby-no-kai/rubykaigi-nw/commit/d89649dd9cdc4acda2ec25ec4674245f0ff41230)  docker/syslog: fluend plugins
fluentd pluginを作成しています。これはまずhealthcheckだけやってる感じ？

### [c690a8f](https://github.com/ruby-no-kai/rubykaigi-nw/commit/c690a8fd67d97dabb6ab07b99865f4b17f9f7c9c) tf/core: Allow GHA to push fluentd images
GitHub ActionsからECRにpushできるような権限を付与しています

### [71ae2b9](https://github.com/ruby-no-kai/rubykaigi-nw/commit/71ae2b9d8bd6ea6e3dad605193f153b35a7ab215) tf/syslog: k8s service account for fluentd
Syslog用のIAM role、K8sのservice accountを作成しています。EKSでIAM roleとの連携ってこうやってやるんだ。

### [2ab09ff](https://github.com/ruby-no-kai/rubykaigi-nw/commit/2ab09ffeb8c0675fb9e48f9c809b374f5209657c) k8s/syslog: deploy fluentd
fluentdの設定、k8sのdeployment諸々が作成されています。これでEKS clusterにfluentd containerが稼動し始めたのかな。

### [eb9d2bd](https://github.com/ruby-no-kai/rubykaigi-nw/commit/eb9d2bd7debb3fd60bdc2336d1ad129f5e3a2a60) tf/syslog: SGs
SyslogのためのSecurity groupを作成しています。fluentdに向かう通信を許可しているはず。

### [06cafcf](https://github.com/ruby-no-kai/rubykaigi-nw/commit/06cafcf1055819c754b0b750c8e48d2d55065805) k8s/syslog: use monitor_agent plugin for healthcheck
fluentdのhealthcheckのために、pluginを作ってやっていたものからmonitor_agentを使う方式に変更しています。

<https://docs.fluentd.org/input/monitor_agent>

### [850181c](https://github.com/ruby-no-kai/rubykaigi-nw/commit/850181c9b662ae43f5db6d461c84cf9f3923be90) workflow: correct path
GitHub Actions内で参照していたpathの修正です

### [8c44f4d](https://github.com/ruby-no-kai/rubykaigi-nw/commit/8c44f4ddfc728cc760b213db539783fa01056164) k8s/syslog: Inject fluentd hostname in records and object keys
S3に置くlog fileにhostnameを付与するようにしています

### [c72628c](https://github.com/ruby-no-kai/rubykaigi-nw/commit/c72628cc33eb94d849ac6bc5688efc0c9175d368) k8s/syslog: Use default chunk\_limit\_size as timekey is enough short
fluentdが終了するときにbuffer(？)をflushするようにしています。これないと書き出し切らずに終了してしまう？

### [7160fc0](https://github.com/ruby-no-kai/rubykaigi-nw/commit/7160fc0a5477363a96112beecddb2749ab6b0f0b) k8s/syslog: No separete chunks by tag
tagでchunkが分離されてしまうのを防いでいる？

### [73d7542](https://github.com/ruby-no-kai/rubykaigi-nw/commit/73d7542c18203ca34139e710e55c3ecbfe45533e) bastion: ignore ami id change
terraformでbastion instanceに対してはAMIの変更を無視するようにしています。


### [51869fc](https://github.com/ruby-no-kai/rubykaigi-nw/commit/51869fcdaf444e79e8ac826ec57a3e3d2fe97549)  configure private NAT gateway for onpremises
> use static NAT on onpremises router devices so they don't need to handle dynamic NAPT table and allow redundancy

「オンプレミスのルーターデバイスで静的NATを使用することにより、動的NAPTテーブルを処理する必要がなく、冗長性を確保できる。」 あ～はいはいなるほど完全に理解した

### [b0c0737](https://github.com/ruby-no-kai/rubykaigi-nw/commit/b0c07375da97307c8475e2b3fc17fb2b33769e10) tf/core: Allog GHA to push unbound image
unboundがアップを始めている

### [dafaaeb](https://github.com/ruby-no-kai/rubykaigi-nw/commit/dafaaebc1c65980bd250fd855034f9384df2bc5b) tf/dns-cache: ECR repo and SG
unboundをCache DNS serverとして運用するみたいで、そのためのECRとsecurity groupを定義しています。

### [9d4ead6](https://github.com/ruby-no-kai/rubykaigi-nw/commit/9d4ead6ead182da88819820021edea5306bda195) docker/unbound: unbound with modified unbound_exporter
独自のunbound exporterによる監視を有効にしたunboundのcontainerをbuildしています。Jsonnet大活躍。

### [ac08623](https://github.com/ruby-no-kai/rubykaigi-nw/commit/ac08623a3a17dbe66af8e05bcb8e25e28118ca35) tf/dns-cache: typo
フィックスタイポ

### [bbd2f10](https://github.com/ruby-no-kai/rubykaigi-nw/commit/bbd2f1013de4da069aa3f2e008eb6ca3a5551df5) k8s/dns-cache: unbound
unboundの設定です。

### [68c205f](https://github.com/ruby-no-kai/rubykaigi-nw/commit/68c205fb465740cafb045d628de1d64702cdb9b9) k8s/dns-cache: forward reverse lookup zones and rubykaigi.{net,org} to VPC resolver
特定の逆引きに対しては特定のIPに送るようにしてい……る？このIPがVPC resolverを指している？

### [c15afdf](https://github.com/ruby-no-kai/rubykaigi-nw/commit/c15afdf6ec2eabbd2f8506f579944a2b082f8f77) k8s/dns-cache: Update image
deployされるunboundを更新しています。

### [831f13](https://github.com/ruby-no-kai/rubykaigi-nw/commit/831f13f0d78c9cfe980a517b1439aa36f9409a3b) k8s/dns-cache: fixup 68c205f
68c205fで設定したlocal-zoneに対してnodefaultを付けています。unboundなにもわからない。

> nodefault	AS112ゾーン（※）のデフォルトの設定をオフにする
> ※ AS112ゾーンはプライベートアドレスやリンクローカルアドレスの逆引きのゾーンのことです。Unboundではデフォルトでこのゾーンに対する問い合わせにはNXDOMAIN（情報なし）を返します。
>  [第4回　Unboundサーバ運用Tips | gihyo.jp](https://gihyo.jp/admin/feature/01/unbound/0004)

`NXDOMAIN` を返さないようにした、ということなんでしょうか。


### [9dc8b6c](https://github.com/ruby-no-kai/rubykaigi-nw/commit/9dc8b6c2df81643646d65c9e9b3b8a46e83fb2b3)  k8s/dns-cache: <https://nlnetlabs.nl/documentation/unbound/howto-optimise/>
unboundの設定を変更して性能を調整しています。

### [48cead4](https://github.com/ruby-no-kai/rubykaigi-nw/commit/48cead43e814a48822e70e99288d3053fd8a06a9) k8s/dns-cache: setuid
unboundが `unbound` userで動作するようにしています。

### [83645b1](https://github.com/ruby-no-kai/rubykaigi-nw/commit/83645b182248f6fefa3c44c64fa0f6f4a9bb3d0f) update hosts.txt, generate ptr for public IPs
グオオオ

### [477f8a1](https://github.com/ruby-no-kai/rubykaigi-nw/commit/477f8a10cb36cfcfd348e392bc723a7b1636f891) add kea4 config for all venue subnets
venue下のsubnetに対してKaeで払い出すIP rangeを指定している……でいいのか？

### [ceca0e4](https://github.com/ruby-no-kai/rubykaigi-nw/commit/ceca0e4352afa598e2c29ffab82fd8157436f955) dns-cache: Expose TCP port
unbound containerに対してTCPでも通信できるようにしています。heathcheckとかでも使うから。

### [ae37486](https://github.com/ruby-no-kai/rubykaigi-nw/commit/ae37486e34454863a957c46087086720ecec4534)  Enable pod-readiness-gate-inject
<https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/deploy/pod_readiness_gate/>

なる、ほど、ね……？

### [42bc251](https://github.com/ruby-no-kai/rubykaigi-nw/commit/42bc251683fee131085e8b2eb71ee9a2c22336a2) kopipe
😜

### [ae96cb9](https://github.com/ruby-no-kai/rubykaigi-nw/commit/ae96cb97a24c1286976ca4bdd8eeabdd0fb14d94) tf/dns-cache: Restrict access to healthcheck port from NLB subnets
NLBのsubnetからunboundへのhealthcheck accessをできないようにしています。metricも同じportで提供するから、というのはmetricに影響が出る？

### [9d02422](https://github.com/ruby-no-kai/rubykaigi-nw/commit/9d02422e215eef442ba811e79a662640adeaab05) Use loop over map value
これはterraformのfor loopの設定。

### [a4e3dd3](https://github.com/ruby-no-kai/rubykaigi-nw/commit/a4e3dd3c49d589ec84ce08745c17f8b178d3a4e0) ./gen-workflows.rb
./gen-workflows.rbを実行した結果をcommitしたんだと思います。

### [2c84d6c](https://github.com/ruby-no-kai/rubykaigi-nw/commit/2c84d6c83b86ebac8d1d06eb7283e2f5c6022678) tf/k8s: node\_onpremises min\_size=2
Availability Zoneごとに配置されるよう、nodeのmin_sizeを2にしています

### [3bacade](https://github.com/ruby-no-kai/rubykaigi-nw/commit/3bacade789d88f5744b217e1e87772d9b1af0430) update hosts
hosts.txtが更新されました。tmpに対して名前が付きましたね。

### [137ce90](https://github.com/ruby-no-kai/rubykaigi-nw/commit/137ce909b15165d978ea87ce073ed86a0b0ac07c) Probe dns-cache
unboundに対するPrometheusからの監視を設定しています。internalなhostnameとexternalなhostnameに対する名前解決もするようにしていそう。

### [017aca1](https://github.com/ruby-no-kai/rubykaigi-nw/commit/017aca14532b13c7d53b3e03b403fb4f7b4b1af7) k8s/dns-cache: topologySpreadConstraints
unboundに対してtopologySpreadConstraintsを設定しています。Zoneごとにちゃんとばらけてくれるようにしています。


### [ef6d2bb](https://github.com/ruby-no-kai/rubykaigi-nw/commit/ef6d2bb24d82a7e5e23a65bb5f582e1212ddc0c4) k8s/dhcp: nameserver IPs
KeaがDNS resolverとして使うものを `8.8.8.8` からunboundに変更しています。

### [d9d2a64](https://github.com/ruby-no-kai/rubykaigi-nw/commit/d9d2a643210aa57defa206719797005595fea9b7) air: more dynamic ips
IP addr足りなかった？

### [5788b2e](https://github.com/ruby-no-kai/rubykaigi-nw/commit/5788b2e7defa94197cb51c5e76bfb0e5951ec429) scrape snmp
PrometheusがSNMPで監視する対象のhostを増やしています。

### [3551e94](https://github.com/ruby-no-kai/rubykaigi-nw/commit/3551e94b6ded16fff03810d06cf181f191c3e6f7) snmp_exporter cisco wlc
CiscoのWLCに対してSNMPで取得するmetricを追加しています。

### [473d956](https://github.com/ruby-no-kai/rubykaigi-nw/commit/473d9569bdd04cfbaee34bc36a6fe80a2d52dea1) fixup 5788b2e
5788b2eで指定したWLCのhostnameを修正しています

### [306e534](https://github.com/ruby-no-kai/rubykaigi-nw/commit/306e5345096a2ae890181fbccc9d86d58700a4ff) prom: wlc uses public2 community
これちょっとよくわからない……WLCの居場所に関する設定？

### [345596c](https://github.com/ruby-no-kai/rubykaigi-nw/commit/345596cc01a0bb6632243b42401e01e329f13fa3) snmp-exporter: damerashii
ダメらしい。 [f52e1bc](https://github.com/ruby-no-kai/rubykaigi-nw/commit/f52e1bc3be246129cb14038c7fbe32ab92375cd5) で追加した一部の設定をコメントアウトしています。

### [b7c40c9](https://github.com/ruby-no-kai/rubykaigi-nw/commit/b7c40c9e416afccc52415674f148a1be65e2496f) update hosts
hosts.txtを更新しています。順番が上に移動しただけ？

### [4124beb](https://github.com/ruby-no-kai/rubykaigi-nw/commit/4124beba34429a129f27b3df61446faf5e23d940) add am-i-at-rubykaigi s3 bucket
さて、会場でRubyKaigiのライブ配信を見ようとした場合には見られなくなっていたと思いますが、これがそれです。特定のS3 bucketに対し、会場内ネットワークからのアクセスであればDenyするような設定をしています。

ライプ配信視聴アプリ側ではここでその制御を行っています。

<https://github.com/ruby-no-kai/takeout-app/blob/2657a8f46ac3068954c8ef46aaffeb2caac01eb2/app/javascript/Api.ts#L680-L699>

### [d6f4953](https://github.com/ruby-no-kai/rubykaigi-nw/commit/d6f49535ffd681331ddd1832566ea9cf26dcc404) cloudwatch: DX
AWS Direct Connectのmetricもcloudwatch-exporterで収集するようにしています。

### [fac7459](https://github.com/ruby-no-kai/rubykaigi-nw/commit/fac7459d1d87d741b95ff5239b492e44aad03b8b)  cloudwatch: MediaLive
AWS Elemental MediaLiveのmetricもcloudwatch-exporterで収集するようにしています。

RubyKaigiのライブ配信がどのようにAWSのサービスを使用して実現されているかはこの記事に詳しいです。まあ作者が書いてるので……

* [How RubyKaigi built an event site in days with the Amazon Chime SDK and Amazon IVS | Business Productivity](https://aws.amazon.com/jp/blogs/business-productivity/how-rubykaigi-built-an-event-site-in-days-with-the-amazon-chime-sdk-and-amazon-ivs/)
    * [Amazon ChimeSDK と Amazon IVS で RubyKaigi を数日で構築するには | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/how-rubykaigi-built-an-event-site-in-days-with-the-amazon-chime-sdk-and-amazon-ivs/)

### [f758267](https://github.com/ruby-no-kai/rubykaigi-nw/commit/f75826738a15fdcb1597879ce6b1a3d0b4eff1a0) printer
プリンター？

### [44518e6](https://github.com/ruby-no-kai/rubykaigi-nw/commit/44518e66333589b4c2dda244cab6fea727fed5d3) dns-cache: temporarily set to permissive mode
一時的に `val-permissive-mode: yes` にしています。これなに？

[DNSSECを無効にする方法 – 日本Unboundユーザー会](https://unbound.jp/unbound/howto_turnoff_dnssec/)

なるほどね。

### [a6affeb](https://github.com/ruby-no-kai/rubykaigi-nw/commit/a6affeb07d07b7df46cfdd0979f96264276c2069) dns-cache: Reverse IPv4/6 zones
先の変更を削除し、zoneの逆引きの設定を変更しています。

### [836e010](https://github.com/ruby-no-kai/rubykaigi-nw/commit/836e0102e4c74fd317d10b06f958707d3d1aa2b8) dns-cache: trust reverse IP zones
privateなzoneは信頼するように設定しています……というかDNS周りのこれらの設定を日本語に起こすときの言葉の選択が正しいのか全然自信がない。

### [0f0f71b](https://github.com/ruby-no-kai/rubykaigi-nw/commit/0f0f71b7817c8094c3baf03ec6d51197c2825aaf) dns-cache: Only forward private IP reverse zones
private IPのみ逆引きをforwardするよう変更しています。

### [2d76c39](https://github.com/ruby-no-kai/rubykaigi-nw/commit/2d76c3914e243b1bbafdc437d55c89624717918b) rules
EC2やEBSなどへの監視設定をPrometheusに対して行っています。

### [9ef4827](https://github.com/ruby-no-kai/rubykaigi-nw/commit/9ef4827c2e2e205794f1f39802ad6d77a83db167) Copy prometheus rules from cnw
[sorah/cnw](https://github.com/sorah/cnw)からPrometheusの設定を拝借しています。

-------

ここからは設営日 (9/9)になります。

### [58ab522](https://github.com/ruby-no-kai/rubykaigi-nw/commit/58ab522de8c9aecdfd551c07eff8c23d2632b0db) prom: SNMP target down
SNMPで監視する対象がDOWNしている場合のアラートを設定しています。

### [f1dd400](https://github.com/ruby-no-kai/rubykaigi-nw/commit/f1dd40063e8e6674d32d6eac570faeaef154b181) prom: IXSystemUtilization
NECのルーターに対してのアラートを設定しています。CPU使用率かな？

### [8a48bd7](https://github.com/ruby-no-kai/rubykaigi-nw/commit/8a48bd7005527e136026464cb4295ddb6bb0ddc3) snmp-exporter: scrape sysinfo from wlc
WLCに対してSNMPで取得する項目を追加しています。

### [e618b04](https://github.com/ruby-no-kai/rubykaigi-nw/commit/e618b04458918aaebf2f4b7ac6be857339b241eb) printer oops!
プリンターの居場所(というよりはhosts.txtから生成される定義？)が間違っていたっぽく、それを修正しています。

今思い出したけど、これテプラのラベルプリンター？

### [3307051](https://github.com/ruby-no-kai/rubykaigi-nw/commit/3307051b7fa51fa46802f81bdf1e12d86dde15be) prom: alert on sysUpTime resets
SNMPで監視している対象の機器が再起動したときのアラートを設定しています。

### [4e85ec7](https://github.com/ruby-no-kai/rubykaigi-nw/commit/4e85ec7ef18d4c858ccb0ea041b7c72e2fc9b84b) nocadmin: moooar bucket
NocAdmin roleに対してtakeout-app(配信視聴アプリ)関連のS3 bucketへの権限を付与しています。

### [9b5dfe8](https://github.com/ruby-no-kai/rubykaigi-nw/commit/9b5dfe8f1db7e3a3963a844f4266b3501ed108f7) 86400 nagai; to 3600
自分が会場ネットワークにいるかどうかの判定に使用するBucketのresponse cacheが長いので1時間に変更しています。

## いかがでしたか？
いかがでしたか？
