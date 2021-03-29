---
title: "distroless imageを実用する"
date: 2021-03-29 00:15 JST
tags: 
- ruby
- python
- docker
- distroless
- bazel
- programming
---

![build pyton dinstroless image](2021/distroless-bazel-run.png)

## distroless image
distrolessは、Googleが提供している、本当に必要な依存のみが含まれているcontainer imageです。そこにはaptはおろかshellも含まれておらず、非常にサイズの小さいimageとなっています。余計なプログラムが含まれていないことは attack surfaceの縮小にも繋がり、コンテナのセキュリティについての事業を展開しているSysdig社が公開しているDockerfileのベストプラクティスとしてもdistroless imageを使うことが推奨されています。

[Dockerfileのベストプラクティス Top 20 | Sysdig](https://sysdig.jp/blog/dockerfile-best-practices/)

[軽量Dockerイメージに安易にAlpineを使うのはやめたほうがいいという話 - inductor's blog](https://blog.inductor.me/entry/alpine-not-recommended)

また先日、inductorさんがこのようなブログ記事を書き話題になりました。この記事からdistroless imageのことを知った方も多いと思います。その中で僕が趣味で作った distroless-ruby を取り上げてくださり、ありがたいことに僕の所有しているものの中で一番Star数が多いrepositoryになりました。

とはいえ申し訳ないことに、僕はRubyなどのスクリプト言語を使用する機会が多く、あまりdistrolessを活用してきませんでした。そこで、Rubyのdistroless imageを作成する過程で得た知見を元に、Pythonなど1バイナリで完結しないプログラムをdistrolessで動かす方法について調べてまとめました。

## distrolessと共有ライブラリ
個人的に、distrolessはGoで書かれたプログラムとはとても相性が良いと考えています[^not-go]。

dostroless imageを使用するとき、例えばGoでバイナリを配置するだけの場合や、Pythonで共有ライブラリを静的にリンクした成果物をコンテナ内に配置できる場合は工夫しなくても build stage と copy stage を組み合せたmulti stage buildで済みます。

しかし、aptによってインストールした共有ライブラリを動的リンクする必要があったり、単純に外部のプログラムが必要な場合は提供されているdistroless imageをそのまま使うことができません。
「できない」と書いたものの、技術的には不可能ではありません。例えば `$ sudo apt install foobar` を実行した結果、追加されたファイルを列挙してdistroless image内に配置すればパッケージを使用することはできます。
でも、例えば 外部ライブラリが必要だとして、追加されるファイルが膨大な数になる場合はどうでしょうか。また。それらは特定のディレクトリにまとまっている訳でもないでしょう。

この記事では例として、[orisano](https://twitter.com/orisano) さん提供の「素のdistroless imageでは動かないPython script」を動かすことを考えてみます。

以下のような `app.py` と `Dockerfile` は、そのままでは動きません。

```py:app.py
import gmpy2
print("gmpy2")
```

```Dockerfile
FROM debian:buster-slim AS build
RUN apt-get update && apt-get install --no-install-suggests --no-install-recommends --yes python3-venv gcc libpython3-dev libmpfr-dev libmpc-dev
RUN python3 -m venv /venv && /venv/bin/pip install --upgrade pip
FROM build AS build-venv
RUN /venv/bin/pip install --disable-pip-version-check gmpy2
FROM gcr.io/distroless/python3-debian10
COPY --from=build-venv /venv /venv
COPY . /app
WORKDIR /app
ENTRYPOINT ["/venv/bin/python3", "app.py"]
```

```
$ docker run --rm distroless-python-test
Traceback (most recent call last):
  File "app.py", line 1, in <module>
    import gmpy2
ImportError: libgmp.so.10: cannot open shared object file: No such file or directory
```

ここで、最低限必要なライブラリを含んだdocker imageを作成するために、distrolessと同様にbazelを使用します。

以下のような `WORKSPACE` 及び `BUILD` を準備します。

```bazel:WORKSAPCE
workspace(name='python-test')
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "rules_pkg",
    remote = "https://github.com/bazelbuild/rules_pkg.git",
    tag = "0.4.0"
)

load("@rules_pkg//pkg:deps.bzl", "rules_pkg_dependencies")
rules_pkg_dependencies()

load("@rules_pkg//deb_packages:deb_packages.bzl", "deb_packages")

http_file(
    name = "buster_archive_key",
    sha256 = "9c854992fc6c423efe8622c3c326a66e73268995ecbe8f685129063206a18043",
    urls = ["https://ftp-master.debian.org/keys/archive-key-10.asc"],
)

deb_packages(
  name = "depends_python_gmpy2_debian_buster",
  arch = "amd64",
  distro = "buster",
  distro_type = "debian",
  mirrors = ["https://ftp.debian.org/debian"],
  packages = {
    "libgmp10": "pool/main/g/gmp/libgmp10_6.1.2+dfsg-4_amd64.deb",
    "libmpc3": "pool/main/m/mpclib3/libmpc3_1.1.0-1_amd64.deb",
    "libmpfr6": "pool/main/m/mpfr4/libmpfr6_4.0.2-1_amd64.deb",
  },
  packages_sha256 = {
    "libgmp10": "d9c9661c7d4d686a82c29d183124adacbefff797f1ef5723d509dbaa2e92a87c",
    "libmpc3": "a73b05c10399636a7c7bff266205de05631dc4af502bfb441cbbc6af0a7deb2a",
    "libmpfr6": "d005438229811b09ea9783491c98b145c9bcf6489284ad7870c19d2d09a8f571",
  },
  pgp_key = "buster_archive_key",
)

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "95d39fd84ff4474babaf190450ee034d958202043e366b9fc38f438c9e6c3334",
    strip_prefix = "rules_docker-0.16.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.16.0/rules_docker-v0.16.0.tar.gz"],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)
container_repositories()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")
container_deps()

load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
)
container_pull(
  name = "python_distroless",
  registry = "gcr.io",
  repository = "distroless/python3-debian10",
  tag = "latest"
)
```

```bazel:BUILD
load("@depends_python_gmpy2_debian_buster//debs:deb_packages.bzl", "depends_python_gmpy2_debian_buster")
load("@io_bazel_rules_docker//container:container.bzl", "container_image")

container_image(
  name ="python_with_gmpy2_depends",
  base="@python_distroless//image",
  debs=[
    depends_python_gmpy2_debian_buster["libgmp10"],
    depends_python_gmpy2_debian_buster["libmpc3"],
    depends_python_gmpy2_debian_buster["libmpfr6"],
  ],
)
```

<https://github.com/unasuke/distroless-with-additional-deps> に同じものを用意しました。

このようなBazelによるbuild ruleを定義し、そのディレクトリで `bazel run //:python_with_gmpy2_depends` を実行すると、 `bazel:python_with_gmpy2_depends` というdocker imgaeが作成されます。これを `FROM` として指定した以下のDockerfileをbuild、runしてみると、gmpy2がちゃんと動くようになっているのが確認できます。

```Dockerfile
FROM debian:buster-slim AS build
RUN apt-get update && apt-get install --no-install-suggests --no-install-recommends --yes python3-venv gcc libpython3-dev libmpfr-dev libmpc-dev
RUN python3 -m venv /venv && /venv/bin/pip install --upgrade pip
FROM build AS build-venv
RUN /venv/bin/pip install --disable-pip-version-check gmpy2
# FROM gcr.io/distroless/python3-debian10
FROM bazel:python_with_gmpy2_depends
COPY --from=build-venv /venv /venv
COPY . /app
WORKDIR /app
ENTRYPOINT ["/venv/bin/python3", "app.py"]
```

このようにして作成したimageは、元々のdistroless imageに加えて1.8MBしかサイズが増えておらず、必要最低限の依存のみを追加することができています。(dlayerで調べてみるとわかります)

## Python及びRubyはdistrolessに向いているのか？
僕が思うに、あまり向いていません。

PythonやRubyのようなscript言語は、実行時に必要となるライブラリ群をまとめて1つないし複数個のバイナリとして固めることができません。がんばれば実行時に必要なファイルを列挙することもできるでしょうが、その作業と実際の配置を行うのは困難です。

そのような労力を惜しまず、上記のようなBazel ruleを記述してdistroless imageを使うのか、それともslim imageでやっていくのかは、distrolessにする作業のコストと、image sizeとattack surfaceを減らすことにより得られるメリットを比較して判断することになると思います。

そして多くの場合において、slim imageを使うことが最適解になるのではないかとも思っています。

……あと、そもそもexperimental扱いですし。

## おわりに
この記事はZennにクロスポストしました。内容について面白かった、参考になったなどのお気持ちを「サポート」として頂けると非常に嬉しいです。

https://zenn.dev/unasuke/articles/5ee6e2067ab1ba>

## おまけ musl libcとglibcの違いって何
軽量なイメージのベースとして使われることも多いAlpine Linuxは、標準CライブラリにGNU C Library(glibc)ではなくmusl libcを採用しています。glibcとmusl libcは完全に同じ動作をするものではなく、現にRubyにおいては以下のような報告があります。

- [Bug #14387: Ruby 2.5 を Alpine Linux で実行すると比較的浅めで SystemStackError 例外になる - Ruby master - Ruby Issue Tracking System](https://bugs.ruby-lang.org/issues/14387)
- [Bug #17189: test_thread.rb in testsuite deadlocks with musl libc 1.2.1 - Ruby master - Ruby Issue Tracking System](https://bugs.ruby-lang.org/issues/17189)

musl公式FAQには以下のような記述があります。

> Is musl compatible with glibc?
> Yes and no. At both the source and binary level, musl aims for a degree of feature-compatibility, but not bug-compatibility, with glibc.

> (抄訳) muslはglibc互換ですか？
> はいであり、いいえでもあります。ソースでもバイナリのレベルでも、muslはglibcと機能面においてある程度の互換性に焦点を当てており、バグの互換性についてはそうではありません。

<https://www.musl-libc.org/faq.html>

具体的な差異については以下のwikiにまとめられています。

<https://wiki.musl-libc.org/functional-differences-from-glibc.html>

見出しを抜き出して列挙すると

- printfの挙動
- EOFの扱い
- readとwriteについて
    - stdioの実装にreadvとwritevを使用している
- シグナルマスクとsetjmp/longjmp
- 正規表現
- exitが複数回呼ばれるときの振る舞い
- Dynamic linkerにおけるlazy bindingの未サポート
- dlclose はmuslでは何もしない
- スレッドセーフなdlerror
    - これはPOSIXを尊重してglibcと異なる挙動になっていたのが、musl 1.1.9からglibcと同じ挙動になったということらしい
- symbolのバーションについての扱い
- Threadのスタックサイズ
- Threadキャンセル時の挙動
- localeの扱い (deault localeなど)
- iconv
    - 古い東アジアのマルチバイトエンコーディングについては出力先として指定することができない
    - ISO-2022-JPへの変換はステートレスとなる
    - 等
- 浮動小数点についてはC99 Annex Fの範囲をサポートする
- 浮動小数点の例外についてアンマスクをサポートしない
- 名前解決
    - glibcは候補を順にみていくがmuslは同時に問合せを行い最初に返ってきた結果を採用する？
    - [glibc, musl libc, go の resolver の違い - Qiita](https://qiita.com/yteraoka/items/e74e8bf24f72f7ed5f15)
- 等

このあたり、用語に詳しくはないので頓珍漢なことを言っているかもしれません。原典にあたることを強く推奨します。

……というようにglibcとmusl libcには挙動の差異が存在します。これについて、musl libcに単純に置き換えてもいいかどうかはしっかり検証を行ったうえで実行する必要があるでしょう。

## 参考URL
- [Googleが開発する最新ビルドツール「Bazel」を使ってみよう | さくらのナレッジ](https://knowledge.sakura.ad.jp/6174/)
- [Bazelの使い方詰め合わせ](https://f110.jp/posts/tips-on-bazel/)

[^not-go]: Javaや.Netについては知識が不足しているためなんとも言えません
