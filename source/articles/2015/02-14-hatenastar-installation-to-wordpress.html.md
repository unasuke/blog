---
title: WordPressにはてなスターを設置した
date: '2015-02-14'
tags:
- howto
- javascript
- php
- programming
---

## 経緯


認証欲求が強いのではてなスターを設置することにした。


## 方法

__※これはこのブログのテーマ(Twenty Twelve)での方法であり、他テーマにおいても同一の方法が適用できることを保証しない。__


### トークンの取得

まず[はてなスターのページ](http://s.hatena.ne.jp/)にログインし、ユーザー名クリックによるブログ一覧のページ下部の、「外部のブログサイトを登録する」にブログのURLを記入し、追加を押す。すると、次のようなJavaScriptが表示される。
![はてなスタートークン](2015/hatenastar-setup.png)

### header.phpの編集


wordpressダッシュボードの外観→テーマの編集から、header.phpを編集する。先ほど取得したJavaScriptを少し編集し、以下のようなJavaScriptをheader.phpの`<head></head>`内に挿入する。
```javascript
<script type="text/javascript" src="http://s.hatena.ne.jp/js/HatenaStar.js"></script>
<script type="text/javascript">
Hatena.Star.Token = 'bb7523a4f3e36d04fb1c050c6403a18d6acf6b60';
Hatena.Star.EntryLoader.headerTagAndClassName = ['h1','entry-title'];
</script>
```
これで、トップページに表示される記事タイトル横にはてなスターのボタンが表示される。


### 個別記事ページへのはてなスター設置(content.php)


先ほどの変更では個別記事ページにはてなスターのボタンが表示されない。そこで、同じくテーマの編集から、content.phpを編集する。今の段階では以下のようになっている部分を編集する。
 
```php
<!-- 初期状態 -->
<?php if ( is_single() ) : ?>
<h1 class="entry-title"><?php the_title(); ?></h1>
<?php else : ?>
<h1 class="entry-title">
    <a href="<?php the_permalink(); ?>" rel="bookmark"><?php the_title(); ?></a>
</h1>
<?php endif; // is_single() ?>
</pre>
この部分を、以下のように編集する。 
<pre class="lang:php decode:true " >
<!-- 変更後 -->
<?php if ( is_single() ) : ?>
<h1 class="entry-title"><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h1>
<?php else : ?>
<h1 class="entry-title">
    <a href="<?php the_permalink(); ?>" rel="bookmark"><?php the_title(); ?></a>
</h1>
<?php endif; // is_single() ?>
```


どのような変更を行ったかというと、個別記事ページでは記事タイトルがただの文字列だったものを、その記事へのリンクとなるようにした。これにより、個別記事ページのタイトルがその記事へのリンクとなり、はてなスターボタンが表示される。


## まとめ


crayonのハイライトなんかおかしくない？？？？ というわけではてなスター設置したのでじゃぶじゃぶ押して下さい。


## 参考ページ

[はてなスターをブログに設置するには - はてなスター日記](http://d.hatena.ne.jp/hatenastar/20070707)
[WordPressに【はてなスター】を設置してみる | ninnin.in -ニンニンイン-](http://ninnin.in/web/wordpress-hatena-ster-setting/)
[WordPressにはてなスターを設置するときに詰まるところ | .COM-POUND](http://www.yasutomo57jp.com/2010/08/31/wordpress%E3%81%AB%E3%81%AF%E3%81%A6%E3%81%AA%E3%82%B9%E3%82%BF%E3%83%BC%E3%82%92%E8%A8%AD%E7%BD%AE%E3%81%99%E3%82%8B%E3%81%A8%E3%81%8D%E3%81%AB%E8%A9%B0%E3%81%BE%E3%82%8B%E3%81%A8%E3%81%93%E3%82%8D/)
[WordPress にはてなスターを設置](http://futuremix.org/2007/11/wordpress-hatena-star)
[WordPressにはてなスターを設置 | 雪よりも白く 緋よりも赤く](http://mirahouse.jp/murmur/?p=211)
[日常＠水月 Blogger版: Bloggerで「はてなスター」を表示するときのテンプレート修正](http://watermoon-blog.blogspot.jp/2012/03/blogger_30.html)
