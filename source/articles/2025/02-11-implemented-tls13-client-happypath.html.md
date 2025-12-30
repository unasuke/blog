---
title: "TLS 1.3におけるclient側からのfull handshakeを(不完全ながら)実装した"
date: 2025-02-11 17:20 JST
tags: 
- openssl
- tls
- quic
- quic-impl-monthly-report
---

![](2025/tls13-client-happypath-ping.png)

## happy path
趣味でQUICの実装を、そしてその前段階としてTLS 1.3の実装をしている[^tls]者です。TLS 1.3のclient側からのfull handshakeをRubyで不完全ではありますが実装しました。上の画像で `====ping====` となっているのが自分の実装から送信し、OpenSSL側で復号できたメッセージです。

[^tls]: QUICの実装にあたり、完全なTLS 1.3の実装は必要ない(はず)と認識していますが、内包しているプロトコルは理解しておきたいというわがままです。

勝手にhappy pathと呼んでいるのですが、CipherSuiteは `TLS_AES_128_GCM_SHA256`、ClientHelloに含める拡張を SupportedVersions、KeyShare、SupportedAlgorhtmsのみとしてhandshakeを開始し、client側からFinishedを送信してhandshakeが完了するまでを実装しました。

<https://github.com/unasuke/raiha/tree/1996e5495d92b67d55158182815af24320186f91>

「不完全」と言っているのは、RFC 8446でMUSTとされているあらゆる検証をすっ飛ばし、正しいデータしか送られてこない/送らない前提、例えばAlert protocolの実装ができていないなどの状態になっているからです。

冒頭画像において、サーバー側実装にはOpenSSL 3.3.1を使用しています。詳しくは[「TLS実装のデバッグにOpenSSLが便利」](/2025/openssl-is-useful-for-debugging-tls13-implementation/)にて。


## future work
まずserver側の実装もして、自作実装どうしでfull handshakeを完遂できるように、そして現時点では完璧なメッセージのやりとりがされる前提でのコードを書いているので、各やりとりでMUSTとされている検証を行い、適切なAlertを送信できるようにしないといけません。

というわけで、これから毎月くらいのペースでQUIC実装進捗日記を書けたらな、と考えています。いつまで続けられるかはわかりませんし、あまりにも進捗がなければskipする月もあるとは思います。インスパイヤ元は[山本さんの「TLS 1.3 開発日記」](https://kazu-yamamoto.hatenablog.jp/entry/20161201/1480562947)です。期待せずお待ちください。
