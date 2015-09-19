---
title: esaの日報から勤務時間を計算するRubyスクリプトをつくった
date: '2015-06-15'
tags:
- diary
- esa
- programming
- ruby
---

## esaとは

弊社では、業務日報はesa([https://esa.io](https://esa.io/))で管理しています。


さてそのesaですが、先日APIがpublic β公開されました([release\_note/2015/05/27/esa API v1をβ公開しました](https://docs.esa.io/posts/109))。同時に[API docs](https://docs.esa.io/posts/102)とRuby Gem([esaio/esa-ruby](https://github.com/esaio/esa-ruby))も公開されました。

ということで、勤務時間を計算するRubyスクリプトを作れそうだったので、作ることにしました。

## スクリプト作成までの道のり
### access token取得

まず、今回は読めればいいだけなのでread onlyでaccess tokenを取得します。右上にある自分のアイコンを押して飛ぶ画面でaccess tokenを発行します。
![access token](2015/spicelife-esa-io.png)

### とりあえずサンプルコードを実行

access tokenが取得できたら、githubのREADMEに記載されているusageに記載されているコードを試してみます。

```ruby
require 'esa'

client = Esa::Client.new(access_token: "xxxxxxxxxxxxxxxxxxxxxxxx", current_team: "xxxxxx")
puts client.posts
```

このコマンドで、esaに投稿されている記事がガッと取得出来ました。多すぎますね。


### 検索クエリで絞り込む

欲しい記事のカテゴリ、投稿者はわかっている(日報なので)ので、検索クエリを用いて特定の記事を取得します。usageを読むと、postsに引数としてクエリを渡してやると良さそうです。

```ruby
require 'esa'

client = Esa::Client.new(access_token: "xxxxxxxxxxxxxxxxxxxxxxxx", current_team: "xxxxxx")
puts client.posts(q: "user:unasuke category:日報/2016/06")
```

これで、投稿者が"unasuke"で、カテゴリが"日報/2015/06"の記事(今月の日報)が取得できます。15分毎にAPIリミットがリセットされるとはいえ、あんまり何回もGETするのもアレなので応答を何かに格納しておきましょう。
```ruby
require 'esa'

client = Esa::Client.new(access_token: "xxxxxxxxxxxxxxxxxxxxxxxx", current_team: "xxxxxx")
response = client.posts(q: "user:unasuke category:日報/2015/06")
```

### 記事の本文を取得する

取得ができたので、本文の解析に移ります。まず本文はどこに入っているかというと、こうなっています。

```ruby
{"posts"=>
    [{"number"=>3949,
      "name"=>"unasuke",
      "full_name"=>"日報/2015/06/15/unasuke",
      "wip"=>true,
      "body_md"=>"markdown文字列",
      "body_html"=>"html文字列",
      "created_at"=>"2015-06-15T20:05:50+09:00",
      "message"=>"Update post.",
      "url"=>"https://hoge.esa.io/posts/3949",
      "updated_at"=>"2015-06-15T20:34:16+09:00",
      "tags"=>[],
      "category"=>"日報/2015/06/15",
      "revision_number"=>2,
      "created_by"=>
...
```

解析するのに便利なのはmarkdownなので、markdownでの記事内容を取得します。このようにします。

```ruby
require 'esa'

client = Esa::Client.new(access_token: "xxxxxxxxxxxxxxxxxxxxxxxx", current_team: "xxxxxx")
response = client.posts(q: "user:unasuke category:日報/2015/06")

for i in 1...response.body["posts"].size do
  puts response.body["posts"][i]["body_md"]
end
```

### 日報の中から時間が書いてある部分を抜き出す

日報の中から合計勤務時間が書いてある部分を抜き出します。僕は日報の勤務時間を

```markdown
# 勤務時間

| 場所 | 時間 | 小計 |
| --- | --- | --- |
| オフィス | 10:50 - 13:00 | 2:10 |
| オフィス | 14:00 - 20:30 | 6:30 |
| 合計 |  | 8:40 |
```

このように書いているので、「合計」が含まれる行を持ってくれば良さそうです。また、その中でも、コロンで区切られている数字のみを持ってくればいいので、以下の様に正規表現オブジェクトを作成して抜き出しました。

```ruby
require 'esa'

client = Esa::Client.new(access_token: "xxxxxxxxxxxxxxxxxxxxxxxx", current_team: "xxxxxx")
response = client.posts(q: "user:unasuke category:日報/2015/06")

for i in 1...response.body["posts"].size do
  puts response.body["posts"][i]["body_md"].scan(/^.*合計.*$/)[0].scan(/\d+:\d+/)
end
```
これで、以下の様な配列が得られました。

```ruby
["8:00", "9:10", "8:00", "10:00", "7:30", "7:50", "7:30", "7:30", "8:30", "8:00"]
```


### 時間の計算をする

あとは簡単で、時間の計算をしてやれば合計勤務時間が求まります。最終的なコードはこのようになりました。

<script src="https://gist.github.com/unasuke/56d8b169a1db12b3d05b.js"></script>

## まとめ

esaがどんどん便利になっていきます。(scriptの名前はアイドルマスターシンデレラガールズの三好紗南から取りました)


## 2015-06-21 追記

sana.rbの動作を修正しました。
