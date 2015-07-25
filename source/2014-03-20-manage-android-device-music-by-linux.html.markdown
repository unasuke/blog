---
title: Linuxでandroidの音楽管理
date: '2014-03-20'
tags:
- android
- howto
- linux
---

<h2>読み飛ばすところ</h2>

iPhoneやiPodを使っていると、iTunesの手軽さ、androidの不甲斐なさ(?)に気付く。
さて、iPhoneに機種変した僕の手元には、android端末が数個転がっている。HTC Butterfly jはBeat's audio搭載だし、Xperia SXはwalkmanアプリ搭載だしで放っておくには少しもったいない。これらandroid端末でも、iTunesのように手軽に音楽の管理ができないものか。

<h2>環境</h2>

ubuntu 13.10 64bitを使っているが、ディストリビューションで大差はないと思う。
端末は前述のHTC Butterfly jとXperia SXを用いる。

<h2>メジャーな音楽管理ソフトウェア</h2>

ubuntuにデフォルトでインストールされるrhythmbox、一時期デフォルトだったBansheeがなかなかよい。
amarokは機能はいいだろうが、iTunesから移行しようとなるとUIが変わりすぎて取っ付きにくい(ように感じた)

<h2>iTunesと比べて</h2>

<h3>外観</h3>

ぱっと見で似ているのはBansheeだろう。アルバムアートが並んで表示されているところはiTunesそっくりである。rhythmboxではアルバムアートを使って選曲する方法はわからなかった。

<h3>機能</h3>

どちらもiPodやandroidやその他メディアプレイヤーとの音楽ライブラリ同期機能は備えている。

<h3>安定性</h3>

気のせいか、Bansheeはエラーやフリーズが多い。

見た目似ているのはBansheeだけど、機能や安定性ではrhythmboxのほうがいいと思われる。ubuntuデフォルトだし。

<h2>android端末に音楽を転送する際の下準備</h2>

<h3>接続プロトコルの変更</h3>

おそらくwindowsで音楽管理するなら転送プロトコル(端末をUSBでつないだ時の設定)は「MTP」になっている。Linux(ubuntu)でも「MTP」でのマウントは可能だが、rhythmbox(Bnashee)で音楽を転送しようとすると転送する楽曲の数だけエラーが出て使いものにならない。
よって、マウントは「MSC」(ファイル転送モード)に設定する必要がある。

[caption id="attachment_337" align="alignnone" width="168"]<a href="http://unasuke.com/wp/wp-content/uploads/2013/12/Screenshot_2013-12-08-00-00-53.png"><img class="size-medium wp-image-337" alt="Xperiaでは設定→Xperia→USB接続設定から変更。 HTC系端末では接続のたびに変更する必要があるかもしれない。" src="http://unasuke.com/wp/wp-content/uploads/2013/12/Screenshot_2013-12-08-00-00-53-168x300.png" width="168" height="300" /></a> Xperiaでは設定→Xperia→USB接続設定から変更。<br />HTC系端末では接続のたびに変更する必要があるかもしれない。[/caption]

<h3>.is_audio_playerの設定</h3>

接続プロトコルの変更を行うと、接続した時にただの外部ストレージとして認識され、音楽管理には向かない。
そこで、音楽を同期させる領域(おそらく外部SD)のルートフォルダに「.is_audio_player」というテキストファイルを作成する(linuxやandroidでは隠しファイルとなるのでファイルエクスプローラからは消えたようにみえる)
そして内容を以下のようにする。
<code>
audio_folders=Music/
folder_depth=2
output_formats=audio/aac,audio/mp3
</code>
内容の意味としては、「音楽を格納するのはMusicフォルダ、フォルダ構成はアーティスト名/アルバム名/音楽ファイルとする。再生できる拡張子はaac(m4a)とmp3」という内容である。拡張子の指定はMIMEで指定する。Wikipediaに載っているもののうちで一般的なものをまとめると以下の通りである。

<table><tbody>
<tr><th>拡張子</th><th>MIME</th></tr>
<tr><td>wav</td><td>audio/x-wav</td></tr>
<tr><td>mp3</td><td>audio/mpeg</td></tr>
<tr><td>aac</td><td>audio/aac</td></tr>
<tr><td>mp4(m4a)</td><td>audio/mp4</td></tr>
<tr><td>flac</td><td>audio/x-flac</td></tr>
<tr><td>ogg</td><td>audio/ogg</td></tr>
<tr><td>wma</td><td>audio/x-ms-wma</td></tr>
</tbody></table>

<h2>CDから取り込む</h2>

今までに貯めこんできたライブラリと、これから取り込んでいくデータとでいろいろ変わる部分がある。

<h3>拡張子</h3>

iTunesだとおそらく.m4aなどになっていると思う。Linuxで扱いやすいのは.mp3か.oggか.flacだろう。もちろん.m4aも再生できないわけではないが。

<h3>フォルダ構造</h3>

アーティスト/アルバム という構造になっていると思うが、アーティスト情報などが得られないことも予想される。アルバムごとで手打ちが必要になるかもしれない。1アルバム1フォルダ的な。

<h3>CDDB</h3>

一番変わるのがここだろう。iTunesはgracenoteからCDの情報を取ってくるが、rhythmboxやBansheeではmusicbrainzから取ってくる？ようなので情報があれば御の字と言ったところ。洋楽のCDなどは情報がある可能性が高い。冊子を見ながら手打ちする必要があるかもしれない。
