---
title: Linuxでandroidの音楽管理
date: '2014-03-20'
tags:
- android
- howto
- linux
---

## 読み飛ばすところ

iPhoneやiPodを使っていると、iTunesの手軽さ、androidの不甲斐なさ(?)に気付く。
さて、iPhoneに機種変した僕の手元には、android端末が数個転がっている。HTC Butterfly jはBeat's audio搭載だし、Xperia SXはwalkmanアプリ搭載だしで放っておくには少しもったいない。これらandroid端末でも、iTunesのように手軽に音楽の管理ができないものか。

## 環境

ubuntu 13.10 64bitを使っているが、ディストリビューションで大差はないと思う。
端末は前述のHTC Butterfly jとXperia SXを用いる。

## メジャーな音楽管理ソフトウェア

ubuntuにデフォルトでインストールされるrhythmbox、一時期デフォルトだったBansheeがなかなかよい。
amarokは機能はいいだろうが、iTunesから移行しようとなるとUIが変わりすぎて取っ付きにくい(ように感じた)

## iTunesと比べて

### 外観

ぱっと見で似ているのはBansheeだろう。アルバムアートが並んで表示されているところはiTunesそっくりである。rhythmboxではアルバムアートを使って選曲する方法はわからなかった。

### 機能

どちらもiPodやandroidやその他メディアプレイヤーとの音楽ライブラリ同期機能は備えている。

### 安定性

気のせいか、Bansheeはエラーやフリーズが多い。

見た目似ているのはBansheeだけど、機能や安定性ではrhythmboxのほうがいいと思われる。ubuntuデフォルトだし。

## android端末に音楽を転送する際の下準備

### 接続プロトコルの変更

おそらくwindowsで音楽管理するなら転送プロトコル(端末をUSBでつないだ時の設定)は「MTP」になっている。Linux(ubuntu)でも「MTP」でのマウントは可能だが、rhythmbox(Bnashee)で音楽を転送しようとすると転送する楽曲の数だけエラーが出て使いものにならない。
よって、マウントは「MSC」(ファイル転送モード)に設定する必要がある。

![MSC](2014/manage-music-by-linux.png)
Xperiaでは設定→Xperia→USB接続設定から変更。HTC系端末では接続のたびに変更する必要があるかもしれない。

### .is_audio_playerの設定

接続プロトコルの変更を行うと、接続した時にただの外部ストレージとして認識され、音楽管理には向かない。
そこで、音楽を同期させる領域(おそらく外部SD)のルートフォルダに「.is_audio_player」というテキストファイルを作成する(linuxやandroidでは隠しファイルとなるのでファイルエクスプローラからは消えたようにみえる)
そして内容を以下のようにする。

```
audio_folders=Music/
folder_depth=2
output_formats=audio/aac,audio/mp3
```

内容の意味としては、「音楽を格納するのはMusicフォルダ、フォルダ構成はアーティスト名/アルバム名/音楽ファイルとする。再生できる拡張子はaac(m4a)とmp3」という内容である。拡張子の指定はMIMEで指定する。Wikipediaに載っているもののうちで一般的なものをまとめると以下の通りである。

| 拡張子 | MIME |
| --- | --- |
| wav | audio/x-wav |
| mp3 | audio/mpeg |
| aac | audio/aac |
| mp4(m4a) | audio/mp4 |
| flac | audio/x-flac |
| ogg | audio/ogg |
| wma | audio/x-ms-wma |

## CDから取り込む

今までに貯めこんできたライブラリと、これから取り込んでいくデータとでいろいろ変わる部分がある。

### 拡張子

iTunesだとおそらく.m4aなどになっていると思う。Linuxで扱いやすいのは.mp3か.oggか.flacだろう。もちろん.m4aも再生できないわけではないが。

### フォルダ構造

アーティスト/アルバム という構造になっていると思うが、アーティスト情報などが得られないことも予想される。アルバムごとで手打ちが必要になるかもしれない。1アルバム1フォルダ的な。

### CDDB

一番変わるのがここだろう。iTunesはgracenoteからCDの情報を取ってくるが、rhythmboxやBansheeではmusicbrainzから取ってくる？ようなので情報があれば御の字と言ったところ。洋楽のCDなどは情報がある可能性が高い。冊子を見ながら手打ちする必要があるかもしれない。
