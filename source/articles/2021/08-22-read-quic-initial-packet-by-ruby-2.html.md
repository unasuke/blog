---
title: "続・QUICのInitial packetをRubyで受けとる (curl編)"
date: 2021-08-22 18:07 JST
tags:
  - curl
  - ruby
  - quic
  - programming
  - internet
---

![QUIC と Ruby](2021/quic-ruby.png)

[前回の記事](/2021/read-quic-initial-packet-by-ruby)では、Appendix にある例示の packet をデコードするところまでやりました。この記事ではその続きとして、冒頭で受けとった curl からの packet をデコードして中身を見ることにします。

ですがこの記事を書くまでの間に、おりさのさんが parse に成功したものを gist に公開してくれていました！

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">QUIC の Initial packet を Ruby で受けとる | うなすけとあれこれ <a href="https://t.co/UBAjY5g88z">https://t.co/UBAjY5g88z</a> <br>これのプログラムをいじってcurlから受け取ったパケットをparseできるようにしていた.<a href="https://t.co/PqS7VEIFkh">https://t.co/PqS7VEIFkh</a><br>BinData::Stringが書き換えられなくて変な部分がある</p>&mdash; おりさの (@orisano) <a href="https://twitter.com/orisano/status/1425742957366235137?ref_src=twsrc%5Etfw">August 12, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

この記事では、おりさのさんの script を見つつ、もう少し先まで進んで CRYPTO frame の中身をちゃんと見るところまでやりたいと思います。

## おりさのさんの script と僕のものとの違い

これがおりさのさんの gist です。僕のものよりも関数に切り出されていたりとなかなか奇麗になコードに整形されています。

<https://gist.github.com/orisano/0efc65f96b81ca7c174fedd3431de611>

packet の保護を外すのも、 `QUICInitialPacket` のインスタンスメソッドになっていたりと、オブジェクト指向らしいコードになっています。本当にありがたいですね。

また、ちゃんと UDPSocket を作成しており、実行するだけで packet を受けとれるようになっています。

## ふたたび、curl からの Initial Packet を受けとる

それではこれを実行して、前回の記事のように Initial Packet を受けとり中身を表示させてみましょう。

```
$ ruby orisano_quic.rb
{:header_form=>1,
 :long_packet_type=>0,
 :packet_number_length=>0,
 :version=>1,
 :destination_connection_id_length=>16,
 :destination_connection_id=>
  "\xFC\xCCWh\xEE\xAE\xF1\x90R\xA2\xF6\xA5\xA2\xB2\x9C\x8D",
 :source_connection_id_length=>20,
 :source_connection_id=>
  "\xD7\xA6\x9B\x9Bhq\xD7\xC3\x04\x8A*\xB3\xA5\x13\x8D[\xACcV[",
 :token_length=>0,
 :token=>"",
 :len=>288}
{:frame_type=>6,
 :offset=>0,
 :len=>267,
 :data=>
  "\x01\x00\x01\a\x03\x03\x18,Ct_\x85h79\x10y\x86\x8A\x05d\x92\xA3a\xAE\x9D\xF2\xF6\xF9\x02\xE8\xC9\x93)\"\xE4\x86\e\x00\x00\x06\x13\x01\x13\x02\x13\x03\x01\x00\x00\xD8\x00\x00\x00\x0E\x00\f\x00\x00\t127.0.0.1\x00\n" +
  "\x00\b\x00\x06\x00\x1D\x00\x17\x00\x18\x00\x10\x00\x17\x00\x15\x02h3\x05h3-29\x05h3-28\x05h3-27\x00\r\x00\x14\x00\x12\x04\x03\b\x04\x04\x01\x05\x03\b\x05\x05\x01\b\x06\x06\x01\x02\x01\x003\x00&\x00$\x00\x1D\x00 \x83rx\x1ELvw\xFE\x9D\xC3[k\\=\x80\vw\x17N\xB2\xBFL\xA4g\xA4\xBE\x87\xE1\x1F\xF0\xD6w\x00-\x00\x02\x01\x01\x00+\x00\x03\x02\x03\x04\x009\x00L\x01\x04\x80\x00\xEA`\x03\x04\x80\x00\xFF\xF7\x04\x04\x80\x10\x00\x00\x05\x04\x80\x10\x00\x00\x06\x04\x80\x10\x00\x00\a\x04\x80\x10\x00\x00\b\x04\x80\x04\x00\x00\t\x04\x80\x04\x00\x00\n" +
  "\x01\x03\v\x01\x19\x0F\x14\xD7\xA6\x9B\x9Bhq\xD7\xC3\x04\x8A*\xB3\xA5\x13\x8D[\xACcV["}
```

と、このようになりました。この記事では、この CRYPTO frame の中身を見ていきます。

## CRYPTO frame を decode する

[RFC 9000 の CRYPTO frame の定義](https://www.rfc-editor.org/rfc/rfc9000.html#name-crypto-frames) では、 `cryptographic handshake messages` を transmit するとあります。また、[RFC 9001 の 4.1.3. Sending and Receiving Handshake Messages](https://www.rfc-editor.org/rfc/rfc9001#section-4.1.3-7) には、 `QUIC CRYPTO frames only carry TLS handshake messages.` とあります。もう少し読み進めて [RFC 9001 - 4.3. ClientHello Size](https://www.rfc-editor.org/rfc/rfc9001#name-clienthello-size) には、`ClientHello` が送られるとあります。

ということで TLS 1.3 の定義、 RFC 8446 での `Handshake` 及び `ClientHello` の定義を見てみましょう。

```
enum {
    client_hello(1),
    server_hello(2),
    new_session_ticket(4),
    end_of_early_data(5),
    encrypted_extensions(8),
    certificate(11),
    certificate_request(13),
    certificate_verify(15),
    finished(20),
    key_update(24),
    message_hash(254),
    (255)
} HandshakeType;

struct {
    HandshakeType msg_type;    /* handshake type */
    uint24 length;             /* remaining bytes in message */
    select (Handshake.msg_type) {
        case client_hello:          ClientHello;
        case server_hello:          ServerHello;
        case end_of_early_data:     EndOfEarlyData;
        case encrypted_extensions:  EncryptedExtensions;
        case certificate_request:   CertificateRequest;
        case certificate:           Certificate;
        case certificate_verify:    CertificateVerify;
        case finished:              Finished;
        case new_session_ticket:    NewSessionTicket;
        case key_update:            KeyUpdate;
    };
} Handshake;

uint16 ProtocolVersion;
opaque Random[32];

uint8 CipherSuite[2];    /* Cryptographic suite selector */

struct {
    ProtocolVersion legacy_version = 0x0303;    /* TLS v1.2 */
    Random random;
    opaque legacy_session_id<0..32>;
    CipherSuite cipher_suites<2..2^16-2>;
    opaque legacy_compression_methods<1..2^8-1>;
    Extension extensions<8..2^16-1>;
} ClientHello;
```

<https://www.rfc-editor.org/rfc/rfc8446.html#section-4>

ちょっと長いように見えますが、ClientHello のみに注目すればそこまでではありません。ここで、 `legacy_session_id` 、`cipher_suites` 、 `legacy_compression_methods` 、 `extensions` それぞれの長さがわからないように見えますが、 `fileld<floor..ceiling>` という表記があった場合、 まず `ceiling` を格納できる大きさの領域が先頭に存在しており、その領域で後続するデータの長さを表現するようになっています。 `legacy_session_id<0..32>` の場合では、32 までの数値を格納できるよう、まず先頭で 1 バイト使用して[^uint8]後続の長さを表現します。その後、その数だけのバイト長を読み、フィールドの値とします。

[^uint8]: 実のところ `32` は 6 bit ですが、 [RFC 8446 - 3.3. Numbers](https://datatracker.ietf.org/doc/html/rfc8446#section-3.3) に記載されるように基本的な数値型は an unsigned byte で表現されるのでこの場合は 1 byte です。

opaque でない field それぞれの中身を見ていきます。

`CipherSuite` の中身はなんでしょうか。 `uint8` が 2 つ連続した形式になっており、値によって使用される AEAD のアルゴリズムと HKDF でのハッシュ長が決まります。

<https://datatracker.ietf.org/doc/html/rfc8446#appendix-B.4> に実際の値があります。

`Extension` の中身はなんでしょうか。ちょっと長いので enum の定義は省略しますが、以下のような構造になっています。

```
struct {
    ExtensionType extension_type;
    opaque extension_data<0..2^16-1>;
} Extension;
```

<https://datatracker.ietf.org/doc/html/rfc8446#section-4.2>

`ExtensionType` に拡張の種類、 `extension_data` には拡張で使用する情報が入ります。

これで読めるようになったので、 CRYPTO frame の中身を decode してみましょう。

RFC の enum を定義し、 curl から Initial packet を受けとって decode するのが以下のコードになります。

<https://gist.github.com/unasuke/2fcf8e97a80c59bf943bf9b3d4fac964>

これまた長いので、gist への URL となります。また、[実はおりさのさんが ClientHello の decode をするコードを書いてくれていた(！)](https://gist.github.com/orisano/0efc65f96b81ca7c174fedd3431de611)ので、先ほどの gist は pretty print を行い、さらに見やすくしたものとなります。

実行すると、以下のように ClientHello の中身が読めるようになります！

![デコードされたTLS handshakeの様子](2021/decoded-tls-handshake.png)

TLS ClientHello の中に、 QUIC のためのパラメーターが含まれているのも読み取れますね。

ここで ClientHello の中身が何を意味しているかについては、ラムダノートさんから出ている「プロフェッショナル SSL/TLS」の 2 章に詳しいのでぜひ読んでみてください。

## 参考文献

- [Information on RFC 8446 » The Transport Layer Security (TLS) Protocol Version 1.3](https://www.rfc-editor.org/info/rfc8446)
- [『プロフェッショナル SSL/TLS』 – 技術書出版と販売のラムダノート](https://www.lambdanote.com/collections/ssl-tls)
- [QUIC をゆっくり解説(4)：ハンドシェイク | IIJ Engineers Blog](https://eng-blog.iij.ad.jp/archives/10582)
