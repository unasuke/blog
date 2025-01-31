---
title: "TLS実装のデバッグにOpenSSLが便利"
date: 2025-01-31 22:30 JST
tags: 
- openssl
- tls
---

![](2025/tls13-debugging-wireshark.png)

## 今更「便利」？
趣味でQUICの実装を、そしてその前段階としてTLS 1.3の実装をしている者です。今月中にfull handshakeまで実装しようと思っていたんですが、間に合いませんでした。なのでこの記事は小ネタです。

さて本題の「OpenSSLが便利」とは今更一体何を言ってるだという感じですが、実際便利です。備忘録がてら(僕の)使い方を書いておきます。OpenSSLのバージョンは3.3.1です。

## s\_serverとs\_client

* <https://docs.openssl.org/master/man1/openssl-s_client/>
* <https://docs.openssl.org/master/man1/openssl-s_server/>

OpenSSLには、s\_clientとs\_serverというコマンドがあります。TLS 1.3の実装をするにあたって、以下のようにテスト用のサーバー及びクライアントを動かすことができます。

```shell
$ openssl s_server -accept 4433 -cert tmp/server.crt -key tmp/server.key -tls1_3 -trace
$ openssl s_client -connect localhost:4433 -tls1_3 -keylogfile SSLKEYLOGFILE -CAfile tmp/server.crt
```

このとき、`tmp/server.key` 及び `tmp/server.crt` は自己証明書です。これを実際に実行してみると、次のような結果になります。左がs\_server、右がs\_clientです。

![](2025/tls13-debugging-openssl-s_server-and-s_client.png)

このスクリーンショットだけでも相当便利なのがわかると思います。さらに、ここで `-keylogfile SSLKEYLOGFILE` というオプションで `SSLKEYLOGFILE` を出力するようにしているため、例えば次のようなコマンドでpcapを取得していると、冒頭にも貼ったようにwiresharkでTLS Handshakeの中身をグラフィカルに見ることができます。

```shell
$ sudo tcpdump -i lo dst port 4433 or src port 4433 -w openssl_tls13.pcap
```

![](2025/tls13-debugging-wireshark.png)

以上小ネタでした。次回の記事ではTLSのfull handshakeを(不完全ではあるものの)実装した、という報告ができればいいですね……