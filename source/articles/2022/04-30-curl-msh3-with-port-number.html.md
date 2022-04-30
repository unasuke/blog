---
title: "msh3(MsQuic)版のcurlに任意のポート番号を渡せるようにした話"
date: 2022-04-30 19:00 JST
tags: 
  - curl
  - msquic
  - msh3
  - c
  - quic
  - programming
  - internet
---

![msh3によるcurlでのnghttp2.org:4433へのリクエストが成功する様子](2022/curl-msh3-quic-logo.png)

## msh3 as the third h3 backend……って何？
プログラマーの皆さんなら一度は使ったことのあるであろうcurlは、HTTP/3でリクエストを送ることができます。しかし、一般的に手に入るcurl、いわゆるOSのパッケージマネージャーから入手できるものでは不可能で、独自にビルドする必要があります。

(もし必要であれば、ここからHTTP/3が使えるcurl入りのdocker imageを入手できます <https://github.com/unasuke/curl-http3> )

そのとき、外部のライブラリを組み込む必要があるのですが、これまでは[cloudflare/quiche](https://github.com/cloudflare/quiche)か、[nghttp3](https://github.com/ngtcp2/nghttp3)のどちらかを選ぶことができました。

2022年4月11日、その選択肢にMicrosoftの開発しているQUICプロトコル実装である[MsQuic](https://github.com/microsoft/msquic)が加わりました。

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">I had a great time working with Daniel and the rest of the curl community to add msh3 support! I&#39;ll be happy to continue doing so! <a href="https://t.co/p9Dz4kGuGL">https://t.co/p9Dz4kGuGL</a></p>&mdash; Nick Banks (@gamernb) <a href="https://twitter.com/gamernb/status/1513201682892611589?ref_src=twsrc%5Etfw">April 10, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

このツイートをしたNickさんはMsQuicの主要コントリビューターで、それを使いやすくするための薄いラッパーライブラリである[msh3](https://github.com/nibanks/msh3)の作者であり、引用されているDanielさんはcurlの作者です。

## じゃあビルドしてみよう
発表されたタイミングで、公式サイトのHTTP/3対応版のビルド方法についての記載が更新され、"msh3 (msquic) version" が追加されていました。

<https://curl.se/docs/http3.html#msh3-msquic-version>

それに従い、このようなDockerfileでビルドに成功しました。

```Dockerfile
FROM ubuntu:22.04 as base-fetch
RUN apt-get update && apt-get install -y git

FROM ubuntu:22.04 as base-build
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y build-essential pkg-config tzdata cmake

FROM base-fetch as fetch-msh3
WORKDIR /root
RUN git clone --recursive --depth 1 https://github.com/nibanks/msh3

FROM base-build as build-msh3
WORKDIR /root
COPY --from=fetch-msh3 /root/msh3 /root/msh3
WORKDIR /root/msh3/build
RUN cmake -G 'Unix Makefiles' -DCMAKE_BUILD_TYPE=RelWithDebInfo .. \
  && cmake --build . \
  && cmake --install .

FROM base-fetch as fetch-curl
WORKDIR /root
RUN git clone --depth 1 https://github.com/curl/curl

FROM base-build as build-curl
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y autoconf libtool libssl-dev
COPY --from=build-msh3 /usr/local /usr/local
COPY --from=fetch-curl /root/curl /root/curl
WORKDIR /root/curl
RUN autoreconf -fi
RUN ./configure LDFLAGS="-Wl,-rpath,/usr/local/lib" --with-msh3=/usr/local --with-openssl
RUN make -j`nproc`
RUN make install

FROM ubuntu:22.04 as executor
RUN apt update && apt install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=build-curl /etc/ld.so.conf.d/libc.conf /etc/ld.so.conf.d/libcurl.conf
COPY --from=build-curl /usr/local/lib/libcurl.so.4 /usr/local/lib/libcurl.so.4
COPY --from=build-curl /usr/local/lib/libmsh3.so /usr/local/lib/libmsh3.so
COPY --from=build-curl /usr/local/lib/libmsquic.so /usr/local/lib/libmsquic.so
COPY --from=build-curl /usr/local/bin/curl /usr/local/bin/curl
RUN ldconfig
CMD ["bash"]
```

<https://github.com/unasuke/curl-http3/blob/53287f3b1f08b41b11067a27d787272ce566c2a7/msh3/Dockerfile>

さて、出来上がったcurlでHTTP/3なサーバーに対してリクエストをしてみると、なんだかうまくいきません。具体的には、`www.google.com` にはHTTP/3でアクセスできるのですが、`nghttp2.org:4433` にはアクセスできません。他にも、msh3のREADMEに記載のある `outlook.office.com` や `www.cloudflare.com` にはアクセスできるものの、`quic.tech:8443` や `quic.rocks:4433`にはアクセスできません。

![curlでwww.google.comへのリクエストが成功する様子](2022/curl-msh3-v1-google-success.png)

![curlでnghttp2.org:4433へのリクエストが失敗する様子](2022/curl-msh3-v1-nghttp2-failed.png)

## きいてみよう
よくわからなかったので、msh3の作者であるNickさんに聞いてみました(というか、Nickさんが僕のツイートに反応してくれました。大感謝です)

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">I think it might not support h3 on that port.</p>&mdash; Nick Banks (@gamernb) <a href="https://twitter.com/gamernb/status/1518559624458379264?ref_src=twsrc%5Etfw">April 25, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

うーん、`nghttp2.org:4433`がHTTP/3をサポートしていないなんてことがあるのでしょうか？quiche版やnghttp3版ではリクエストができるので、調べてみることにしました。

## 切り分けてみよう
問題がどこにあるのか切り分けることにします。READMEによると、msh3には `msh3app` という試しにリクエストを送るためのプログラムがあります。これで `nghttp2.org:4433`へのリクエストができれば、僕がcurlを正しくビルドできていないことになります。

msh3appをビルドするには、以下のようなコマンドを実行します。

```shell
$ # msh3/build 以下で実行
$ cmake -G 'Unix Makefiles' -DMSH3_TOOL=on ..
$ cmake --build .
```

これで `build/tool/msh3app`が生成されます。試しに`www.google.com`と `nghttp2.org:4433`にリクエストを送ってみると、やはり`nghttp2.org:4433`へのリクエストは失敗しました。

![msh3appでwww.google.comへのリクエストが成功する様子](2022/curl-msh3-msh3app-google-success.png)

![msh3appでnghttp2.org:4433へのリクエストが失敗する様子](2022/curl-msh3-msh3app-nghttp2-failed.png)


では次に、MsQuicではどうでしょうか？MsQuicは、APIを使ったサンプルを用意してくれています。

<https://github.com/microsoft/msquic/blob/main/src/tools/sample/sample.c>

これをビルドする方法ですが、公式ドキュメントとしてビルドガイドがありました。

<https://github.com/microsoft/msquic/blob/main/docs/BUILD.md>

ここで、"Building with CMake" にあるような `camke --build .` ではこのサンプルコードはビルドされませんでした。恐らくCMakeの設定をいじらなければならないようですが、僕にはできそうにありません。なので、ビルドに使っていたUbuntu上にPowerShellをインストールし、 `./scripts/build.ps1` を実行することでビルドすることにしました。

さて、結果ですが、`www.google.com`と `nghttp2.org:4433` のどちらもHTTP/3でのリクエストは成功しました！ということは、msh3のどこかに何かの問題がありそうです。

![msquicのサンプルコードでwww.google.comへのリクエストが成功し、nghttp2.org:4433へのリクエストが失敗する様子](2022/curl-msh3-msquic-quicsample.png)


## msh3を探索してみよう
全部で87行と小さいので、msh3appの元となる `tool/msh3_app.cpp` の処理を追いかけてみることにします。

<https://github.com/nibanks/msh3/blob/v0.2.0/tool/msh3_app.cpp>

コマンドラインから受け取ったHostを使用してConnectionを作成している、という処理をしていそうな72行目、 `MsH3ConnectionOpen` の実装はどうなっているでしょうか。

```cpp
auto Connection = MsH3ConnectionOpen(Api, Host, Unsecure);
```

`MsH3ConnectionOpen` の定義は `lib/msh3.cpp` の65行目からです。

<https://github.com/nibanks/msh3/blob/v0.2.0/lib/msh3.cpp#L65-L81>

```cpp
extern "C"
MSH3_CONNECTION*
MSH3_CALL
MsH3ConnectionOpen(
    MSH3_API* Handle,
    const char* ServerName,
    bool Unsecure
    )
{
    auto Reg = (MsQuicRegistration*)Handle;
    auto H3 = new(std::nothrow) MsH3Connection(*Reg, ServerName, 443, Unsecure);
    if (!H3 || QUIC_FAILED(H3->GetInitStatus())) {
        delete H3;
        return nullptr;
    }
    return (MSH3_CONNECTION*)H3;
}
```

ここで、 MsH3Connectionの引数として443を渡しています。ここが怪しいです。

さらに追いかけていくと、MsH3Connection は uint16_t でPortを受け取り、それを174行目で`Start`に渡しています。このStartの実体はわかりませんが、ともかくPortとして443を決め打ちで渡しているために、443番ポート以外でHTTP/3をホストしているアドレスにはリクエストできなかったのでしょう。

## msh3を直してみよう
では、直してみることにします。

`lib/msh3.cpp`のほうは簡単で、`MsH3ConnectionOpen`がPortを引数として受け取れるようにし、それを`MsH3Connection`に渡すだけです。

問題は`/tool/msh3_app.cpp` のほうで、コマンドライン引数として受け取ったアドレスからhostとportを分離、portがなければ443として扱う、という処理を行う必要があります。Rubyであれば String#splitやString#rpartitionで簡単にできるのですが、C言語となるとそうはいきません。

まず、以下のように `sscanf` を用いて分割しようとしましたが、ホストとポートの区切りである `:` が  `%s`の対象になってしまいうまく分割できません。

<https://wandbox.org/permlink/2PC5Qqsesd6avigW>

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
    char *str = "nghttp2.org:4433";
    char *givenHost = NULL;
    int Port = 443;

    int len = strlen(str);
    givenHost = (char *)calloc(len + sizeof(char), sizeof(char));
    if (givenHost == NULL) {
        printf("failed to allocate memory!\n");
        return -1;
    }
    int count = sscanf(str, "%s:%d", givenHost, &Port);
    printf("givenHost :%s, port: %d, count: %d\n", givenHost, Port, count);
    return 0;
}
```

悩んでいたところ、[@castanea](https://twitter.com/castanea)さんに以下のStack Overflowを教えていただき、 `%[^:]` を使うことでhostとportを分割することができました。

[scanf - C - sscanf not working - Stack Overflow https://stackoverflow.com/questions/7887003](https://stackoverflow.com/questions/7887003/c-sscanf-not-working/7887069#7887069)

<https://wandbox.org/permlink/q16ugMxasUhgzdWJ>

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
    char *str = "nghttp2.org:4433";
    char *givenHost = NULL;
    int Port = 443;

    int len = strlen(str);
    givenHost = (char *)calloc(len + sizeof(char), sizeof(char));
    if (givenHost == NULL) {
        printf("failed to allocate memory!\n");
        return -1;
    }
    int count = sscanf(str, "%[^:]:%d", givenHost, &Port);
    printf("givenHost :%s, port: %d, count: %d\n", givenHost, Port, count);
    return 0;
}
```

しかし、これでは不十分でした。というのも、MSVCでは安全性の観点からsscanfの使用は推奨されておらず、`sscanf_s` を使用しないと警告でWindows環境向けのコンパイルが失敗してしまいます。

* [CRT のセキュリティ機能 | Microsoft Docs](https://docs.microsoft.com/ja-jp/cpp/c-runtime-library/security-features-in-the-crt?view=msvc-170)
* [sscanf_s、_sscanf_s_l、swscanf_s、_swscanf_s_l | Microsoft Docs](https://docs.microsoft.com/ja-jp/cpp/c-runtime-library/reference/sscanf-s-sscanf-s-l-swscanf-s-swscanf-s-l?view=msvc-170)

よって、さらに `#ifdef _WIN32` などしてWindows上とそれ以外の環境で`sscanf_s`か`sscanf`かを使い分けるようにしないといけません。

上記の過程を経て、msh3に対して作成したpull requestがこちらです。

[Enable to connect to the host that hosting on non 443 port by unasuke · Pull Request #37 · nibanks/msh3](https://github.com/nibanks/msh3/pull/37)

## curl側を直してみよう
先ほどmsh3のAPIを変更したので、curl側にも修正が必要になります。

(実際には上で行ったmsh3への変更と同時並行で進めていました)

curl側でmsh3のAPIを使用しているのは`lib/vquic/msh3.c`になります。

<https://github.com/curl/curl/blob/curl-7_83_0/lib/vquic/msh3.c>

ここで、APIに変更を加えた `MsH3ConnectionOpen` を呼び出しているのは124行目です。

```c
qs->conn = MsH3ConnectionOpen(qs->api, conn->host.name, unsecure);
```

なので、ここでport番号を渡してやればいいのですが……どこにリクエスト先のport番号があるのでしょうか？
これは `#define DEBUG_HTTP3 1` などで色々な値を試し、`conn->remote_port` がそれだということがわかりました。なので、それを渡すだけでよさそうです！

```diff
- qs->conn = MsH3ConnectionOpen(qs->api, conn->host.name, unsecure);
+ qs->conn = MsH3ConnectionOpen(qs->api, conn->host.name, (uint16_t)conn->remote_port, unsecure);
```

[Pass remote_port to MsH3ConnectionOpen by unasuke · Pull Request #8762 · curl/curl](https://github.com/curl/curl/pull/8762)

という訳で、これもmergeされたことにより、msh3(MsQuic)版のcurlに任意のポート番号を渡してHTTP/3による通信ができるようになりました。

## おわりに

C言語って難しいですね……
