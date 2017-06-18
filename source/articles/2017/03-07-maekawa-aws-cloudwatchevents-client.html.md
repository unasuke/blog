---
title: "maekawaというAWS CloudWatch Eventsのcli clientをGolangで作りました"
date: 2017-03-07 22:30 JST
tags:
- golang
- Programming
- aws
---

![commits](2017/maekawa-github-commits.png)

## What's "maekawa" ?
[unasuke/maekawa: AWS CloudWatch Events client](https://github.com/unasuke/maekawa)

maekawaは、Golangで書かれたAWS CloudWatch Eventsのcli clientです。Yamlに定義されたRuleとTargetを登録します。

冪等性を持つようになっているので、便利です。

## なんで作ったか
軽く探したのですが、CloudWatch Eventsの操作をするcli toolが見当たらなかったので作りました。

## なんでGolangか
### 1. クロスプラットフォーム
Golangはクロスコンパイルが容易にできる言語です。1つのソースから複数環境に適したバイナリを生成することができます。

手元のmacOSで実行したり、CIサービスで稼動しているLinux上での実行をしたりすることを考えると、クロスプラットフォーム対応は必須でしょう。

### 2. aws-sdkがある
Golang向けのaws-sdkがあるので、awsの機能を使用するプログラムが簡単に作成できます。

[aws/aws-sdk-go: AWS SDK for the Go programming language.](https://github.com/aws/aws-sdk-go)

### 3. やってみたかった
最大の理由です。

クロスプラットフォームも、aws-sdkも、どちらも僕の慣れているRubyで書くことにしても、同じ利点があります。

ただ、何か静的型付けでコンパイルする言語を学習しておきたいなと思ったので、Golangを選択しました。

## 名前の由来
隣の席の人に「どんな名前にしたらいいですかね」って聞いたら「maekawaでいいんじゃない」って言われたのでそうしました。

## つかいかた
READMEを読んでください。

あとまだ安定してないので実戦投入オススメしないです。直せてプルリク送れるレベルで使ったほうがいいです。

そこそこ安定したらversion 1.0.0にします。

もともと社内で使うために作ったので、そのへんも追々会社のブログに書こうと思います。
