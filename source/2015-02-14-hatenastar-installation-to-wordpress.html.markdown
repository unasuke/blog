---
title: WordPressにはてなスターを設置した
date: '2015-02-14'
tags:
- howto
- javascript
- php
- programming
---

<h2>経緯</h2>


認証欲求が強いのではてなスターを設置することにした。


<h2>方法</h2>

<strong>※これはこのブログのテーマ(Twenty Twelve)での方法であり、他テーマにおいても同一の方法が適用できることを保証しない。</strong>

<h3>トークンの取得</h3>

まず<a href="http://s.hatena.ne.jp/" target="_blank">はてなスターのページ</a>にログインし、ユーザー名クリックによるブログ一覧のページ下部の、「外部のブログサイトを登録する」にブログのURLを記入し、追加を押す。すると、次のようなJavaScriptが表示される。
<a href="http://unasuke.com/wp/wp-content/uploads/2015/02/Screen-Shot-2015-02-14-at-9.39.08.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/02/Screen-Shot-2015-02-14-at-9.39.08.png" alt="はてなスタートークン" width="690" height="216" class="alignnone size-full wp-image-997" /></a>

<h3>header.phpの編集</h3>


wordpressダッシュボードの外観→テーマの編集から、header.phpを編集する。先ほど取得したJavaScriptを少し編集し、以下のようなJavaScriptをheader.phpの&lt;head&gt;&lt;/head&gt;内に挿入する。
<pre class="lang:js decode:true " >
&lt;script type="text/javascript" src="http://s.hatena.ne.jp/js/HatenaStar.js"&gt;&lt;/script&gt;
&lt;script type="text/javascript"&gt;
Hatena.Star.Token = 'bb7523a4f3e36d04fb1c050c6403a18d6acf6b60';
Hatena.Star.EntryLoader.headerTagAndClassName = ['h1','entry-title'];
&lt;/script&gt;
</pre>
これで、トップページに表示される記事タイトル横にはてなスターのボタンが表示される。


<h3>個別記事ページへのはてなスター設置(content.php)</h3>


先ほどの変更では個別記事ページにはてなスターのボタンが表示されない。そこで、同じくテーマの編集から、content.phpを編集する。今の段階では以下のようになっている部分を編集する。
 
<pre class="lang:php decode:true " >
&lt;!-- 初期状態 --&gt;
&lt;?php if ( is_single() ) : ?&gt;
&lt;h1 class="entry-title"&gt;&lt;?php the_title(); ?&gt;&lt;/h1&gt;
&lt;?php else : ?&gt;
&lt;h1 class="entry-title"&gt;
    &lt;a href="&lt;?php the_permalink(); ?&gt;" rel="bookmark"&gt;&lt;?php the_title(); ?&gt;&lt;/a&gt;
&lt;/h1&gt;
&lt;?php endif; // is_single() ?&gt;
</pre>
この部分を、以下のように編集する。 
<pre class="lang:php decode:true " >
&lt;!-- 変更後 --&gt;
&lt;?php if ( is_single() ) : ?&gt;
&lt;h1 class="entry-title"&gt;&lt;a href="&lt;?php the_permalink(); ?&gt;"&gt;&lt;?php the_title(); ?&gt;&lt;/a&gt;&lt;/h1&gt;
&lt;?php else : ?&gt;
&lt;h1 class="entry-title"&gt;
    &lt;a href="&lt;?php the_permalink(); ?&gt;" rel="bookmark"&gt;&lt;?php the_title(); ?&gt;&lt;/a&gt;
&lt;/h1&gt;
&lt;?php endif; // is_single() ?&gt;
</pre>



どのような変更を行ったかというと、個別記事ページでは記事タイトルがただの文字列だったものを、その記事へのリンクとなるようにした。これにより、個別記事ページのタイトルがその記事へのリンクとなり、はてなスターボタンが表示される。


<h2>まとめ</h2>


crayonのハイライトなんかおかしくない？？？？ というわけではてなスター設置したのでじゃぶじゃぶ押して下さい。


<h2>参考ページ</h2>

<a href="http://d.hatena.ne.jp/hatenastar/20070707" target="_blank">はてなスターをブログに設置するには - はてなスター日記</a>
<a href="http://ninnin.in/web/wordpress-hatena-ster-setting/" target="_blank">WordPressに【はてなスター】を設置してみる | ninnin.in -ニンニンイン-</a>
<a href="http://www.yasutomo57jp.com/2010/08/31/wordpress%E3%81%AB%E3%81%AF%E3%81%A6%E3%81%AA%E3%82%B9%E3%82%BF%E3%83%BC%E3%82%92%E8%A8%AD%E7%BD%AE%E3%81%99%E3%82%8B%E3%81%A8%E3%81%8D%E3%81%AB%E8%A9%B0%E3%81%BE%E3%82%8B%E3%81%A8%E3%81%93%E3%82%8D/" target="_blank">WordPressにはてなスターを設置するときに詰まるところ | .COM-POUND</a>
<a href="http://futuremix.org/2007/11/wordpress-hatena-star" target="_blank">WordPress にはてなスターを設置</a>
<a href="http://mirahouse.jp/murmur/?p=211" target="_blank">WordPressにはてなスターを設置 | 雪よりも白く 緋よりも赤く</a>
<a href="http://watermoon-blog.blogspot.jp/2012/03/blogger_30.html" target="_blank">日常&#65312;水月&#12288;Blogger版: Bloggerで&#12300;はてなスター&#12301;を表示するときのテンプレート修正</a>
