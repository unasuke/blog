---
title: "Arctis 7で通話をしながらDJ配信をする"
date: 2020-04-16 21:37 JST
tags: 
- diary
---

![arctis 7](2020/arctis7.jpeg)

## オンライン飲み会でDJをする
皆さん、自宅待機生活はいかがお過ごしでしょうか。昨今はZoomやDiscordなどでビデオ通話をしながら飲み会をするというのが流行っていますね。
そんな会を盛り上げるために、DJをして会話のBGMをいい感じにしたいということがありますね。
ただ、DJをしながら通話に参加するには、ちょっと色々と工夫しないといけなかったので、それをメモとしてまとめます。

## 方法
### 準備するもの
まず前提として、DJはWindows上のrekordbox  5及びDDJ-RRで行いました。
これがmacOSの場合は多分こんな苦労は不要です。あくまでもWindows環境での話になります。
また、試せてはいませんがrekordbox 6でもおそらく同様の手順が使えると思います。

- Arctis 7
    - <https://jp.steelseries.com/gaming-headsets/arctis-7>
    - 恐らく他のArctisシリーズなどの「ゲームとチャットの音量バランスを調整できる」ようなヘッドセットなら可能である確率が高いです
    - <https://www.soundhouse.co.jp/products/detail/item/94565/> こういうもの
    - もしくは <https://www.soundhouse.co.jp/products/detail/item/225815/> と <https://www.soundhouse.co.jp/products/detail/item/94561/> の組み合わせです
        - DJやってるなら多分どこかにあると思います。変換プラグは無くてもいいこともありますね。

以上！


### やりかた
1. 標準のサウンドデバイスをPCのスピーカーにする
    - ![](2020/windows-sound-setting.png) 要はこういう状態ですね
2. PCのスピーカーの音量を絞っておく
    - ヘッドセットのマイクが音を拾わないようにするためです
3. ビデオ通話に使用する音声デバイスをArctis 7のChat側にする
    - ![](2020/discord-sound-setting.png) Discordだとこのような感じです
4. rekordboxのサウンド設定をこのように設定する
    - ![](2020/rekordbox-sound-setting.png) いわゆる「いつもの」設定
5. DJコントローラーのPHONESにArctis 7のステレオミニ端子を接続する
    - 「コンソールケーブル」は使いません。フォン端子とステレオミニを繋ぎます。
6. DJをする
    - この状態だと、CUEがGameサウンドとして、通話の音声はChatとして、MasterがPCのスピーカーから流れる状態になります。
7. 配信をする
    - 通話に参加しているみんなに聞いてもらう音声はストリーミングサービスのURLを渡すのが簡単だと思います。OBSなどでPCのmasterを配信すれば会話の内容は配信には乗らず、安心しておはなしできます。


## 最後に
AG03などのミキサーや、物理マシンがもうひとつあればもうすこしうまいことできる気がします。皆さんそれぞれのやり方を公開していただけると有り難いです。
