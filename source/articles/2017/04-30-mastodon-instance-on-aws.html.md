---
title: "mastodon instanceをaws上に構築しました"
date: 2017-04-30 21:10 JST
tags:
- programming
- aws
- mastodon
---

![something went wrong](2017/mastodon-something-went-wrong.png)

## はじめに
まだログインできません。

## 断念
最初、いちからterraformで構築しようと思っていたのですが面倒すぎたので [r7kamura/mastodon-terraform](https://github.com/r7kamura/mastodon-terraform) をforkして作成しました。

追加で作成したリソースは、SESとlog用のS3 bucketとRoute53のzoneやrecordです。

## 運用
構成は前述のリポジトリと変えている部分はないのでスケールしやすい構成ではあるのですが、スケールすると大変なことになるのでしばらくはおひとりさまインスタンスとして色々いじってみたいと思います。

が、新規アカウント作成できるようにするつもりではあります。
