---
title: "QUIC実装月報 2025年3月"
date: 2025-03-09 18:10 JST
tags: 
- quic
- tls
- quic-impl-monthly-report
---

![](2025/quic-impl-monthly-report-202503-openssl-client.png)

## diff
<https://github.com/unasuke/raiha/compare/1996e5495d92b67d55158182815af24320186f91...e9fad5bbedbd42212007d1005e65c23283249b15>

「QUIC実装月報」と言いながら今月もTLS 1.3のことしかやっていませんが。" 39 changed files with 854 additions and 229 deletions" というのが果たして多いのか少ないのか……もっと書けたかなという気持ちはあります。

## やったこと
[前回のfuture workとしていた](/2025/implemented-tls13-client-happypath/)「まずserver側の実装もして」は達成しました。自分がClientHelloを送るのに比べてOpenSSLからやってくるClientHelloに答えられるようにするには、ハードコードしていた各種値の前提が崩れてしまうので、より仕様に準拠した実装に近づける必要がありました。とはいえCipherSuiteとして `TLS_AES_128_GCM_SHA256` がやってくる前提はまだ置いています。OpenSSLはデフォルトでは `TLS_AES_256_GCM_SHA384` をClientHelloのCipherSuitesで一番先頭に持ってくるので、今後はそれに対応するのか、それともAlert protocolの実装を進めていくべきかは少し悩みどころです。あと、そもそもHelloRetryRequestもですね。これもまだ未対応です。

「自作実装どうしでfull handshakeを完遂できるように」については、次のようにやりとりができるようになりました。

![](2025/quic-impl-monthly-report-202503-self-roundtrip.png)

ちゃんと暗号でのやりとりができているのではないでしょうか……

具体的には以下のようなことをやりました。

* TLSのserver側としてのfull handshake flow実装( `TLS_AES_128_GCM_SHA256` のみ)
* シリアライズ、デシリアライズ時挙動をより仕様に準拠させた
    * CliehtHello内の `legacy_compression_method` や `legacy_session_id`
    * Record protocolの `legacy_record_version`
* テスト用のServer実装 (SimpleServer)
* TranscriptHashの導出を専用のClassに切り出し
* その他リファクタリング
    * 述語メソッドの導入など

引き続きやっていきたいです。
