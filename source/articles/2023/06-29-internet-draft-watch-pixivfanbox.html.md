---
title: "最近はpixivFANBOXにInternet-Draftを読んだ感想を書いています"
date: 2023-06-29 01:58 JST
tags:
- ietf
- quic
- tls
- pixivFANBOX
- diary
---

![流れてきたfeedの様子](2023/internet-draft-feed.png)

## TL;DR
<https://unasuke.fanbox.cc/tags/IETF>

## いきさつ
IETF Meetingに参加してから、QUIC WGやTLS WGの動向を追っておきたいなという気持ちになりました。

## やりかたとスタンス
どうやって追っているかというと、RSS feedを購読しています。具体的には以下のfeedを、[MonitoRSS](https://monitorss.xyz)を使ってDiscordに流しています。

* QUIC <https://datatracker.ietf.org/group/quic/documents/>
* Media Over QUIC <https://datatracker.ietf.org/group/moq/documents/>
* Transport Layer Security (TLS) <https://datatracker.ietf.org/group/tls/documents/>
* MLS (Messaging Layer Security) <https://datatracker.ietf.org/group/mls/documents/>
    * QUIC及びTLSの文脈というより、MastodonにおいてEnd-to-end encryptionによって保護されたDMを実現したいという文脈で言及されており追っておきたいため
        * <https://github.com/mastodon/mastodon/issues/19565>

そして更新が流れてきたタイミングで、内容を読んで思ったことを1〜2文程度で書き、pixivFANBOXに支援者限定で公開します。

このとき書く内容については単純に思ったことを書くのみで、技術的に正確だったり、なにかの学びになったりする内容にしようとはしていません。理由はそれが負担になって続けられなくなるのを避けるためです。これはRails及びMastodonにおいても同様です。

毎月末に、その月の投稿を1つにまとめて全体公開で再度投稿します。例えば5月は次のようになりました。

<https://unasuke.fanbox.cc/posts/6073778>

(5月まではDNS関連のdnsopとdpriveも追っていましたが、流量が多く負担が大きいのでやめました)
