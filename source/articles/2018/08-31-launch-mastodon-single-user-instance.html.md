---
title: 'Mastodon おひとりさまインスタンスを立てました'
date: 2018-08-31 01:20 JST
tags: 
- programming
- mastodon
- gcp
- gke
---

![はい](2018/mastodon-single-user-instance.png)

立てました。

<iframe src="https://mstdn.unasuke.com/@unasuke/100639856211294764/embed" class="mastodon-embed" style="max-width: 100%; border: 0" width="400"></iframe><script src="https://mstdn.unasuke.com/embed.js" async="async"></script>

## 理由

- TwitterのUserStreramが消えた
- Kubernetes (GKE) の勉強の一環
  - Kubernetes.rbの予行(中止になりましたが……)
- bug fixなどのcontributeのための検証用環境
- 軸足の確保

主にMastodonでは末代([@unasuke@mstdn.maud.io](https://mstdn.maud.io/@unasuke))に軸足を置いて色々やっていました。しかし自分自身がRailsアプリケーションの運用を業務で担当しており得意とすることから、やはり自分のドメイン下で動かしてこそだろうと思いsingle user instanceを立てることにしました。(以前にも非公開で運用していたインスタンスはあったのですが、解消できない不具合があり閉じてしまっていました)

Kubernetesの勉強と書いたように、GKEの上で運用しています。費用を抑えるために全てのPodをPreemptible VM instance(最大でも24時間までしか稼動しない)上に配置しています。これはちょっとまずくて、Redisも24時間で自動的に再起動になるのでキャッシュが揮発してしまいます。この辺をなんとかしないといけないなーと思っているので、まだ積極的にリモートフォローはできない状態にいます。

また、このインスタンスでのアカウント作成を開放するつもりはありません。そもそもこのドメイン以下にアカウント作りたいか？という問題、特に今の構成では安定性が保証できないという問題などがあるためです。
5人以上が月に数百円の運営費用を負担してでも、というのであれば検討はしますが、基本的に開放は無いです。

<iframe src="https://mstdn.maud.io/@unasuke/100558873973819472/embed" class="mastodon-embed" style="max-width: 100%; border: 0" width="400"></iframe><script src="https://mstdn.maud.io/embed.js" async="async"></script>

<iframe src="https://mstdn.maud.io/@unasuke/100603918146903375/embed" class="mastodon-embed" style="max-width: 100%; border: 0" width="400"></iframe><script src="https://mstdn.maud.io/embed.js" async="async"></script>

## 参考にしたweb page

- [おひとりさま用のMastodonインスタンスを作る | microjournal](https://mlny.info/2018/03/build-personal-mastodon-instance/)
- [Mastodon on Google Container Engine (GKE)](https://lithium03.info/mastodon/gke.html)

