---
title: "QUIC の Initial packet を Ruby で受けとる"
date: 2021-08-11 18:59 JST
tags:
  - ruby
  - quic
  - programming
  - internet
---

![QUIC と Ruby](2021/quic-ruby.png)

## QUIC とは

QUIC は、今年 5 月に RFC 9000 や他いくつかの RFC によって標準化された、次世代のインターネットにおける通信プロトコルです。HTTP/3 では、この QUIC を下位層として使うことになっており、今後のより高速なインターネット通信において QUIC の占める役割は非常に大きなものとなるでしょう。

[QUIC is now RFC 9000 | Fastly](https://www.fastly.com/blog/quic-is-now-rfc-9000)

この記事では、QUIC による通信が始まる第一歩であるところの、Initial packet を Ruby で受けとってみることにします。

## はじめに

この記事内では、いくつかの外部の記事を参照しています。それらは QUIC の、ある時点での draft を参考に書いてあるものもありますが、この記事では RFC となった QUIC version 1 に対しての内容となります。

記事内の誤り、誤字脱字等は気軽に [twitter @yu_suke1994](https://twitter.com/yu_suke1994) にリプライしていただけると嬉しいです。

## UDP Packet を受けとる

QUIC では TCP ではなく UDP を使って通信します。つまり、Ruby で QUIC の Packet を受けとるために作成するのは UDP Socket になります。

以下のように Socket を作成し[^read-length]、そこに対して QUIC の Initial packet を送信してやります。

```ruby
require 'socket'

socket = UDPSocket.new
socket.bind("0.0.0.0", 8080)

begin
  raw_packet = socket.recvfrom_nonblock(2000)
rescue IO::WaitReadable
  retry
end

pp raw_packet[0]
```

ここで用意したポートに対して、どのように QUIC の Packet を送信すればいいでしょうか。ここでは、僕がビルドしている HTTP/3 に対応している curl を使用することにします[^curl]。docker-compose.yml の内容は割愛します。

<https://github.com/unasuke/curl-http3>

## Initial packet を parse する

さて、Initial packet を受信することができたので、中身を見てみます。

```
irb(main):001:0> raw_packet[0].unpack("H*")
=> ["c80000000110b61d55525ce5050363d471738ff245271476637acd05d5...
```

人間が読むようなものではありませんね。そこで、これを parse します。

QUIC の Packet の構造はこのようになっており、header と frame を持ちます。header には short header と long header の 2 種類があり、Initial packet は long header を持ちます。Initial packet は以下のような構造をしています。

```
Initial Packet {
  Header Form (1) = 1,
  Fixed Bit (1) = 1,
  Long Packet Type (2) = 0,
  Reserved Bits (2),
  Packet Number Length (2),
  Version (32),
  Destination Connection ID Length (8),
  Destination Connection ID (0..160),
  Source Connection ID Length (8),
  Source Connection ID (0..160),
  Token Length (i),
  Token (..),
  Length (i),
  Packet Number (8..32),
  Packet Payload (8..),
}
```

<https://www.rfc-editor.org/rfc/rfc9000.html#name-initial-packet>

この定義に従い packet を parse するのですが、ここで [bindata](https://rubygems.org/gems/bindata) という便利な gem を使います。使い方の説明は割愛しますが、以下のようなコードを書くことで今受け取った Initial packet を parse することができます。

ここで気をつけないといけないのが、上記構造でフィールドの長さが `(i)` となっているもの (Token length と Length) です。このフィールドは可変長で、 "Variable-Length Integer Encoding" という形式で表現されています。この形式は、まず先頭 2 ビット (two most significant bits) を読み、その値によって後続のバイト数が決まるようになっています[^protected]。

```ruby
require 'bindata'

def tms(bit)
  case bit
  when 0 then 6
  when 1 then 14
  when 2 then 30
  when 3 then 62
  end
end

class QUICInitialPacket < BinData::Record
  endian :big
  bit1 :header_form, asserted_value: 1
  bit1 :fixed_bit, asserted_value: 1
  bit2 :long_packet_type, asserted_value: 0
  bit2 :reserved_bit
  bit2 :packet_number_length
  bit32 :version
  bit8 :destination_connection_id_length
  bit :destination_connection_id, nbits:  lambda { destination_connection_id_length * 8 }
  bit8 :source_connection_id_length
  bit :source_connection_id, nbits: lambda{ source_connection_id_length * 8 }

  # Variable-Length Integer Encoding for token
  bit2 :token_two_most_significant_bits
  bit :token_length, nbits: lambda { tms(token_two_most_significant_bits) }
  string :token, read_length: lambda { token_length }

  # Variable-Length Integer Encoding for length
  bit2 :length_two_most_significant_bits
  bit :length_length, nbits: lambda { tms(length_two_most_significant_bits) }

  bit :packet_number, nbits: lambda { (packet_number_length + 1) * 8 }
  string :payload, read_length: lambda { length_length - (packet_number_length + 1) }
end

parsed_packet = QUICInitialPacket.read(raw_packet[0])
```

<https://www.rfc-editor.org/rfc/rfc9000.html#name-variable-length-integer-enc>

payload に frame が格納されます。 Initial packet の payload には何が入っているのでしょうか。Initial packet の payload には、CRYPTO frame というものが含まれているはず[^crypto]です。CRYPTO frame は以下のような構造をしています。

```
CRYPTO Frame {
  Type (i) = 0x06,
  Offset (i),
  Length (i),
  Crypto Data (..),
}
```

<https://www.rfc-editor.org/rfc/rfc9000.html#name-crypto-frames>

それでは、先ほど受けとった packet の `Packet Payload` は、先頭に `0x06` が含まれているはず[^crypto-first]ですね。見てみましょう。

```
irb(main):001:0> parsed_packet
=>
{:header_form=>1,
 :fixed_bit=>1,
 :long_packet_type=>0,
 :reserved_bit=>2,
 :packet_number_length=>0,
 :version=>1,
 :destination_connection_id_length=>16,
 :destination_connection_id=>242071802372027324022003629770543351079,
 :source_connection_id_length=>20,
 :source_connection_id=>675879382196389319306730800640250706941161587532,
 :token_two_most_significant_bits=>0,
 :token_length=>0,
 :token=>0,
 :length_two_most_significant_bits=>1,
 :length_length=>288,
 :payload=>
  "QuqI\xE6\xB10......
```

含まれていませんね。これはどうしてでしょうか。

現代のインターネットでは、通信は暗号化されてやりとりするのが一般的です。もちろん QUIC も暗号化した情報をやりとりするのが基本です。なので、この時経路上を流れていくパケットは暗号化されている[^vn]ため、まずは復号する必要があります。

## Initial packet を復号する (packet の保護を解く)

さて復号のためには、どのように暗号化されているのかを知る必要があります。

QUIC におけるパケットの暗号化、それも Initial packet に対して行われる保護については、[RFC 9001 - 5.2. Initial Secrets](https://www.rfc-editor.org/rfc/rfc9001#section-5.2) にその詳細があります。日本語では、[flano_yuki さんの記事 「QUIC の暗号化と鍵の導出について」](https://asnokaze.hatenablog.com/entry/2019/04/22/000927) や [kazu-yamamoto さんの記事 「QUIC 開発日記 その 1 参戦」](https://kazu-yamamoto.hatenablog.jp/entry/2019/02/08/135044) がわかりやすいです。

QUIC では、まず header を利用して payload を暗号化してから、その暗号化された内容を利用して header を保護します。そこで、復号のためには、まず payload から mask を得て header の保護を解除し、その後得られた header の平文を用いて payload を復号します。

この過程において行われていることは、前述の flano_yuki さんの記事内にて[引用されているスライド](https://docs.google.com/presentation/d/1OASDYIJlgSFg6hRkUjqdKfYTK1ZUk5VMGP3Iv2zQCI8/edit) の p24 及び p27 の図がとてもわかりやすいです。

ここからは実際に受けとった packet の情報をもとに作業をしていくのではなく、検証が容易になるよう[RFC 9001 に記載されている付録 A の値](https://www.rfc-editor.org/rfc/rfc9001#section-appendix.a)を用いて暗号化と復号をしてみます。

### RFC 9001 - Appendix A.2. でやってみる

まずは平文の packet を暗号化してみます。これが [Appendix A.2. にある CRYPTO frame の平文](https://www.rfc-editor.org/rfc/rfc9001#section-a.2)です。

```
060040f1010000ed0303ebf8fa56f12939b9584a3896472ec40bb863cfd3e868
04fe3a47f06a2b69484c00000413011302010000c000000010000e00000b6578
616d706c652e636f6dff01000100000a00080006001d00170018001000070005
04616c706e000500050100000000003300260024001d00209370b2c9caa47fba
baf4559fedba753de171fa71f50f1ce15d43e994ec74d748002b000302030400
0d0010000e0403050306030203080408050806002d00020101001c0002400100
3900320408ffffffffffffffff05048000ffff07048000ffff08011001048000
75300901100f088394c8f03e51570806048000ffff
```

これを暗号化していくのですが、このままでは 245 bytes であり、header を合わせても 1200 bytes には届きません。なので PADDING frame を付与して header を除く payload 全体を 1162 bytes まで増やします[^appendix-padding]。

```ruby
payload =
  "060040f1010000ed0303ebf8fa56f12939b9584a3896472ec40bb863cfd3e868" +
  "04fe3a47f06a2b69484c00000413011302010000c000000010000e00000b6578" +
  "616d706c652e636f6dff01000100000a00080006001d00170018001000070005" +
  "04616c706e000500050100000000003300260024001d00209370b2c9caa47fba" +
  "baf4559fedba753de171fa71f50f1ce15d43e994ec74d748002b000302030400" +
  "0d0010000e0403050306030203080408050806002d00020101001c0002400100" +
  "3900320408ffffffffffffffff05048000ffff07048000ffff08011001048000" +
  "75300901100f088394c8f03e51570806048000ffff" +
  ("00" * 917) # PADDING frame
```

これを暗号化します。どのように行うのかは [RFC 9001 - 5. Packet Protection](https://www.rfc-editor.org/rfc/rfc9001#section-5) に定義があり、Initial packet については `AEAD_AES_128_GCM` を用いて暗号化します。この AEAD については [RFC 5116](https://www.rfc-editor.org/info/rfc5116) に定義されており、暗号化に必要なパラメーターは以下の 4 つです[^aead]。

- K (secret key)
- N (nonce)
- P (plaintext)
- A (associated data)

これらの入力から、 C (ciphertext) が得られます。それぞれの入力を見ていきます。

K、 secret key ですが、[RFC 5869](https://www.rfc-editor.org/info/rfc5869) に定義されている鍵導出関数、HKDF を使用して導出します。ここで、まず初期 secret の導出のため、 `HKDF-Extract` の入力に QUIC の場合は `0x38762cf7f55934b34d179ae6a4c80cadccbb7f0a` と Destination Connection ID (この Appendix では `0x8394c8f03e515708`)[^appendix-dci] を使用します。

この HDKF ですが、一般に `HKDF-Extract` の後に `HKDF-Expand` を使用して最終的な鍵を得ます。そのため、Ruby の OpenSSL gem にも、この過程を一度に行うための `OpenSSL::KDF.hkdf` という関数[^ruby-openssl-hkdf]があります。しかし、QUIC (および TLS 1.3)ではこれをそのまま使うことができません。理由は、RFC 5869 での定義の他に、[RFC 8446 (TLS 1.3)](https://www.rfc-editor.org/info/rfc8446) で定義されている `HKDF-Expand-Label(Secret, Label, Context, Length)` という関数[^hkdf-expand-label]が必要なためです。

ありがたいことに、Ruby による TLS 1.3 実装 [thekuwayama/tttls1.3](https://github.com/thekuwayama/tttls1.3) に `HKDF-Expand-Label` の実装があるので、これを使って鍵を導出します。

```ruby
require 'openssl'
require 'tttls1.3/key_schedule'

def hkdf_extract(salt, ikm)
  ::OpenSSL::HMAC.digest('SHA256', salt, ikm)
end

initial_salt = ["38762cf7f55934b34d179ae6a4c80cadccbb7f0a"].pack("H*")
destination_connection_id = ["8394c8f03e515708"].pack("H*")

initial_secret = hkdf_extract(initial_salt, destination_connection_id)
# initial_secret.unpack1("H*") => "7db5df06e7a69e432496adedb00851923595221596ae2ae9fb8115c1e9ed0a44"

client_initial_secret = TTTLS13::KeySchedule.hkdf_expand_label(initial_secret, 'client in', '', 32, 'SHA256')
# client_initial_secret.unpack1("H*") => "c00cf151ca5be075ed0ebfb5c80323c42d6b7db67881289af4008f1f6c357aea"

key = TTTLS13::KeySchedule.hkdf_expand_label(client_initial_secret, 'quic key', '', 16, 'SHA256')
# key.unpack1("H*") => "1f369613dd76d5467730efcbe3b1a22d"

iv = TTTLS13::KeySchedule.hkdf_expand_label(client_initial_secret, 'quic iv', '', 12, 'SHA256')
# iv.unpack1("H*") => "fa044b2f42a3fd3b46fb255c"

hp = TTTLS13::KeySchedule.hkdf_expand_label(client_initial_secret, 'quic hp', '', 16, 'SHA256')
# hp.unpack1("H*") => "9f50449e04a0e810283a1e9933adedd2"
```

このようにして、[A.1 Keys](https://www.rfc-editor.org/rfc/rfc9001#section-a.1) と同様の鍵を得ることができました。

では暗号化していきます。[RFC 9001 - 5.3. AEAD Usage](https://www.rfc-editor.org/rfc/rfc9001#name-aead-usage) によれば、AEAD に渡すパラメータは以下のように定義されます。

- K (secret key)
  - 先程計算した key
- N (nonce)
  - 先程計算した iv と パケット番号の排他的論理和 (XOR) 。 この Appendix の場合、パケット番号は 2
- P (plaintext)
  - QUIC パケットの payload
- A (associated data)
  - QUIC header の内容、保護されていない先頭からパケット番号までの内容。この Appendix の場合は `c300000001088394c8f03e5157080000449e00000002`[^appendix-initial-header]

これらから、以下のようなコードで暗号化された payload を得ることができました。

```ruby
payload =
  "060040f1010000ed0303ebf8fa56f12939b9584a3896472ec40bb863cfd3e868" +
  "04fe3a47f06a2b69484c00000413011302010000c000000010000e00000b6578" +
  "616d706c652e636f6dff01000100000a00080006001d00170018001000070005" +
  "04616c706e000500050100000000003300260024001d00209370b2c9caa47fba" +
  "baf4559fedba753de171fa71f50f1ce15d43e994ec74d748002b000302030400" +
  "0d0010000e0403050306030203080408050806002d00020101001c0002400100" +
  "3900320408ffffffffffffffff05048000ffff07048000ffff08011001048000" +
  "75300901100f088394c8f03e51570806048000ffff" +
  ("00" * 917)

encryptor = OpenSSL::Cipher.new("AES-128-GCM")
encryptor.encrypt
encryptor.key = key
nonce = (iv.unpack1("H*").to_i(16) ^ 2).to_s(16)
encryptor.iv = [nonce].pack("H*")
encryptor.auth_data = ["c300000001088394c8f03e5157080000449e00000002"].pack("H*")

protected_payload = ""
protected_payload << encryptor.update([payload].pack("H*"))
protected_payload << encryptor.final
protected_payload << encryptor.auth_tag

pp protected_payload.unpack1("H*")
# => d1b1c98dd7689fb8ec11
# d242b123dc9bd8bab936b47d92ec356c0bab7df5976d27cd449f63300099f399
# 1c260ec4c60d17b31f8429157bb35a1282a643a8d2262cad67500cadb8e7378c
# 8eb7539ec4d4905fed1bee1fc8aafba17c750e2c7ace01e6005f80fcb7df6212
# 30c83711b39343fa028cea7f7fb5ff89eac2308249a02252155e2347b63d58c5
# 457afd84d05dfffdb20392844ae812154682e9cf012f9021a6f0be17ddd0c208
# 4dce25ff9b06cde535d0f920a2db1bf362c23e596d11a4f5a6cf3948838a3aec
# 4e15daf8500a6ef69ec4e3feb6b1d98e610ac8b7ec3faf6ad760b7bad1db4ba3
# 485e8a94dc250ae3fdb41ed15fb6a8e5eba0fc3dd60bc8e30c5c4287e53805db
# 059ae0648db2f64264ed5e39be2e20d82df566da8dd5998ccabdae053060ae6c
# 7b4378e846d29f37ed7b4ea9ec5d82e7961b7f25a9323851f681d582363aa5f8
# 9937f5a67258bf63ad6f1a0b1d96dbd4faddfcefc5266ba6611722395c906556
# be52afe3f565636ad1b17d508b73d8743eeb524be22b3dcbc2c7468d54119c74
# 68449a13d8e3b95811a198f3491de3e7fe942b330407abf82a4ed7c1b311663a
# c69890f4157015853d91e923037c227a33cdd5ec281ca3f79c44546b9d90ca00
# f064c99e3dd97911d39fe9c5d0b23a229a234cb36186c4819e8b9c5927726632
# 291d6a418211cc2962e20fe47feb3edf330f2c603a9d48c0fcb5699dbfe58964
# 25c5bac4aee82e57a85aaf4e2513e4f05796b07ba2ee47d80506f8d2c25e50fd
# 14de71e6c418559302f939b0e1abd576f279c4b2e0feb85c1f28ff18f58891ff
# ef132eef2fa09346aee33c28eb130ff28f5b766953334113211996d20011a198
# e3fc433f9f2541010ae17c1bf202580f6047472fb36857fe843b19f5984009dd
# c324044e847a4f4a0ab34f719595de37252d6235365e9b84392b061085349d73
# 203a4a13e96f5432ec0fd4a1ee65accdd5e3904df54c1da510b0ff20dcc0c77f
# cb2c0e0eb605cb0504db87632cf3d8b4dae6e705769d1de354270123cb11450e
# fc60ac47683d7b8d0f811365565fd98c4c8eb936bcab8d069fc33bd801b03ade
# a2e1fbc5aa463d08ca19896d2bf59a071b851e6c239052172f296bfb5e724047
# 90a2181014f3b94a4e97d117b438130368cc39dbb2d198065ae3986547926cd2
# 162f40a29f0c3c8745c0f50fba3852e566d44575c29d39a03f0cda721984b6f4
# 40591f355e12d439ff150aab7613499dbd49adabc8676eef023b15b65bfc5ca0
# 6948109f23f350db82123535eb8a7433bdabcb909271a6ecbcb58b936a88cd4e
# 8f2e6ff5800175f113253d8fa9ca8885c2f552e657dc603f252e1a8e308f76f0
# be79e2fb8f5d5fbbe2e30ecadd220723c8c0aea8078cdfcb3868263ff8f09400
# 54da48781893a7e49ad5aff4af300cd804a6b6279ab3ff3afb64491c85194aab
# 760d58a606654f9f4400e8b38591356fbf6425aca26dc85244259ff2b19c41b9
# f96f3ca9ec1dde434da7d2d392b905ddf3d1f9af93d1af5950bd493f5aa731b4
# 056df31bd267b6b90a079831aaf579be0a39013137aac6d404f518cfd4684064
# 7e78bfe706ca4cf5e9c5453e9f7cfd2b8b4c8d169a44e55c88d4a9a7f9474241
# e221af44860018ab0856972e194cd934
#
# https://www.rfc-editor.org/rfc/rfc9001#section-a.2-7 の内容からheader部分を除いたものと同じ
```

次に、この暗号化された payload を sampling したものをもとに header を保護します。このあたりは、 <https://tex2e.github.io/blog/crypto/quic-tls#ヘッダの暗号化> に、このようになっている理由の日本語による解説があります。

どの部分からどの部分までを sampling するかは、 [RFC 9001 - 5.4.2. Header Protection Sample](https://www.rfc-editor.org/rfc/rfc9001#name-header-protection-sample) に計算式があるので、Initial packet の場合の式を以下に記載します。

```
pn_offset = 7 + len(destination_connection_id) + len(source_connection_id) + len(payload_length)
pn_offset += len(token_length) + len(token) # 特にInitial packetの場合
sample_offset = pn_offset + 4

# sample_length は、AES を使用する場合は 16 bytes
# https://www.rfc-editor.org/rfc/rfc9001#section-5.4.3-2
sample = packet[sample_offset..sample_offset+sample_length]
```

それでは計算していきましょう。Appendix では、header は `c300000001088394c8f03e5157080000449e00000002` でした[^appendix-initial-header]。destination_connection_id は `8394c8f03e515708` なので 8 bytes、 source_connection_id はないので 0 byte、 payload_length は `449e` なので 2 bytes、 token length は `0` なので 1 byte、 token 自体は無いので 0 byte となり、 `pn_offset` は 18 になります。よって `sample_offset` は 22 bytes となります。

なので、packet の先頭から 22 bytes 進み、そこから 16 bytes を取得すると `d1b1c98dd7689fb8ec11d242b123dc9b` になります。

ここから mask を導出します。AES を使用する場合の mask の導出は [RFC 9001 - 5.4.3. AES-Based Header Protection](https://www.rfc-editor.org/rfc/rfc9001#name-aes-based-header-protection) に定義されており、これを Ruby で行うのが以下のコードになります。

```ruby
enc = OpenSSL::Cipher.new('aes-128-ecb')
enc.encrypt

# hp
enc.key = ["9f50449e04a0e810283a1e9933adedd2"].pack("H*")

sample = "d1b1c98dd7689fb8ec11d242b123dc9b"

mask = ""
mask << enc.update([sample].pack("H*"))
mask << enc.final
pp mask.unpack1("H*")
# => "437b9aec36be423400cdd115d9db3241aaf1187cd86d6db16d58ab3b443e339f"
```

それでは得られた mask を元に、header の保護をしてみましょう。

```ruby
# https://www.rfc-editor.org/rfc/rfc9001#section-a.2-6
header = "c300000001088394c8f03e5157080000449e00000002"
mask = "437b9aec36be423400cdd115d9db3241aaf1187cd86d6db16d58ab3b443e339f"

# Appendixの例と範囲が異なるのは、文字列で保持しているため
# 2文字 => 1 byte
header[0..1] = (header[0..1].to_i(16) ^ (mask[0..1].to_i(16) & '0f'.to_i(16))).to_s(16)
header[36..43] = (header[36..43].to_i(16) ^ mask[2..9].to_i(16)).to_s(16)

pp header
# => "c000000001088394c8f03e5157080000449e7b9aec34"
```

このようにして得られた保護された header と、暗号化された payload を結合することで Appendix にある "resulting protected packet"[^appendix-protected-result] と同様のものを得ることができました。

それではここまでの手順を逆に辿り、暗号化された packet の復号をやってみましょう。これは長いので、完全版を gist に置き、ここには抜粋したものを掲載します。

<https://gist.github.com/unasuke/b30a4716248b1831bd428af3b7829ce7>

```ruby
require 'openssl'
require 'bindata'

class QUICInitialPacket < BinData::Record
  # ....
end

class QUICProtectedInitialPacket < BinData::Record
  # ....
end

class QUICCRYPTOFrame < BinData::Record
  endian :big
  bit8 :frame_type, asserted_value: 0x06
  bit2 :offset_two_most_significat_bits
  bit :offset, nbits: lambda { tms(offset_two_most_significat_bits) }
  bit2 :length_two_most_significant_bits
  bit :length_length, nbits: lambda { tms(length_two_most_significant_bits) }
  string :data, read_length: lambda { length_length }
end

raw_packet = [
  "c000000001088394c8f03e5157080000449e7b9aec34d1b1c98dd7689fb8ec11" +
  # .......
].pack("H*")

packet = QUICProtectedInitialPacket.read(raw_packet)

# ここからheaderの保護を解除するためのコード
pn_offset = 7 +
  packet.destination_connection_id_length +
  packet.source_connection_id_length +
  (tms(packet.length_two_most_significant_bits) + 2) / 8 +
  (tms(packet.token_two_most_significant_bits) + 2) / 8 +
  packet.token_length

sample_offset = pn_offset + 4

sample = raw_packet[sample_offset...sample_offset+16]

enc = OpenSSL::Cipher.new('aes-128-ecb')
enc.encrypt

enc.key = ["9f50449e04a0e810283a1e9933adedd2"].pack("H*") # hp
mask = ""
mask << enc.update(sample)
mask << enc.final

# https://www.rfc-editor.org/rfc/rfc9001#name-header-protection-applicati
# headerを保護するときとは逆の手順を踏んで保護を解除する
raw_packet[0] = [(raw_packet[0].unpack1('H*').to_i(16) ^ (mask[0].unpack1('H*').to_i(16) & 0x0f)).to_s(16)].pack("H*")

# https://www.rfc-editor.org/rfc/rfc9001#figure-6
pn_length = (raw_packet[0].unpack1('H*').to_i(16) & 0x03) + 1

packet_number =
  (raw_packet[pn_offset...pn_offset+pn_length].unpack1("H*").to_i(16) ^ mask[1...1+pn_length].unpack1("H*").to_i(16)).to_s(16)

# 先頭の0が消えてしまうので、パケット番号の長さに満たないぶんを zero fillする
raw_packet[pn_offset...pn_offset+pn_length] = [("0" * (pn_length * 2 - packet_number.length)) + packet_number].pack("H*")

# headerの保護が外れたpacket (payloadはまだ暗号)
packet = QUICInitialPacket.read(raw_packet)

# 復号のためheaderのみを取り出す
header_length = raw_packet.length - packet.payload.length

# payloadの復号
dec = OpenSSL::Cipher.new('aes-128-gcm')
dec.decrypt
dec.key = ["1f369613dd76d5467730efcbe3b1a22d"].pack("H*") # quic key
dec.iv = [("fa044b2f42a3fd3b46fb255c".to_i(16) ^ packet.packet_number).to_s(16)].pack("H*") # quic iv
dec.auth_data = raw_packet[0...(raw_packet.length - packet.payload.length)]
dec.auth_tag = packet.payload[packet.payload.length-16...packet.payload.length]

payload = ""
payload << dec.update(packet.payload[0...packet.payload.length-16])
payload << dec.final

# 復号したpayloadをCRYPTO frameとしてparse
pp QUICCRYPTOFrame.read(payload)
# => {:frame_type=>6,
# :offset_two_most_significat_bits=>0,
# :offset=>0,
# :length_two_most_significant_bits=>1,
# :length_length=>241,
# :data=>
#  "\x01\x00\x00\xED\x03\x03\xEB\xF8\xFAV\xF1)9\xB9XJ8\x96G.\xC4\v\xB8c\xCF\xD3\xE8h\x04\xFE:G\xF0j+iHL" +
#  "\x00\x00\x04\x13\x01\x13\x02\x01\x00\x00\xC0\x00\x00\x00\x10\x00\x0E\x00\x00\vexample.com\xFF\x01\x00\x01\x00\x00\n" +
#  "\x00\b\x00\x06\x00\x1D\x00\x17\x00\x18\x00\x10\x00\a\x00\x05\x04alpn\x00\x05\x00\x05\x01\x00\x00\x00\x00" +
#  ....
```

CRYPTO frame の中に何やらそれらしき文字列が出現していることから、payload の復号に成功したことがうかがえますね。

実際に curl から受けとった packet の parse もやっていきたいところですが、一旦この記事ではここまでとします。

## さいごに

プロトコルの理解は、実際に手を動かしてみるのが一番ですね。

記事内の誤り、誤字脱字等は気軽に [twitter @yu_suke1994](https://twitter.com/yu_suke1994) にリプライしていただけると嬉しいです。

記事をチェックしてくれた [あらやくん](https://twitter.com/arayaryoma) と [おりさのくん](https://twitter.com/orisano) と [とちくじさん](https://twitter.com/tochikuji) に感謝します。

## 追記

- 2021-08-12 12:30 コードを少し修正しました

## 参考文献

- <https://quicwg.org/>
  - [RFC 9000: QUIC: A UDP-Based Multiplexed and Secure Transport](https://www.rfc-editor.org/rfc/rfc9000.html)
  - [RFC 9001: Using TLS to Secure QUIC](https://www.rfc-editor.org/rfc/rfc9001.html)
- [RFC 8446 » The Transport Layer Security (TLS) Protocol Version 1.3](https://www.rfc-editor.org/info/rfc8446)
- [RFC 5869 » HMAC-based Extract-and-Expand Key Derivation Function (HKDF)](https://www.rfc-editor.org/info/rfc5869)
- [RFC 5116» An Interface and Algorithms for Authenticated Encryption](https://www.rfc-editor.org/info/rfc5116)
- [n 月刊ラムダノート Vol.2, No.1(2020) – 技術書出版と販売のラムダノート](https://www.lambdanote.com/collections/frontpage/products/nmonthly-vol-2-no-1-2020)
- [QUIC のパケット暗号化プロセス | 晴耕雨読](https://tex2e.github.io/blog/crypto/quic-tls)
- [mozilla/neqo: Neqo, an Implementation of QUIC written in Rust](https://github.com/mozilla/neqo)
- [cloudflare/quiche: 🥧 Savoury implementation of the QUIC transport protocol and HTTP/3](https://github.com/cloudflare/quiche)
- [aiortc/aioquic: QUIC and HTTP/3 implementation in Python](https://github.com/aiortc/aioquic)
- [thekuwayama/tttls1.3: TLS 1.3 implementation in Ruby (Tiny Trial TLS1.3 aka tttls1.3)](https://github.com/thekuwayama/tttls1.3)
- [QUIC の暗号化と鍵の導出について - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2019/04/22/000927)
- [WEB+DB PRESS Vol.123 ｜技術評論社](https://gihyo.jp/magazine/wdpress/archive/2021/vol123)
- [QUIC 開発日記 その 1 参戦 - あどけない話](https://kazu-yamamoto.hatenablog.jp/entry/2019/02/08/135044)
- [QUIC Security NDSS QUIPS Workshop, February 2020 Martin Thomson - Google スライド](https://docs.google.com/presentation/d/1OASDYIJlgSFg6hRkUjqdKfYTK1ZUk5VMGP3Iv2zQCI8/edit#slide=id.g4d4095d44b_0_211)

[^vn]: 例外もあります。例えば Version Negotiagion パケットは保護されません。 <https://www.rfc-editor.org/rfc/rfc9001#section-5-3.1>
[^crypto]: TLS handshake を行うため。 <https://www.rfc-editor.org/rfc/rfc9001#name-carrying-tls-messages>
[^crypto-first]: 先頭にあるとは限りませんし、どのみちこの時点では暗号化されており `0x06` の存在を確認することはできません。 <https://www.rfc-editor.org/rfc/rfc9000.html#section-17.2.2-8>
[^read-length]: 最低でも 1200 bytes は受信できるようにする必要があります。特に Initial packet については、必ず 1200 bytes 以上のサイズになるように PADDING などを行う必要があります。 <https://www.rfc-editor.org/rfc/rfc9000.html#name-datagram-size>
[^aead]: <https://www.rfc-editor.org/rfc/rfc5116.html#section-2.1>
[^hkdf-expand-label]: <https://www.rfc-editor.org/rfc/rfc8446.html#section-7.1>
[^ruby-openssl-hkdf]: <https://docs.ruby-lang.org/en/3.0.0/OpenSSL/KDF.html#method-c-hkdf>
[^appendix-padding]: <https://www.rfc-editor.org/rfc/rfc9001#section-a.2-1>
[^appendix-initial-header]: <https://www.rfc-editor.org/rfc/rfc9001#section-a.2-4>
[^appendix-protected-result]: <https://www.rfc-editor.org/rfc/rfc9001#section-a.2-7>
[^protected]: 厳密には、この時点で parse を行うことはできません。後述する packet の保護を解除しないと正しい情報は得られません。
[^curl]: もっと手軽に実験するなら、Python の環境があるなら aioquic 、Rust の環境を用意するのが苦でないなら Neqo を使うのもいいと思います。なかなかビルド済バイナリを落としてくるだけで使用できる QUIC クライアントがないのが現状です。
[^appendix-dci]: <https://www.rfc-editor.org/rfc/rfc9001#section-appendix.a-1>
