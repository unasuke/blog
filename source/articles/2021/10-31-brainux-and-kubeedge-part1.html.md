---
title: "BrainuxとKubeEdgeを組み合わせることはできるのか Part 1"
date: 2021-10-31 22:44 JST
tags:
  - linux
  - brainux
  - kubernetes
---

![はい](2021/brainux-illegal-instruction.png)

## はじめに

これは 2021 年 10 月 31 日に開催された [Brain Hackers Meetup #1](https://brainhackers.connpass.com/event/228017/) での発表内容を再構成したものです。

## 僕のスキルと Brain Hackers コミュニティ

> Brain Hackers は、SHARP の電子辞書 "Brain" シリーズの改造や、ソフトウェアの開発に興味がある人々のためのコミュニティです。
> https://github.com/brain-hackers/README

とあるように、ハードウェアの改造がメインの目的となるコミュニティです。僕も参加しているのですが、僕はあまりその方面の知識がありません。というので、僕にできることで何か面白そうなことができないかというのを考えていました。

## Brainux は IoT デバイスになれるのか？

ある日、「Brainux で IoT っぽいことってできないのかな」と思ったことが始まりでした。日々追い掛けている Kubernetes 関係の情報で、 KubeEdge というものがあったなということも思い出し、これと Brainux を組み合わせられないかというのを思いつきました。

## KubeEdge について

- <https://kubeedge.io/en/>
- [KubeEdge とはなにか - Qiita](https://qiita.com/pideoh/items/175af7bc9f915fef578f)
- [猫でもわかる KubeEdge #InfraStudy / Infra Study Meetup 7th - Speaker Deck](https://speakerdeck.com/ytaka23/infra-study-meetup-7th)
- [エッジに導入する Kubernetes のアーキテクチャパターン - Interconnections - The Equinix Blog](https://blog.equinix.com/blog/2020/12/14/architecture-patterns-for-kubernetes-at-the-edge-jp/)

KubeEdge の詳細な説明はしませんが、とにかく Edge device を Kubernetes cluster に参加させることができるもののようです。これを Brainux に導入できたら何か面白いことができるのではないかと思いました。

## KubeEdge を setup する

KubeEdge をセットアップするための方法は、 <https://kubeedge.io/en/docs/setup/keadm/> に記載があります。これをやっていきます。

さて、手順に "Setup Cloud Side (KubeEdge Master Node)" という項目があります。ここからわかるように、KubeEdge の master node となるインスタンスで何か作業を行う必要があり、となると Master node に入って作業をるする必要がある、すなわち Master node を操作できるようになっていなければなりません。

よって、GKE や EKS といった Managed Kubernetes service には導入できず、自分で Kubernetes cluster を構築する必要がありそうです。

## kubeadm で Kubernetes cluster を構築する

早速 kubeadm を使用して、GCP 上に Kubernetes cluster を構築していきます。

![GCP 3 nodes](2021/brainux-kubernetes-nodes.png)

一点注意が必要なのは、最新の KubeEdge の Release[^ke-release] は、現時点で素直に kubeadm を apt から install して入る Kubernetes の version 1.22 系ではうまく動きません。そのため、 `sudo apt install -y kubelet=1.21.1-00 kubeadm=1.21.1-00 kubectl=1.21.1-00` などで 1.21 系をインストール、構築する必要があります。

- <https://github.com/kubeedge/kubeedge/issues/2988#issuecomment-893431242>
- <https://github.com/kubeedge/kubeedge/issues/3240#issuecomment-953565299>

[^ke-release]: master branch では動くっぽい

さて、これで Kubernetes cluster を構築することができました(ということにします。詳細については触れません)。

## keadm init を実行する

<https://kubeedge.io/en/docs/setup/keadm/#setup-cloud-side-kubeedge-master-node>

さて、 Kubernetes cluster ができあがったので、 keadm を実行して KubeEdge を構築します。

![keadm init done](2021/brainux-keadm-init.png)

ここまでで Cloud Side での setup が完了しました。

## Brainux 上で keadm join を実行する

ここから、 Edge Side での setup を行っていきます。適当に arm 向けのバイナリを実行すると、以下のように "Illegal instruction" というエラーになってしまいます。

![illegal instruction](2021/brainux-illegal-instruction.png)

これは、いわゆる現代において何も考えずに Go で Arm 向けのバイナリをビルドすると、それは ARMv7 向けのバイナリとしてビルドされます。ですが、現時点で僕が Braniux を動かしている PW-SH2 は ARMv5 であり、つまり動きません。

<https://github.com/golang/go/wiki/GoArm>

## KubeEdge をビルドする

なので、手元で git clone してビルドしようと思ったのですが…… clone 中に電池が切れてしまい、その後起動しなくなってしまいました。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">私のBrainuxの起動シーケンスはここで止まっています <a href="https://twitter.com/hashtag/dicthack?src=hash&amp;ref_src=twsrc%5Etfw">#dicthack</a> <a href="https://t.co/ArWMJjNlQX">pic.twitter.com/ArWMJjNlQX</a></p>&mdash; うなすけ (@yu\_suke1994) <a href="https://twitter.com/yu_suke1994/status/1454783446266441729?ref_src=twsrc%5Etfw">October 31, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## Part 2 について

未定です。
