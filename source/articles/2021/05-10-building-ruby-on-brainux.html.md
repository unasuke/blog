---
title: 電子辞書 "Brain" 上でRuby 3.0をビルドするのには○○時間かかる
date: 2021-05-10 08:41 JST
tags: 
- linux
- ruby
- brainux
---


## Brain上ではLinuxが動きます、つまり
[puhitaku](https://twitter.com/puhitaku)さんが、SHARPの電子辞書 「Brain」 上で動作するLinux distribusion 「Brainux」を開発、公開しています。

- <https://brainux.org/>
- [電子辞書は組み込みLinuxの夢を見るか？ - Zopfcode](https://www.zopfco.de/entry/sharp_brain_linux)

Linuxが動くと、色々なことができるようになります。

そこで、普段Rubyを使っている僕はあることを思いつきました。

**「電子辞書上のLinuxでRubyをビルドすると何時間かかるんだろう？」**

これってトリビアになりませんか？

## やってみる
はじめに参考情報として、GCP e2-medium (vCPU 2, Mem 4GB) でbuildした場合は11分かかりました。

```shell
me@ruby-build:~$ time rbenv install 3.0.1
Downloading ruby-3.0.1.tar.gz...
-> https://cache.ruby-lang.org/pub/ruby/3.0/ruby-3.0.1.tar.gz
Installing ruby-3.0.1...
Installed ruby-3.0.1 to /home/me/.rbenv/versions/3.0.1


real    11m5.652s
user    16m57.434s
sys     1m57.655s
```

### 物理的な準備
という訳で、まずは電子辞書を入手することにしました。

メルカリで中古のBrain PW-SH2-B を購入し、OTGアダプタやmicroSDも合わせて購入して、以下のような環境を構築しました。

![物理準備の様子](2021/brainux-overview.jpeg)

- Brain PW-SH2-B
- OTGアダプタ  RouteR RUH-OTGU4
    - <https://www.amazon.co.jp/gp/product/B010EFZISY/>
- USB LANアダプタ  EDC-GUA3-B
    - <https://www.elecom.co.jp/products/EDC-GUA3-B.html>
- キーボード
- microSDカード


### OS imageの準備
Brainuxのイメージは、 <https://github.com/brain-hackers/buildbrain/releases> でビルド済みのものが配布されています。ただ試すだけであればこれをmicroSDに焼くだけで済みます。しかし、これからRubyのbuildや、そのために必要なパッケージのインストール、他にも様々なことを試して遊ぼうとすると、配布されているOS含め3GBのイメージというのは少々心許ないです。
というのも、BrainuxはRaspberry Piのような起動時の容量自動拡張機能がまだ用意されていないため、microSDの空き容量一杯までFSを伸張されることがなく、焼いたimageの容量以上に使用することができません。

そこで「自分でビルドする」という選択が出てきます。これは一見ハードルが高そうですが、 <https://github.com/brain-hackers/buildbrain> をcloneしてREADMEに従いmakeを何度か実行するだけでimageは出来上がるので簡単です。(時間はそれなりにかかります)

また、この過程において、 `image/build_imaege.sh` を次のように変更することで、容量を自由に設定することができます。今回は6GB程度にしてみました。

```diff
diff --git a/image/build_image.sh b/image/build_image.sh
index 73aaf85..9b07fa5 100755
--- a/image/build_image.sh
+++ b/image/build_image.sh
@@ -25,7 +25,7 @@ for i in $(seq 1 7); do
     esac
 done
 
-dd if=/dev/zero of=${IMG} bs=1M count=3072
+dd if=/dev/zero of=${IMG} bs=1M count=6000 # ここをいじるだけ！
 
 START1=2048
 SECTORS1=$((1024 * 1024 * 64 / 512))
```

### Swap領域の用意
build中に何度かメモリ不足によって失敗したので、多めにSwap領域を用意します。これも公式の導入に載っているものをそのまま実行すれば完了です。

[https://github.com/brain-hackers/README/wiki/Tips＞Swap](https://github.com/brain-hackers/README/wiki/Tips%EF%BC%9ESwap)

```shell
$ sudo dd if=/dev/zero of=/var/swap bs=1M count=2048
$ sudo mkswap /var/swap
$ sudo swapon /var/swap
```

ここでは2GB用意しましたが、buildの過程を見ていた限りでは公式の通り256MB程度でよさそうに見えました。

 ### ca-certificatesの用意
現時点での最新版リリースでは、起動したばかりの状態では証明書に問題があるためにHTTPS通信ができず、Rubyのソースコードをダウンロードすることができません。なので、公式のScrapboxにTODOとして記載されているコマンドを実行します。

<https://scrapbox.io/brain-hackers/Brainux_TODO>

```shell
$ sudo wget -O /etc/ssl/certs/cacert.pem http://curl.se/ca/cacert.pem
$ sudo update-ca-certificates -f
```

### rbenv、ruby-buildの準備
Rubyをbuildするために、rbenvとruby-buildを導入します。Rubyそのもののソースコードをcloneしないのは、このほうがRubyのversion切り替えなどで楽なためです。

```shell
$ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
$ git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
# 公式記載の手順を諸々やっていく
```

### ビルド、開始
それでは、timeコマンド経由でbuildして、どのくらい時間がかかるか見てみます。

```shell
$ time rbenv install 3.0.1
```

ビルド時間は12時間を突破し……

![途中経過](2021/brainux-building-ruby.jpeg)

終わりました。


![終わり](2021/brainux-build-ruby-done.jpeg)

なんと839分もかかりました。

![終わり ズームイン](2021/brainux-build-ruby-done-zoom.jpeg)

839分、わかりやすく書けば **13時間59分** となります。

```shell
$ time rbenv install 3.0.1
Downloading ruby-3.0.1.tar.gz...
-> https://cache.ruby-lang.org/pub/ruby/3.0/ruby-3.0.1.tar.gz
Installing ruby-3.0.1...
Installed ruby-3.0.1 to /home/me/.rbenv/versions/3.0.1


real    839m45.175s
user    689m25.604s
sys     40m30.894s
```

ということで、 **「電子辞書上のLinuxでRubyをビルドするのにかかる時間は"13時間59分"」** です。

## 参考情報
このBrain上で `cat /proc/cpuinfo` した結果は以下になります。

```
$ cat /proc/cpuinfo
proceccor       : 0
model name      : ARM926EJ-S rev 5 (v51)
BogoMIPS        : 119.70
Features        : swp half thumb fastmult edsp java
CPU implementer : 0x41
CPU architecture: 5TEJ
CPU variant     : 0x0
CPU part        : 0x926
CPU revision    : 5

HArdware        : Freescale MXS (Device Tree)
Revison         : 0000
Serial          : 0000000000000000
```

また `/sys/kernel/debug/clk/clk_summary` より、CPU clockは240MHzでした。

## ビルド時間はわかったけど、どのくらいの速度で動くの？
ここまでの内容を [Omotesando.rb #62](https://omotesandorb.connpass.com/event/211572/) で発表したところ、「Ruby自体はどのくらいの性能が出るものなんですか？」という質問がありました。そこで、性能評価をすることにしました。

### どうやってベンチマークを取るか
Ruby自体のbuildのように、一般的なマシンである速度で動くRubyのプログラムが、Brain上だとどのくらいの速度で動くのか？というのを比較できるような指標が欲しいところです。

そこで、「Ruby 3x3」宣言の指標として使われた、Optcarrotを動かしてみることにしました。

Optcarrotは、Ruby core teamのmameさんが開発したNES Emulatorです。動作させたときのfps値を性能の指標として使用することができます。

- [Optcarrot: Ruby で書かれたファミコンエミュレータ - まめめも](https://mametter.hatenablog.com/entry/20160401/p1)
- <https://github.com/mame/optcarrot>

### やってみる
まずは冒頭での記載と同様、GCP e2-medium (vCPU 2, Mem 4GB) 上で実行してみました(同一インスタンス)

```
$ ruby -v -Ilib -r./tools/shim bin/optcarrot --benchmark examples/Lan_Master.nes
ruby 3.0.1p64 (2021-04-05 revision 0fb782ee38) [x86_64-linux]
fps: 28.59686607413079
checksum: 59662

$ ruby -v -Ilib -r./tools/shim bin/optcarrot --benchmark --opt examp
les/Lan_Master.nes
ruby 3.0.1p64 (2021-04-05 revision 0fb782ee38) [x86_64-linux]
fps: 87.00124542792264
checksum: 59662
```

結果、最適化前で28.5fps、最適化後で87.0fpsまで出ています。


これをBrain上で動かしてみた結果がこちらになります。

![Optcarrot 結果](2021/brainux-optcarrot-result.jpeg)

```
$ ruby -v -Ilib -r./tools/shim bin/optcarrot --benchmark examples/Lan_Master.nes
ruby 3.0.1p64 (2021-04-05 revision 0fb782ee38) [armv5tejl-linux-eabi]
fps: 0.11981534177902647
checksum: 59662

$ ruby -v -Ilib -r./tools/shim bin/optcarrot --benchmark --opt examples/Lan_Master.nes
ruby 3.0.1p64 (2021-04-05 revision 0fb782ee38) [armv5tejl-linux-eabi]
fps: 0.5181845210009312
checksum: 59662
```

最適化前で 0.11 fps、 最適化後で 0.51 fpsとなりました。

ということで、**「電子辞書上のRubyでOptcarrotを動かすと出るfpsは最適化後で0.5fps」** です。

## おわりに
こうしてこの世界にまた2つ新たなトリビアが生まれたわけですが、Rubyはaptからインストールできるのに何故わざわざビルドするのでしょうか。

理由として、現在のBrainuxがベースとしているのがDebian busterであり、apt経由でインストールされるRubyは2.5と古いものになっています。

[Debian -- buster の ruby パッケージに関する詳細](https://packages.debian.org/ja/buster/ruby)

Ruby 2.5はもう Ruby core teamのメンテナンス対象から外れたEOLなバージョンということもあり、できるだけ最新のものを使うことが推奨されます。

> このリリースをもって、Ruby 2.5 系列は EOL となります。 即ち、Ruby 2.5.9 が Ruby 2.5 系列の最後のリリースとなります。 これ以降、仮に新たな脆弱性が発見されても、Ruby 2.5.10 などはリリースされません。 ユーザーの皆様におかれましては、速やかに、より新しい 3.0、2.7、2.6 といったバージョンへの移行を推奨します。
> https://www.ruby-lang.org/ja/news/2021/04/05/ruby-2-5-9-released/

となると、自分でビルドするしかないですね！

また、この記事でちょこちょこ言及しているように、Brainux自体にはまだまだ改善の余地が転がっている状態です。Brainは中古で数千円程度で入手できるので、みなさんもBrainuxで遊んでみてはいかがでしょうか。
