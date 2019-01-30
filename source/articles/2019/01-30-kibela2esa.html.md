---
title: '[WIP]kibela2esa をつくりました'
date: 2019-01-30 20:14 JST
tags: 
- ruby
- kibela
- esa
- programming
---

![kibela esa migration params](2019/kibela2esa.jpg)

[HolyGrail/kibela2esa: Kibela 2 esa.io](https://github.com/HolyGrail/kibela2esa)

## りゆう
やっぱりWIPっていいですよね。

## どういうことをしているのか
1. exportされたmarkdownを読みこむ
2. exportされた画像を読みこむ(pathと名前だけ持っておく)
3. 画像をesaにアップロードして、S3のURLを持っておく
4. markdown内の画像URLをesaのS3 URLに置換する
5. frontmatterなどの処理や整形した結果のmarkdownをesaに投稿する

## できること
- 投稿した記事の移行
  - 言わずもがな
  - 投稿者のマイグレートもできます
- 画像の置きかえ
  -  kibelaにアップロードされている画像のURLを、esaにアップロードした画像のURLに置換する

## (まだ)できないこと
- kibelaの記事に書かれたkibela記事への参照をesaに移行した後の記事への参照へと置き換える
  - 2-pass 処理が必要？
    - もしくは依存関係を見るようにする (手間すぎる)

## たいへんだったこと
- kibelaにAPIがない
  - ユーザー一覧だったり、投稿の情報の取得が手間
  - 全部ファイル内容をparseして取得する必要がある
- exportされたファイル形式がしんどい

## まとめ
esaが好きです。

[HolyGrail/kibela2esa: Kibela 2 esa.io](https://github.com/HolyGrail/kibela2esa)
