---
title: "HTTP/3が喋れるcurlを定期的にbuildする"
date: 2021-05-17 01:24 JST
tags: 
- programming
- Docker
- curl
- HTTP/3
- github
---


## TL;DR

- [curlのHTTP/3通信をDocker上で使ってみる - Qiita](https://qiita.com/inductor/items/8d1bc0e95b71e814dbcf)
- [nghttp3を使ってcurlでHTTP/3通信する - Qiita](https://qiita.com/inductor/items/8f2212e6f0793bec3cbf)

inductorさんが上のような記事を公開されています。ここで公開されているDockerfileによってbuildされたimageがあると嬉しいので、GitHub Actionsで定期的にbuildしたものをGitHub Container Registry上にホストすることにしました。

<https://github.com/users/unasuke/packages/container/package/curl-http3>

結論としてはこれだけなのですが、docker imageのtagについてちょっと手間取ったのでそれについて書こうと思います。

## Docker imageのtagをある程度自由に書きたい

このimageをbuidするにあたり、 `curl-http3` というimageに対して以下のtagを付けたいと思っていました。

- `quiche-latest`
    - QUICの実装として [quiche](https://github.com/cloudflare/quiche) を使用したもの
- `quiche-2021-05-01`
    - quiche版のdaily buildとして日付をtagに含めたもの
- `ngtcp2-latest`
    -  QUICの実装として [ngtcp2](https://github.com/ngtcp2/ngtcp2) を使用したもの
- `ngtcp2-2021-05-01`
    - ngtcp2版のdaily buildとして日付をtagに含めたもの

GitHub ActionsでDocker buildを行いたいとなった場合には、以下のDocker公式が提供しているactionを使用するのが定石でしょう。

<https://github.com/marketplace/actions/build-and-push-docker-images>

そして、 `docker/build-push-action@v2` を利用して動的なtagを付けようと、このようなYAMLを書きました。

```yml
- run: date +%Y-%m-%d
  id: date # 結果を参照できるようにidをつけておく
- run: foobar
- name: Build and push
  uses: docker/build-push-action@v2
  with:
    context: quiche
    push: true
    tags:
      - ghcr.io/unasuke/curl-http3:quiche-${{ steps.date.outputs.result }} # ここで dateの結果を利用したい
      - ghcr.io/unasuke/curl-http3:quiche-latest
    cache-from: type=local,src=/tmp/.buildx-cache
    cache-to: type=local,dest=/tmp/.buildx-cache-new
```

`${{ steps.date.outputs }}` というのは、 idがdateとなっているstepの出力を展開させるための記法です。

<https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idoutputs>

しかしここで文字列展開はできないらしく、以下のエラーによってActionを実行することができませんでした。
> The workflow is not valid. .github/workflows/build.yml (Line: 32, Col: 13): A sequence was not expected .github/workflows/build.yml (Line: 70, Col: 13): A sequence was not expected

(どちらにせよ、上に書いたようなYAMLの内容では dateコマンドの結果を再利用することはできません、 `::set-output` などの記法を適切に使用する必要があります)

どうすればいいでしょうか？

## docker/metadata-action を使う
`docker/metadata-action` を使うと、ここで行いたいことができるようになります[^crazy-max]。

<https://github.com/marketplace/actions/docker-metadata-action>

もう一度、どのようなタグをつけたいかをおさらいします。

- `quiche-latest`
- `quiche-2021-05-01`
- `ngtcp2-latest`
- `ngtcp2-2021-05-01`

ここで、quiche版のみに注目して考えてみます。まず、`quiche-latest` については固定値なので `docker/build-push-action@v2` だけでも実現できますが、今問題になっているのは、上でも述べたように `quiche-2021-05-01` などのビルドした時点での日付が入っているものです。

これは、`docker/metadata-action` では `type-schedule` を指定することで実現できます。

<https://github.com/marketplace/actions/docker-metadata-action#typeschedule>

```yaml
- uses: docker/metadata-action@v3
  id: meta
  with:
    images: ghcr.io/unasuke/curl-http3
    tags: |
      type=schedule,pattern={{date 'YYYY-MM-DD'}},prefix=quiche-
      type=raw,value=quiche-latest

- name: Build and push
  uses: docker/build-push-action@v2
  with:
    context: .
    push: true
    tags: ${{ steps.meta.outputs.tags }}
```

具体的には、上のような指定を書くことで `quiche-2021-05-01` のようなtagを付けたimageをbuildすることができます。注意すべきは、この `type=schedule` で指定したtagが付与されるのはScheduled eventsの場合だけなので、pushしたタイミングで実行されるactionではtagが付きません。

他にもcommit hashを指定することもできます。

最終的に、 `quiche-latest` 、 `quiche-<YYYY-MM-DD>`、 `quiche-<commithash>` の3種類のtagを付けるために、以下のようなYAMLを記述しました。

```yaml
- uses: docker/metadata-action@v3
  id: meta
  with:
    images: ghcr.io/unasuke/curl-http3
    tags: |
      type=schedule,pattern={{date 'YYYY-MM-DD'}},prefix=quiche-
      type=raw,value=quiche-latest
      type=sha,prefix=quiche-

- name: Build and push
  uses: docker/build-push-action@v2
  with:
    context: quiche
    push: true
    tags: ${{ steps.meta.outputs.tags }}
```

実際に動いているWorkflowの定義は <https://github.com/unasuke/curl-http3/blob/master/.github/workflows/build.yml> にあります。

## まとめ
HTTP/3が喋れるcurlを定期的にbuildして [unasuke/curl-http3](https://github.com/unasuke/curl-http3) に置いてあります。

また、GitHub Actionsにおいてdocker imageのtagをある程度柔軟に指定したい場合、 `docker/metadata-action` が解決策になるかもしれません。

[^crazy-max]: もともとは `crazy-max/ghaction-docker-meta@v2` でしたが、この記事を書いている間にdocker org公式でメンテナンスされるようになっていました。すごい！ <https://github.com/docker/metadata-action/pull/78>
