---
title: "Bazelを使ってRubyのdistroless imageを作る"
date: 2021-03-29 00:10 JST
tags: 
- ruby
- docker
- distroless
- bazel
- programming
---

![docker layer of the distroless ruby image](2021/distroless-ruby-layer.png)

## きっかけ
元々、distroless-rubyは手作業で必要なファイルを抜き出して作成したものでした。

- [Rubyが動くdistroless image は作ることができるのか - Qiita](https://qiita.com/yu_suke1994/items/e12bb942a15f770f772c)
- [Rubyのdistroless imageをmagicpakで構築できるのか？](2020/build-distroless-ruby-using-magicpak/)

ただ、この方針ではsinatraなどRuby単体で完結するプログラムは手軽に動かすことはできても、外部に依存するものがあるプログラムを動かすことはできません。具体的な例を挙げるならPostgreSQLをRubyで使用するために必要なpq gemはlibpq-devをapt経由でインストールする必要がありますが、distroless image内にはaptが存在しないのでインストールすることができません。multi stage buildを使用し、aptによって追加されたファイルを持ってくることも出来無くはないですが、依存する共有ライブラリ全てに対してその作業を行うのはいささか手間がかかり過ぎます。

で、あるならば、本家distroless imageと同じくBazelによりdistroless-ruby imageを作るほうが色々と融通が効いて良いというものでしょう。ということで、作ってみます。


<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">nodejsみたくわりとかんたんかと思ったけど、rubyはバイナリが入っているtar.gz提供してないみたいなので、ソースからコンパイルするか、インストーラーを使ってインストールするかになっちょうので、面倒。 <a href="https://t.co/dDIbWY5Oqf">https://t.co/dDIbWY5Oqf</a></p>&mdash; Ian Lewis (@IanMLewis) <a href="https://twitter.com/IanMLewis/status/1368817777193086979?ref_src=twsrc%5Etfw">March 8, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

しかし、Google Cloudの中の方、Ianさんがこのように発言されていることから、一筋縄ではいかなそうであることが予想できますね。「コンテナ内部でRubyをbuildするのの何が面倒なのだ？」と僕も当初は考えましたが、 [Googleが開発する最新ビルドツール「Bazel」を使ってみよう | さくらのナレッジ](https://knowledge.sakura.ad.jp/6174/) において、

> イメージの作成時にコンテナ内で処理を実行することはできない

と記述されています。これが書かれたのは2016年ではあり現在は事情が変わっていることも予想されますが、やはり大変なのではないかという雰囲気を感じます。

## やってみる
とはいえやってみましょう。

以下手順は2021年3月15日付近、環境はUbuntu 20.04 (focal) LTS (WSL2)、distroless本家のHEADが [84e71ef9eda0d](https://github.com/GoogleContainerTools/distroless/commit/84e71ef9eda0dd498687aa306e4a812ac477a8f8) の状態で行っています。

また、僕はdistrolessを趣味でやっており、Bazelについても初心者なので誤っている点があると思います。そのような点がありましたら、僕に連絡するかご自身で訂正する記事を公開してもらえたら嬉しいです。

### Python2を準備する
Bazelとdistrolessのbuildにあたっては `/usr/bin/env python` が2系である必要があるので、手元の環境をそのようにします。新しめのubuntuでは `$ sudo apt install python-is-python2` でそのようになります[^py2]。

### Bazelを準備する
distroless imageの構築にはBazelが必要なので、インストールします。

[Installing Bazel on Ubuntu - Bazel 4.0.0](https://docs.bazel.build/versions/4.0.0/install-ubuntu.html)

上記リンクにてubuntuの場合のインストール方法が記載されています。ただ、distrolessで使用しているBazelのversionは `3.4.1` なので、インストールに必要なコマンドの一連は以下のようになります。

```shell
$ sudo apt install curl gnupg
$ curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor > bazel.gpg
$ sudo mv bazel.gpg /etc/apt/trusted.gpg.d/
$ echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
$ sudo apt update && sudo apt install bazel-3.4.1
$ sudo ln -s /usr/bin/bazel-3.4.1 /usr/bin/bazel
```

### distroless repositoryのclone
<https://github.com/GoogleContainerTools/distroless/> を手元にcloneします。

ここからの手順はcloneしてきたdistroless directory下で実行しています。

### `updateWorkspaceSnapshots.sh` を実行する
おもむろに `$ ./updateWorkspaceSnapshots.sh` します。

というのも、distroless imageのbuildの過程で最新のsecurity patchが適用されたdebian packageを取得するために、 `snapshot.debian.org` に対して `checksums.bzl` 内に記載してあるsnapshot versionを取得しにいくのですが、現在のHEADにおいてサーバーが不安定なのか取得に何度も失敗する状況[^debian-snapshot] [^use-nearest-vm] なので、 `updateWorkspaceSnapshots.sh` を実行して最新のreleaseを取得しにいくように `checksums.bzl` を更新します。(最新の状態に更新してもしばしば失敗するので、そういうものだと思ったほうがいいのかもしれません)

また、これはupstreamにおいては毎月実行されているものなので、いずれ不要になる[^bump-snapshot]でしょう。

### bazel でcontainer imageを作成してみる
では実際にBazelで実行できるtaskを一覧するために、以下のコマンドを実行します。

```shell
$ bazel query ...
//package_manager:util_test
//package_manager:parse_metadata_test
//package_manager:dpkg_parser.par
//package_manager:dpkg_parser
//package_manager:version_utils
//package_manager:util
//package_manager:parse_metadata
//nodejs:nodejs14_debug_arm64_debian10
//nodejs:nodejs12_debug_arm64_debian9
//nodejs:nodejs12_debug_arm64_debian10
//nodejs:nodejs12_arm64_debian9
//nodejs:nodejs12_arm64_debian10
//nodejs:nodejs10_debug_arm64_debian9
............
```

637ものbuild対象がありました。言語とアーキテクチャとroot/nonrootなどの組み合わせがあるので膨大な量になります。

ひとまず、単純と思われるccについて確認してみるため、以下のコマンドを実行します。

```shell
$ bazel run //cc:debug_nonroot_amd64_debian10
INFO: Analyzed target //cc:debug_nonroot_amd64_debian10 (89 packages loaded, 6894 targets configured).
INFO: Found 1 target...
INFO: From ImageLayer base/static_nonroot_amd64_debian10-layer.tar:
Duplicate file in archive: ./etc/os-release, picking first occurrence
Target //cc:debug_nonroot_amd64_debian10 up-to-date:
  bazel-bin/cc/debug_nonroot_amd64_debian10-layer.tar
INFO: Elapsed time: 6.957s, Critical Path: 3.44s
INFO: 31 processes: 31 linux-sandbox.
INFO: Build completed successfully, 61 total actions
INFO: Build completed successfully, 61 total actions
Loaded image ID: sha256:c0003d5371b5168ece90447caee6fee576e3cc9ad89e3773386c5cd4448a60bb
Tagging c0003d5371b5168ece90447caee6fee576e3cc9ad89e3773386c5cd4448a60bb as bazel/cc:debug_nonroot_amd64_debian10
```

これにより、ローカルに `bazel/cc:debug_nonroot_amd64_debian10` という docker imageができています[^created-at]。

```shell
$ docker image ls
REPOSITORY      TAG                                 IMAGE ID       CREATED         SIZE
bazel/cc        debug_nonroot_amd64_debian10        c0003d5371b5   51 years ago    22.2MB
```

このimageの中身をlayer可視化ツールのひとつ、  [orisano/dlayer](https://github.com/orisano/dlayer)  で見てみましょう。

```shell
$ docker save -o cc.tar bazel/cc:debug_nonroot_amd64_debian10
$ dlayer -f cc.tar

====================================================================================================
 1.8 MB          $ bazel build ...
====================================================================================================
 198 kB          etc/ssl/certs/ca-certificates.crt
  62 kB          usr/share/doc/tzdata/changelog.gz
  35 kB          usr/share/common-licenses/GPL-3

......snip (zoneinfoやca-certificates的な)

====================================================================================================
  15 MB          $ bazel build ...
====================================================================================================
 2.7 MB          usr/lib/x86_64-linux-gnu/libcrypto.so.1.1
 1.7 MB          lib/x86_64-linux-gnu/libc-2.24.so
 1.1 MB          lib/x86_64-linux-gnu/libm-2.24.so
 655 kB          usr/bin/openssl
 469 kB          usr/lib/x86_64-linux-gnu/gconv/libCNS.so
 443 kB          usr/lib/x86_64-linux-gnu/libssl.so.1.1
 236 kB          usr/lib/x86_64-linux-gnu/gconv/BIG5HKSCS.so

......snip (openssl的な)

====================================================================================================
 1.1 MB          $ bazel build ...
====================================================================================================
 1.1 MB          busybox/busybox
   0  B          busybox/[
   0  B          busybox/[[
   0  B          busybox/acpid

......snip (busybox的な)

====================================================================================================
 1.9 MB          $ bazel build ...
====================================================================================================
 1.6 MB          usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.22
 184 kB          usr/lib/x86_64-linux-gnu/libgomp.so.1.0.0
  93 kB          lib/x86_64-linux-gnu/libgcc_s.so.1
  56 kB          usr/share/gcc-6/python/libstdcxx/v6/printers.py

......snip (glibc的な)
```

このように、いくつかのlayerに分かれて必要なファイルがガッチャンコされているんだな、ということがわかります。

### buildされるときの処理を追う
さて、container imageのbuildが成功したところで、今buildしたcc imageのbuild ruleを見てみます。

<https://github.com/GoogleContainerTools/distroless/blob/84e71ef9eda0dd498687aa306e4a812ac477a8f8/cc/BUILD>

```bazel
package(default_visibility = ["//visibility:public"])

load("//base:distro.bzl", "DISTRO_PACKAGES", "DISTRO_SUFFIXES")
load("@io_bazel_rules_docker//container:container.bzl", "container_image")
load("//:checksums.bzl", "ARCHITECTURES")

# An image for C/C++ programs
[
    container_image(
        name = ("cc" if (not mode) else mode[1:]) + "_" + user + "_" + arch + distro_suffix,
        architecture = arch,
        base = "//base" + (mode if mode else ":base") + "_" + user + "_" + arch + distro_suffix,
        debs = [
            DISTRO_PACKAGES[arch][distro_suffix]["libgcc1"],
            DISTRO_PACKAGES[arch][distro_suffix]["libgomp1"],
            DISTRO_PACKAGES[arch][distro_suffix]["libstdc++6"],
        ],
    )
    for mode in [
        "",
        ":debug",
    ]
    for arch in ARCHITECTURES
    for user in [
        "root",
        "nonroot",
    ]
    for distro_suffix in DISTRO_SUFFIXES
]
```

これを見ると、modeごとに、architectureごとに、userごとに、distroごとにcontainer imageを作成していそうなことが読みとれます。そのcontainer imageには `libgcc1` と `libgomp1` と `libstdc++6` が含まれていることも予想できます。`DISTRO_PACKAGES` と `DISTRO_SUFFIX` は [base/distro.bzl](https://github.com/GoogleContainerTools/distroless/blob/84e71ef9eda0dd498687aa306e4a812ac477a8f8/base/distro.bzl) から、 `ARCHITECTURES` は [checksums.bzl](https://github.com/GoogleContainerTools/distroless/blob/84e71ef9eda0dd498687aa306e4a812ac477a8f8/checksums.bzl) から来ていることもわかります。

ccについてはそれほど行数もないこともあり、大体の処理を把握できました。それではdistrolessなRubyを作成するにあたり、近いことをしていると予想できるPython3の場合を見てみます。147行と少し長いので、ここぞ！と思われる部分を抜き出します。

<https://github.com/GoogleContainerTools/distroless/blob/84e71ef9eda0dd498687aa306e4a812ac477a8f8/experimental/python3/BUILD#L36-L72>

```bazel
container_image(
    name = ("python3" if (not mode) else mode[1:]) + "_root_" + arch + distro_suffix,
    architecture = arch,
    # Based on //cc so that C extensions work properly.
    base = "//cc" + (mode if mode else ":cc") + "_root_" + arch + distro_suffix,
    debs = [
        DISTRO_PACKAGES[arch][distro_suffix]["dash"],
        DISTRO_PACKAGES[arch][distro_suffix]["libbz2-1.0"],
        DISTRO_PACKAGES[arch][distro_suffix]["libc-bin"],
        DISTRO_PACKAGES[arch][distro_suffix]["libdb5.3"],
        DISTRO_PACKAGES[arch][distro_suffix]["libexpat1"],
        DISTRO_PACKAGES[arch][distro_suffix]["liblzma5"],
        DISTRO_PACKAGES[arch][distro_suffix]["libmpdec2"],
        DISTRO_PACKAGES[arch][distro_suffix]["libreadline7"],
        DISTRO_PACKAGES[arch][distro_suffix]["libsqlite3-0"],
        DISTRO_PACKAGES[arch][distro_suffix]["libssl1.1"],
        DISTRO_PACKAGES[arch][distro_suffix]["zlib1g"],
    ] + [DISTRO_PACKAGES[arch][distro_suffix][deb] for deb in DISTRO_DEBS[distro_suffix]],
    entrypoint = [
        "/usr/bin/python" + DISTRO_VERSION[distro_suffix],
    ],
    # Use UTF-8 encoding for file system: match modern Linux
    env = {"LANG": "C.UTF-8"},
    symlinks = {
        "/usr/bin/python": "/usr/bin/python" + DISTRO_VERSION[distro_suffix],
        "/usr/bin/python3": "/usr/bin/python" + DISTRO_VERSION[distro_suffix],
    },
    tars = [
        "//experimental/python2.7:ld_so_" + arch + "_cache.tar",
    ],
)
for mode in [
    "",
    ":debug",
]
for arch in ARCHITECTURES
for distro_suffix in DISTRO_SUFFIXES
```

base imageを先程見たccとし、debsにPython3が必要するpackageを、かつdistroごとに必要とされているdeb packagesを追加、環境変数の設定、entrypointの設定などを行っています。

ここで指定できるattributeは、以下にまとめられています。

<https://github.com/bazelbuild/rules_docker#container_image-1>

### Rubyの distroless imageをbuildするためのruleを書いてみる
それでは、Python3のbuild ruleを参考にして、Rubyのものを書いてみます。

debian10(buster)とdebian9(stretch)において、Rubyをインストールするための情報は以下に記載されています。

* [Debian -- buster の ruby2.5 パッケージに関する詳細](https://packages.debian.org/buster/ruby2.5)
* [Debian -- stretch の ruby2.3 パッケージに関する詳細](https://packages.debian.org/stretch/ruby2.3)

ここから、`ruby2.5` (debian10の場合) をインストールするために必要な依存パッケージを全て列挙[^apt-rdepends]し、そのうちまだ記載されていないものを `WORKSPACE` の `dpkg_list` に追加し、  `updateWorkspaceSnapshots.sh` を実行して `package_bundle_{architecture}_debian{9,10}.versions` を更新します。おそらくこれで、追加したdeb packageをこのworkspace以下でcontainer imageにインストールすることができるようになります。

<https://github.com/unasuke/distroless/commit/b7a069e3ba4d8a>

```diff:WORKSPACE
diff --git a/WORKSPACE b/WORKSPACE
index 3a16ab7..1e1256f 100644
--- a/WORKSPACE
+++ b/WORKSPACE
@@ -246,6 +261,23 @@ load(
             "python3-distutils",
             "python3.7-minimal",

+            #ruby
+            "libgdbm6",
+            "libgdbm-compat4",
+            "libncurses6",
+            "libruby2.5",
+            "libyaml-0-2",
+            "rake",
+            "ruby",
+            "rubygems-integration",
+            "ruby-did-you-mean",
+            "ruby-minitest",
+            "ruby-net-telnet",
+            "ruby-power-assert",
+            "ruby-test-unit",
+            "ruby-xmlrpc",
+            "ruby2.5",
+
             #dotnet
             "libcurl4",
             "libgssapi-krb5-2",
```

次に、debian9と10で異なるpackageをインストールしたい場合の差異を抜き出してまとめます。

<https://github.com/unasuke/distroless/commit/a0de61991f750cc1a15>

```bazel:experimental/ruby/BUILD
# distribution-specific deb dependencies
DISTRO_DEBS = {
    "_debian9": [
        "libgdbm3",
        "libncurses5",
        "libruby2.3",
        "libssl1.0.2",
        "libtinfo5",
        "ruby2.3",
    ],
    "_debian10": [
        "libgdbm6",
        "libgdbm-compat4",
        "libncurses6",
        "libruby2.5",
        "libssl1.1",
        "libtinfo6",
        "ruby-xmlrpc",
        "ruby2.5",
    ],
}
```

あとは共通して必要なdeb packageを `container_image` の  `debs` に列挙し、その他諸々を整えます。

<https://github.com/unasuke/distroless/commit/a0de61991f750cc1a159>

この時点で `bazel query ...` を実行すると、Rubyに関係するtaskが出現しています。

```shell
% bazel query ... | grep ruby
//experimental/ruby:ruby_nonroot_arm64_debian9
//experimental/ruby:ruby_root_arm64_debian9
//experimental/ruby:ruby_nonroot_arm64_debian10
//experimental/ruby:ruby_root_arm64_debian10
//experimental/ruby:ruby_nonroot_amd64_debian9
//experimental/ruby:ruby_root_amd64_debian9
//experimental/ruby:ruby_nonroot_amd64_debian10
//experimental/ruby:ruby_root_amd64_debian10
//experimental/ruby:debug_nonroot_arm64_debian9
//experimental/ruby:debug_root_arm64_debian9
//experimental/ruby:debug_nonroot_arm64_debian10
//experimental/ruby:debug_root_arm64_debian10
//experimental/ruby:debug_nonroot_amd64_debian9
//experimental/ruby:debug_root_amd64_debian9
//experimental/ruby:debug_nonroot_amd64_debian10
//experimental/ruby:debug_root_amd64_debian10
```

では、 `$ bazel build //experimental/ruby:all` でこれらを全部buildしてみます。

```shell
$ bazel build //experimental/ruby:all
INFO: Build option --host_force_python has changed, discarding analysis cache.
INFO: Analyzed 16 targets (61 packages loaded, 7043 targets configured).
INFO: Found 16 targets...
INFO: From ImageLayer base/static_root_arm64_debian10-layer.tar:
Duplicate file in archive: ./etc/os-release, picking first occurrence
INFO: From ImageLayer base/static_root_arm64_debian9-layer.tar:
Duplicate file in archive: ./etc/os-release, picking first occurrence
INFO: From ImageLayer base/static_root_amd64_debian10-layer.tar:
Duplicate file in archive: ./etc/os-release, picking first occurrence
INFO: From ImageLayer base/static_root_amd64_debian9-layer.tar:
Duplicate file in archive: ./etc/os-release, picking first occurrence
INFO: Elapsed time: 8.261s, Critical Path: 4.47s
INFO: 161 processes: 161 linux-sandbox.
INFO: Build completed successfully, 267 total actions
```

buildに成功しました。動作検証のため、amd64、debug、debian10のimageを作成します。

```shell
$ bazel run //experimental/ruby:debug_nonroot_amd64_debian10
INFO: Analyzed target //experimental/ruby:debug_nonroot_amd64_debian10 (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //experimental/ruby:debug_nonroot_amd64_debian10 up-to-date:
  bazel-bin/experimental/ruby/debug_nonroot_amd64_debian10-layer.tar
INFO: Elapsed time: 0.404s, Critical Path: 0.27s
INFO: 0 processes.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
765a3652e862: Loading layer [==================================================>]  22.73MB/22.73MB
84ff92691f90: Loading layer [==================================================>]  10.24kB/10.24kB
Loaded image ID: sha256:881bad115265f80c3b74ddfc054c05958ad4c8ac0d87d9020fd0a743039a9bd2
Tagging 881bad115265f80c3b74ddfc054c05958ad4c8ac0d87d9020fd0a743039a9bd2 as bazel/experimental/ruby:debug_nonroot_amd64_debian10

$ docker image ls
REPOSITORY                 TAG                              IMAGE ID       CREATED         SIZE
bazel/experimental/ruby    debug_nonroot_amd64_debian10     881bad115265   51 years ago    44MB

$ docker run -it --rm --entrypoint=sh bazel/experimental/ruby:debug_nonroot_amd64_debian10
~ $ which ruby
/usr/bin/ruby
~ $ ls -al /usr/bin/
total 780
drwxr-xr-x    1 root     root          4096 Jan  1  1970 .
drwxr-xr-x    1 root     root          4096 Jan  1  1970 ..
-rwxr-xr-x    1 root     root          6332 Jan  1  1970 c_rehash
lrwxrwxrwx    1 root     root             6 Jan  1  1970 erb -> erb2.5
-rwxr-xr-x    1 root     root          4836 Jan  1  1970 erb2.5
lrwxrwxrwx    1 root     root             6 Jan  1  1970 gem -> gem2.5
-rwxr-xr-x    1 root     root           545 Jan  1  1970 gem2.5
lrwxrwxrwx    1 root     root             6 Jan  1  1970 irb -> irb2.5
-rwxr-xr-x    1 root     root           189 Jan  1  1970 irb2.5
-rwxr-xr-x    1 root     root        736776 Jan  1  1970 openssl
-rwxr-xr-x    1 root     root          1178 Jan  1  1970 rake
lrwxrwxrwx    1 root     root             7 Jan  1  1970 rdoc -> rdoc2.5
-rwxr-xr-x    1 root     root           937 Jan  1  1970 rdoc2.5
lrwxrwxrwx    1 root     root             5 Jan  1  1970 ri -> ri2.5
-rwxr-xr-x    1 root     root           187 Jan  1  1970 ri2.5
lrwxrwxrwx    1 root     root             7 Jan  1  1970 ruby -> ruby2.5
-rwxr-xr-x    1 root     root         14328 Jan  1  1970 ruby2.5
~ $ whoami
nonroot
~ $ ruby -v
ruby 2.5.5p157 (2019-03-15 revision 67260) [x86_64-linux-gnu]

$
```

docker imageも正しく作成されていることがわかります。やりました！成功です！

それでは試しに、このimageを試しに使ってみましょう。以下のようなsinatra applicationを動かしてみます。

```ruby:server.rb
require 'sinatra'

set :bind, '0.0.0.0'

get '/' do
  'Hello World!'
end
```

ひとまず  `bazel run //experimental/ruby:ruby_nonroot_amd64_debian10` でbuildした、nonrootでbusyboxのないimageをつくり、 このようなDockerfileを書いてbuildしてみます。

```Dockerfile
FROM bazel/experimental/ruby:ruby_nonroot_amd64_debian10
WORKDIR /home/nonroot
RUN ["/usr/bin/gem", "install", "--user-install", "--no-document", "sinatra"]
COPY server.rb /home/nonroot/
ENV PORT=4567
CMD ["server.rb"]
```

```shell
$ docker build -t distroless-ruby-sinatra-test .
[+] Building 2.7s (9/9) FINISHED
 => [internal] load build definition from Dockerfile                                             0.0s
 => => transferring dockerfile: 264B                                                             0.0s
 => [internal] load .dockerignore                                                                0.0s
 => => transferring context: 2B                                                                  0.0s
 => [internal] load metadata for docker.io/bazel/experimental/ruby:ruby_nonroot_amd64_debian10   0.0s
 => [1/4] FROM docker.io/bazel/experimental/ruby:ruby_nonroot_amd64_debian10                     0.1s
 => [internal] load build context                                                                0.0s
 => => transferring context: 30B                                                                 0.0s
 => [2/4] WORKDIR /home/nonroot                                                                  0.0s
 => [3/4] RUN ["/usr/bin/gem", "install", "--user-install", "--no-document", "sinatra"]          2.2s
 => [4/4] COPY server.rb /home/nonroot/                                                          0.1s
 => exporting to image                                                                           0.1s
 => => exporting layers                                                                          0.1s
 => => writing image sha256:ef0b971fb3ea98f852a4e560075544e6215440eae2c6a4a75cae1044ae4788fb     0.0s
 => => naming to docker.io/library/distroless-ruby-sinatra-test                                  0.0s

$ docker run -it --rm -p 4567:4567 distroless-ruby-sinatra-test
[2021-03-21 07:57:09] INFO  WEBrick 1.4.2
[2021-03-21 07:57:09] INFO  ruby 2.5.5 (2019-03-15) [x86_64-linux-gnu]
== Sinatra (v2.1.0) has taken the stage on 4567 for development with backup from WEBrick
[2021-03-21 07:57:09] INFO  WEBrick::HTTPServer#start: pid=1 port=4567
172.17.0.1 - - [21/Mar/2021:07:57:25 +0000] "GET / HTTP/1.1" 200 12 0.0018
172.17.0.1 - - [21/Mar/2021:07:57:25 UTC] "GET / HTTP/1.1" 200 12
- -> /
```

```shell
$ curl http://localhost:4567
Hello World!
```

このようにbuildが成功し、リクエストも受け付けるようになりました！

さて、実際の開発においてはbundlerを使用することが一般的だと思うので、このimageにbundlerを追加してみます。

<https://github.com/unasuke/distroless/commit/a0de61991f750cc1a159>

bundlerを追加したimageでは、このようなDockerfileを書くことでsinatraを起動させることができるようになりました。

```Dockerfile
FROM ruby:2.5-buster as build
WORKDIR /app
RUN apt update  && apt install -y imagemagick
COPY Gemfile Gemfile.lock /app/
RUN bundle install --path vendor/bundle

FROM bazel/experimental/ruby:ruby_nonroot_amd64_debian10
WORKDIR /home/nonroot
RUN ["/usr/bin/gem", "install", "--user-install", "--no-document", "sinatra"]
COPY server.rb /home/nonroot/
COPY --from=build /app/vendor /home/nonroot/vendor
COPY --chown=nonroot:nonroot Gemfile Gemfile.lock .
ENV PORT=4567
ENTRYPOINT ["/usr/bin/bundle"]
RUN ["/usr/bin/bundle", "config", "set", "path", "vendor/bundle"]
CMD ["exec", "ruby", "server.rb"]
```

### ~~2.3と2.5じゃない、2.7や3.0のRubyを使いたいんだけど。~~

2.5以降のRubyを含むimageを作成することについても作業を進めていたのですがなかなか上手くいかず、成功を待っていると記事の公開がずるずると遅れてしまうので、成功し次第別で記事を公開します。

## まとめ
やってみることによって、できました。

成果については `unasuke/distroless` の ruby branchにpushしてあります。

<https://github.com/unasuke/distroless/tree/ruby>

また、この記事はZennにクロスポストしました。内容について面白かった、参考になったなどのお気持ちを「サポート」として頂けると非常に嬉しいです。非常に労力がかかっているので……

<https://zenn.dev/articles/f51fa23483bec6>

[^py2]: [2020年2月21日号　focalの開発: PHP 7.4への切り替えとPython 2の去就：Ubuntu Weekly Topics｜gihyo.jp … 技術評論社](https://gihyo.jp/admin/clip/01/ubuntu-topics/202002/21)
[^debian-snapshot]: `snapshot.debian.org` に国内mirrorがあれば切り替えて試したかったのですが、2019年時点で90TBものストレージを必要とするらしく、なかなかmirrorも用意できないですよね
[^bump-snapshot]: <https://github.com/GoogleContainerTools/distroless/pulls?q=is%3Aclosed+author%3Aapp%2Fgithub-actions>
[^apt-rdepends]: 依存関係は `apt-rdepends` をインストールして `$ apt-rdepends ruby2.5` などでも調べることができます。 <https://packages.debian.org/ja/buster/apt-rdepends>
[^created-at]: CREATEDが `51 years ago` になっています。docker inspectで情報を見ると、 `"1970-01-01T00:00:00Z"` とepoch timeになっているので、zero fillされているものと予想できます。Jibを使って作成したdocker imageもこうなるようですね。
[^use-nearest-vm]: `snapshot.debian.org` に地理的に近いサーバーで作業をすることをおすすめします。自分が試したときはオランダにサーバーを用意してビルドを実行しました。日本からだと、このスクリプトの実行に40分前後かかるところがオランダのサーバーだと17分程度で終わりました。
