---
title: "EC2インスタンスにRDPで手軽に接続したい"
date: 2020-02-25 00:43 JST
tags: 
- aws
- windows
- ec2
---

![download rdp file dialog](2020/aws-console-rdp-download.png)

## どういうことがしたいのか
適当なWindowsが動いているEC2インスタンスがあり、それにリモートデスクトップしてもらいたいということが皆さんにもあるかと思います。そういう時、冒頭の画像にあるように、AWSコンソールからEC2インスタンスを作成し、「接続」からの「リモートデスクトップファイルのダウンロード」からダウンロードしたファイルを開くことで、ユーザーのパスワードを入力すればもう接続できる、というお手軽便利機能があります。

しかし、ざっとaws-sdkを眺めてみましたが、このファイルをAPI経由で取得する方法が見当りませんでした。

では、リモートデスクトップで作業してもらう人にAWSのコンソールには入ってほしくない、というときにはどうすればよいでしょう。

## RDPファイルの生成
ところで、ダウンロードしたRDPファイルを見てみると、中身はテキストになっていました。

```
auto connect:i:1
full address:s:ec2-192-0-2-1.ap-northeast-1.compute.amazonaws.com
username:s:Administrator
```

なんとなく自動で生成できそうに見えます。そして、それぞれがどのような値なのかがここに記載されていました。

[サポートされるリモート デスクトップ RDP ファイルの設定 | Microsoft Docs](https://docs.microsoft.com/ja-jp/windows-server/remote/remote-desktop-services/clients/rdp-files)

`auto connect:i:1` についてはこのドキュメントに記載がないので触らないようにして、`full address:s:`には いわゆる`Public DNS (IPv4)`を設定してやればよさそうです。

また接続するユーザーも、 `username:s:` で自由に設定できそうですね。

## まとめ
パスワードだけは別で伝えないといけないのは仕方ありませんが、作業のおまかせが手軽にできそうでよかったです。
