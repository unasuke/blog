---
title: "Rubyのdistroless imageをmagicpakで構築できるのか？"
date: 2020-04-17 03:14 JST
tags: 
- docker
- ruby
- distroless
---

![](2020/distroless-ruby-magicpak.png)

## distroless-ruby
こんにちは、趣味でこのようなものを作っている者です。

<https://github.com/unasuke/distroless-ruby>

作るだけ作って、実用はしていませんけど。

Distrolessとは何か、ということについては以下の記事をご参照ください。

[distrolessイメージを使って、ランタイムDockerイメージを作ってみる - Qiita](https://qiita.com/some-nyan/items/90b624b0f148231748f0)

さて私がこれまでこのimageをどのように作成していたのかと言いますと、この記事に書いたように人力で依存関係を調べて頑張っていました。
[Rubyが動くdistroless image は作ることができるのか - Qiita](https://qiita.com/yu_suke1994/items/e12bb942a15f770f772c)

Ruby 2.6までは順調だったのですが、2.7ではリンクされるライブラリが増えたのかなんなのか、これまでのように単純なバージョンの変更では上手くいかずに手が止まってしまっていました。

そこに登場したのがこのツール、magicpakです。

- [magicpak: 静的リンクなしで小さなDockerイメージを作る - molecular coordinates](https://coordination.hatenablog.com/entry/2020/04/15/014847)
- [coord-e/magicpak: Build minimal docker images without static linking](https://github.com/coord-e/magicpak)

これを使えば、Rubyが実行するために必要なファイルを列挙でき、distrolessなimageの作成が楽になるのではないかと考え、試してみました。

## magicpak -v $(which ruby)
では早速次のようなDockerfileを作成し、buildの様子を眺めてみます。

```Dockerfile
FROM ruby:2.7.0-buster
ADD https://github.com/coord-e/magicpak/releases/latest/download/magicpak-x86_64-unknown-linux-musl /usr/bin/magicpak
RUN chmod +x /usr/bin/magicpak
RUN /usr/bin/magicpak -v $(which ruby) /bundle
```

docker buildが……

```
Sending build context to Docker daemon   2.09MB
Step 1/4 : FROM ruby:2.7.0-buster as ruby
 ---> ea1d77821a3c
Step 2/4 : ADD https://github.com/coord-e/magicpak/releases/latest/download/magicpak-x86_64-unknown-linux-musl /usr/bin/magicpak
Downloading [==================================================>]  4.222MB/4.222MB
 ---> bd6ae35e14fe
Step 3/4 : RUN chmod +x /usr/bin/magicpak
 ---> Running in e75094fba6fd
Removing intermediate container e75094fba6fd
 ---> 8280a91988f3
Step 4/4 : RUN /usr/bin/magicpak -v $(which ruby) /bundle
 ---> Running in 818a39c7466f
[INFO] exe: loading /usr/local/bin/ruby
[INFO] action: bundle shared object dependencies of /usr/local/bin/ruby
[INFO] exe: loading /usr/local/lib/libruby.so.2.7

################ snip #############################

[INFO] exe: using default interpreter /lib64/ld-linux-x86-64.so.2
[INFO] action: bundle executable /usr/local/bin/ruby as None
[INFO] action: emit /bundle
[INFO] action: emit: creating /bundle as it does not exist
[INFO] emit: link /lib/x86_64-linux-gnu/libpthread-2.28.so => /bundle/lib/x86_64-linux-gnu/libpthread.so.0
[INFO] emit: copy /lib/x86_64-linux-gnu/libpthread-2.28.so => /bundle/lib/x86_64-linux-gnu/libpthread-2.28.so
[INFO] emit: link /usr/local/lib/libruby.so.2.7.0 => /bundle/usr/local/lib/libruby.so.2.7
[INFO] emit: copy /usr/local/lib/libruby.so.2.7.0 => /bundle/usr/local/lib/libruby.so.2.7.0
[INFO] emit: link /lib/x86_64-linux-gnu/libdl-2.28.so => /bundle/lib/x86_64-linux-gnu/libdl.so.2
[INFO] emit: copy /lib/x86_64-linux-gnu/libdl-2.28.so => /bundle/lib/x86_64-linux-gnu/libdl-2.28.so
[INFO] emit: link /lib/x86_64-linux-gnu/libm-2.28.so => /bundle/lib/x86_64-linux-gnu/libm.so.6
[INFO] emit: copy /lib/x86_64-linux-gnu/libm-2.28.so => /bundle/lib/x86_64-linux-gnu/libm-2.28.so
[INFO] emit: link /lib/x86_64-linux-gnu/ld-2.28.so => /bundle/lib64/ld-linux-x86-64.so.2
[INFO] emit: copy /lib/x86_64-linux-gnu/ld-2.28.so => /bundle/lib/x86_64-linux-gnu/ld-2.28.so
[INFO] emit: link /lib/x86_64-linux-gnu/libz.so.1.2.11 => /bundle/lib/x86_64-linux-gnu/libz.so.1
[INFO] emit: copy /lib/x86_64-linux-gnu/libz.so.1.2.11 => /bundle/lib/x86_64-linux-gnu/libz.so.1.2.11
[INFO] emit: link /lib/x86_64-linux-gnu/libcrypt-2.28.so => /bundle/lib/x86_64-linux-gnu/libcrypt.so.1
[INFO] emit: copy /lib/x86_64-linux-gnu/libcrypt-2.28.so => /bundle/lib/x86_64-linux-gnu/libcrypt-2.28.so
[INFO] emit: link /lib/x86_64-linux-gnu/librt-2.28.so => /bundle/lib/x86_64-linux-gnu/librt.so.1
[INFO] emit: copy /lib/x86_64-linux-gnu/librt-2.28.so => /bundle/lib/x86_64-linux-gnu/librt-2.28.so
[INFO] emit: link /usr/lib/x86_64-linux-gnu/libgmp.so.10.3.2 => /bundle/usr/lib/x86_64-linux-gnu/libgmp.so.10
[INFO] emit: copy /usr/lib/x86_64-linux-gnu/libgmp.so.10.3.2 => /bundle/usr/lib/x86_64-linux-gnu/libgmp.so.10.3.2
[INFO] emit: copy /usr/local/bin/ruby => /bundle/usr/local/bin/ruby
[INFO] emit: link /lib/x86_64-linux-gnu/libc-2.28.so => /bundle/lib/x86_64-linux-gnu/libc.so.6
[INFO] emit: copy /lib/x86_64-linux-gnu/libc-2.28.so => /bundle/lib/x86_64-linux-gnu/libc-2.28.so
Removing intermediate container 818a39c7466f
 ---> 077d681487ae
Successfully built 077d681487ae
```

多いですね。これを `/bundle` にまとめて展開すれば動くのでしょうか？次のようなDockerfileを使って試してみましょう。

```Dockerfile
FROM ruby:2.7.0-buster as ruby

ADD https://github.com/coord-e/magicpak/releases/latest/download/magicpak-x86_64-unknown-linux-musl /usr/bin/magicpak
RUN chmod +x /usr/bin/magicpak
RUN /usr/bin/magicpak -v $(which ruby) /bundle

FROM gcr.io/distroless/base-debian10

COPY --from=ruby /bundle /.
RUN ["/usr/local/bin/ruby", "-v"]
RUN ["/usr/local/bin/gem", "install", "sinatra"]
```

buildしてみると……

```
# ...snip...
Step 5/8 : FROM gcr.io/distroless/base-debian10
 ---> 5bb0e81ff6e4
Step 6/8 : COPY --from=ruby /bundle /.
 ---> f2a8875bdfdc
Step 7/8 : RUN ["/usr/local/bin/ruby", "-v"]
 ---> Running in 2cce67b240b1
ruby 2.7.0p0 (2019-12-25 revision 647ee6f091) [x86_64-linux]
Removing intermediate container 2cce67b240b1
 ---> 145cba6957e9
Step 8/8 : RUN ["/usr/local/bin/gem", "install", "sinatra"]
 ---> Running in e445421dbc07
OCI runtime create failed: container_linux.go:349: starting container process caused "exec: \"/usr/local/bin/gem\": stat /usr/local/bin/gem: no such file or directory": unknown
```

`/usr/local/bin/gem` がないようです。確かにmagicpakの対象にしたのはrubyコマンドのみで、gemやbundlerに対しては何もしていません。これらも含めてあげましょう。

```Dockerfile
FROM ruby:2.7.0-buster as ruby

ADD https://github.com/coord-e/magicpak/releases/latest/download/magicpak-x86_64-unknown-linux-musl /usr/bin/magicpak
RUN chmod +x /usr/bin/magicpak
RUN /usr/bin/magicpak -v $(which ruby) /bundle

FROM gcr.io/distroless/base-debian10

COPY --from=ruby /bundle /.
COPY --from=ruby /usr/local/bin/ /usr/local/bin # ここを追加
RUN ["/usr/local/bin/ruby", "-v"]
RUN ["/usr/local/bin/gem", "install", "sinatra"]
```

結果は……

```
Step 9/9 : RUN ["/usr/local/bin/gem", "install", "sinatra"]
 ---> Running in e638dbdb65fd
<internal:gem_prelude>:1:in `require': cannot load such file -- rubygems.rb (LoadError)
        from <internal:gem_prelude>:1:in `<internal:gem_prelude>'
The command '/usr/local/bin/gem install sinatra' returned a non-zero code: 1
```

こんどは `rubygems.rb` がみつかりません。これは `/usr/local/lib/ruby/`以下にあります。これも含めます。

```Dockerfile
FROM ruby:2.7.0-buster as ruby

ADD https://github.com/coord-e/magicpak/releases/latest/download/magicpak-x86_64-unknown-linux-musl /usr/bin/magicpak
RUN chmod +x /usr/bin/magicpak
RUN /usr/bin/magicpak -v $(which ruby) /bundle

FROM gcr.io/distroless/base-debian10

COPY --from=ruby /bundle /.
COPY --from=ruby /usr/local/bin/ /usr/local/bin
COPY --from=ruby /usr/local/lib/ruby/ /usr/local/lib/ruby # ここを追加
RUN ["/usr/local/bin/ruby", "-v"]
RUN ["/usr/local/bin/gem", "install", "sinatra"]
```

さてどうか……

```
Step 10/10 : RUN ["/usr/local/bin/gem", "install", "sinatra"]
 ---> Running in 888f7427612a
/usr/local/lib/ruby/2.7.0/yaml.rb:3: warning: It seems your ruby installation is missing psych (for YAML output).
To eliminate this warning, please install libyaml and reinstall your ruby.
/usr/local/lib/ruby/2.7.0/rubygems/core_ext/kernel_require.rb:92:in `require': libyaml-0.so.2: cannot open shared object file: No such file or directory - /usr/local/lib/ruby/2.7.0/x86_64-linux/psych.so (LoadError)
```

libyamlが見付からないというエラーが出ました。gemコマンドに対してはmagicpakを通してないからでしょうか。ちなみにそれをやってもエラーが出ます。

```
root@4033859f93d6:/# ./magicpak -v /usr/local/bin/gem /bundle
[INFO] exe: loading /usr/local/bin/gem
[ERROR] error: The executable is malformed: unknown magic number: 7795575320214446371
```

とりあえず、libyamlを足してやると……

```Dockerfile
FROM ruby:2.7.0-buster as ruby

ADD https://github.com/coord-e/magicpak/releases/latest/download/magicpak-x86_64-unknown-linux-musl /usr/bin/magicpak
RUN chmod +x /usr/bin/magicpak
RUN /usr/bin/magicpak -v $(which ruby) /bundle

FROM gcr.io/distroless/base-debian10

COPY --from=ruby /bundle /.
COPY --from=ruby /usr/lib/x86_64-linux-gnu/libyaml* /usr/lib/x86_64-linux-gnu/ # ここを追加
COPY --from=ruby /usr/local/bin/ /usr/local/bin
COPY --from=ruby /usr/local/lib/ruby/ /usr/local/lib/ruby
RUN ["/usr/local/bin/ruby", "-v"]
RUN ["/usr/local/bin/gem", "install", "sinatra"]
```

今度は……

```
6 gems installed
Removing intermediate container 1a7823880c0d
 ---> 680de9256898
Successfully built 680de9256898
Successfully tagged unasuke/distroless-ruby:2.7.0-buster
```
sinatraがインストールできました！ここでは省きますが、ちゃんとリクエストも受けつけるようになっています。imageのサイズは次のようになりました。

| image | size |
| --- | --- |
| `ruby:2.7.0-buster` | 842MB |
| `ruby:2.7.0-slim-buster` | 149MB |
| `ruby:2.7.0-alpine` | 51.4MB |
| `rubylang/ruby:2.7.0-bionic` | 359MB |
| `unasuke/distroless-ruby:2.7.0-buster` | **59.4MB** |

alpineには敵わないものの、slim-busterのおよそ半分のサイズになりました。まあ、実用性については疑問点が残りますが。

## まとめ
magickpakを使うことで、比較的楽にdistroless-rubyのDocker imageを作成することができました(それまでのtry-and-errorはこの比ではなかったので……)。distroless自体は、Goなどのシングルバイナリが動けばいいimageを作るときには便利に使えるのではないかと思います。

[GoogleContainerTools/distroless: 🥑 Language focused docker images, minus the operating system.](https://github.com/GoogleContainerTools/distroless)
