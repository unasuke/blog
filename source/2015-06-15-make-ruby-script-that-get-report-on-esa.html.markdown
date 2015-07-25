---
title: esaの日報から勤務時間を計算するRubyスクリプトをつくった
date: '2015-06-15'
tags:
- diary
- esa
- programming
- ruby
---

<h2>esaとは</h2>
<p>
弊社では、業務日報はesa(<a href="https://esa.io/">https://esa.io</a>)で管理しています。
</p>
<p>
さてそのesaですが、先日APIがpublic β公開されました(<a href="https://docs.esa.io/posts/109">release_note/2015/05/27/esa API v1をβ公開しました</a>)。同時に<a href="https://docs.esa.io/posts/102">API docs</a>とRuby Gem(<a href="https://github.com/esaio/esa-ruby">esaio/esa-ruby</a>)も公開されました。
</p>
<p>
ということで、勤務時間を計算するRubyスクリプトを作れそうだったので、作ることにしました。
</p>

<h2>スクリプト作成までの道のり</h2>
<h3>access token取得</h3>
<p>
まず、今回は読めればいいだけなのでread onlyでaccess tokenを取得します。右上にある自分のアイコンを押して飛ぶ画面でaccess tokenを発行します。
<a href="http://unasuke.com/wp/wp-content/uploads/2015/06/spicelife_esa_io.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/06/spicelife_esa_io-1024x621.png" alt="access token" width="625" height="379" class="alignnone size-large wp-image-1190" /></a>
</p>

<h3>とりあえずサンプルコードを実行</h3>
<p>
access tokenが取得できたら、githubのREADMEに記載されているusageに記載されているコードを試してみます。
<pre class="font-size:16 lang:ruby decode:true " >require 'esa'

client = Esa::Client.new(access_token: "xxxxxxxxxxxxxxxxxxxxxxxx", current_team: "xxxxxx")
puts client.posts</pre> 
このコマンドで、esaに投稿されている記事がガッと取得出来ました。多すぎますね。
</p>

<h3>検索クエリで絞り込む</h3>
<p>
欲しい記事のカテゴリ、投稿者はわかっている(日報なので)ので、検索クエリを用いて特定の記事を取得します。usageを読むと、postsに引数としてクエリを渡してやると良さそうです。
<pre class="font-size:16 lang:ruby decode:true " >require 'esa'

client = Esa::Client.new(access_token: "xxxxxxxxxxxxxxxxxxxxxxxx", current_team: "xxxxxx")
puts client.posts(q: "user:unasuke category:日報/2015/06")</pre>
これで、投稿者が"unasuke"で、カテゴリが"日報/2015/06"の記事(今月の日報)が取得できます。15分毎にAPIリミットがリセットされるとはいえ、あんまり何回もGETするのもアレなので応答を何かに格納しておきましょう。
<pre class="font-size:16 lang:ruby decode:true " >require 'esa'

client = Esa::Client.new(access_token: "xxxxxxxxxxxxxxxxxxxxxxxx", current_team: "xxxxxx")
response = client.posts(q: "user:unasuke category:日報/2015/06")</pre>
</p>

<h3>記事の本文を取得する</h3>
<p>
取得ができたので、本文の解析に移ります。まず本文はどこに入っているかというと、こうなっています。 
<pre class="font-size:16 lang:ruby decode:true " >{"posts"=&gt;
    [{"number"=&gt;3949,
      "name"=&gt;"unasuke",
      "full_name"=&gt;"日報/2015/06/15/unasuke",
      "wip"=&gt;true,
      "body_md"=&gt;"markdown文字列",
      "body_html"=&gt;"html文字列",
      "created_at"=&gt;"2015-06-15T20:05:50+09:00",
      "message"=&gt;"Update post.",
      "url"=&gt;"https://hoge.esa.io/posts/3949",
      "updated_at"=&gt;"2015-06-15T20:34:16+09:00",
      "tags"=&gt;[],
      "category"=&gt;"日報/2015/06/15",
      "revision_number"=&gt;2,
      "created_by"=&gt;
...</pre>
解析するのに便利なのはmarkdownなので、markdownでの記事内容を取得します。このようにします。
<pre class="font-size:16 lang:ruby decode:true " >require 'esa'

client = Esa::Client.new(access_token: "xxxxxxxxxxxxxxxxxxxxxxxx", current_team: "xxxxxx")
response = client.posts(q: "user:unasuke category:日報/2015/06")

for i in 1...response.body["posts"].size do
  puts response.body["posts"][i]["body_md"]
end</pre>
</p>

<h3>日報の中から時間が書いてある部分を抜き出す</h3>
<p>
日報の中から合計勤務時間が書いてある部分を抜き出します。僕は日報の勤務時間を
<pre class="lang:default decode:true " ># 勤務時間

| 場所 | 時間 | 小計 |
| --- | --- | --- |
| オフィス | 10:50 - 13:00 | 2:10 |
| オフィス | 14:00 - 20:30 | 6:30 |
| 合計 |  | 8:40 |</pre> 
このように書いているので、「合計」が含まれる行を持ってくれば良さそうです。また、その中でも、コロンで区切られている数字のみを持ってくればいいので、以下の様に正規表現オブジェクトを作成して抜き出しました。
<pre class="font-size:16 lang:ruby decode:true " >require 'esa'

client = Esa::Client.new(access_token: "xxxxxxxxxxxxxxxxxxxxxxxx", current_team: "xxxxxx")
response = client.posts(q: "user:unasuke category:日報/2015/06")

for i in 1...response.body["posts"].size do
  puts response.body["posts"][i]["body_md"].scan(/^.*合計.*$/)[0].scan(/\d+:\d+/)
end</pre>
これで、以下の様な配列が得られました。 
<pre class="font-size:16 lang:default decode:true " > ["8:00", "9:10", "8:00", "10:00", "7:30", "7:50", "7:30", "7:30", "8:30", "8:00"]</pre> 
</p>

<h3>時間の計算をする</h3>
<p>
あとは簡単で、時間の計算をしてやれば合計勤務時間が求まります。最終的なコードはこのようになりました。

https://gist.github.com/unasuke/56d8b169a1db12b3d05b

</p>

<h2>まとめ</h2>
<p>
esaがどんどん便利になっていきます。(scriptの名前はアイドルマスターシンデレラガールズの三好紗南から取りました)
</p>

<h2>2015-06-21 追記</h2>
<p>
sana.rbの動作を修正しました。
</p>
