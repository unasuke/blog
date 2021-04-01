---
title: "S3は巨大なKVSなのでRailsのCache storeとしても使える"
date: 2021-04-01 21:51 JST
tags: 
- programming
- ruby
- rails
- aws
- s3
---

![s3_cache_store](2021/s3_cache_store.png)

## S3 is a Key-Value store

> Amazon S3 は、一意のキー値を使用して、必要な数のオブジェクトを保存できるオブジェクトストアです。
>
> [Amazon S3 オブジェクトの概要 - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/UsingObjects.html)

<br />

> Amazon S3の基礎技術は、単純なKVS（Key-Value型データストア）でしかありません。
>
> [Amazon S3における「フォルダ」という幻想をぶち壊し、その実体を明らかにする | DevelopersIO](https://dev.classmethod.jp/articles/amazon-s3-folders/)

Amazon S3の実体はKey-Value storeという事実は、既にご存知の方々にとっては何を今更というようなことではありますが、それでも初めて聞くときには驚かされたものです。

さて、Key-Value storeと聞いて一般的に馴染みが深いのはRedisでしょう。そして、RailsにおけるRedisの役割としてCache storeがあります。

> **2.6 ActiveSupport::Cache::RedisCacheStore**
> Redisキャッシュストアは、メモリ最大使用量に達した場合の自動エビクション（喪失: eviction）をサポートすることで、Memcachedキャッシュサーバーのように振る舞います。
>
> [Rails のキャッシュ機構 - Railsガイド](https://railsguides.jp/caching_with_rails.html#activesupport-cache-rediscachestore)

ここで、あるアイデアが降りてきます。

**「S3がKey-Value storeであるならば、Cache storeとしてS3を使うこともできるのではないか？」**

それでは、実際に `ActiveSupport::Cache::S3CacheStore` の実装をやってみましょう。

## Cache Storeを新規に作成する
そもそも、Cache storeを新規に作成することはできるのか、できるならどのようにすればいいのでしょうか。

`activesupport/lib/active_support/cache.rb` には、以下のような記述があります。

<https://github.com/rails/rails/blob/v6.1.3.1/activesupport/lib/active_support/cache.rb#L118-L122>

```ruby:activesupport/lib/active_support/cache.rb#L118-L122
# An abstract cache store class. There are multiple cache store
# implementations, each having its own additional features. See the classes
# under the ActiveSupport::Cache module, e.g.
# ActiveSupport::Cache::MemCacheStore. MemCacheStore is currently the most
# popular cache store for large production websites.
```

つまり抽象クラスであるところの  `ActiveSupport::Cache::Store` を継承し、必要なmethodを実装することにより作成できそうです。

新規に実装する必要のあるmethodは何でしょうか。コメントを読み進めていくと、以下のような記述が見つかります。

<https://github.com/rails/rails/blob/v6.1.3.1/activesupport/lib/active_support/cache.rb#L124-L125>

```ruby:activesupport/lib/active_support/cache.rb#L124-L125
# Some implementations may not support all methods beyond the basic cache
# methods of +fetch+, +write+, +read+, +exist?+, and +delete+.
```

とあるように、 `fetch`、 `write`、 `read`、 `exist?`、 `delete` の実装をすればいいのでしょうか。もっと読み進めると、以下のような記述と実装があります。

<https://github.com/rails/rails/blob/v6.1.3.1/activesupport/lib/active_support/cache.rb#L575-L585>

```ruby
# Reads an entry from the cache implementation. Subclasses must implement
# this method.
def read_entry(key, **options)
  raise NotImplementedError.new
end

# Writes an entry to the cache implementation. Subclasses must implement
# this method.
def write_entry(key, entry, **options)
  raise NotImplementedError.new
end
```

先程列挙した `fetch` や `write` も内部では `read_entry` などを呼び出すようになっており、実際にはこれらのmethodを定義すればよさそうということがわかります。他にも `Subclasses must implement this method.` とされているmethodを列挙すると、以下のものについて実装する必要があることがわかりました。

- `read_entry`
- `write_entry`
- `delete_entry`

## S3の制限
ということで、まずは愚直に実装してみました。 `read_entry` の実装のみ抜き出すと、以下のようになります。

```ruby
def read_entry(key, options)
  raw = options&.fetch(:raw, false)
  resp = @client.get_object(
    {
      bucket: @bucket,
      key: key
    })
  deserialize_entry(resp.body.read, raw: raw)
rescue Aws::S3::Errors::NoSuchKey
  nil
end
```

これは一見うまくいくように見えます。そこで、既存のテストケースを新規に実装したCache classを対象に実行してみると、次のようなメッセージで落ちるようになりました。

![落ちる](2021/s3_cache_store_test_fail.png)


落ちているテストの実体は以下です。

<https://github.com/rails/rails/blob/v6.1.3.1/activesupport/test/cache/behaviors/cache_store_behavior.rb#L475-L483>

```ruby
def test_really_long_keys
  key = "x" * 2048
  assert @cache.write(key, "bar")
  assert_equal "bar", @cache.read(key)
  assert_equal "bar", @cache.fetch(key)
  assert_nil @cache.read("#{key}x")
  assert_equal({ key => "bar" }, @cache.read_multi(key))
  assert @cache.delete(key)
end
```

Cache keyの名前として2048文字のものを登録しようとしています。

ここで改めてAmazon S3のドキュメントを読むと、以下のような制限があることがわかりました。

> キー名は一続きの Unicode 文字で、UTF-8 にエンコードすると最大で 1,024 バイト長になります。
> [オブジェクトキー名の作成 - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/object-keys.html)

ということで、基本的なテストケースを通過させることがS3の制限上できません。

……というような話を [Omotesando.rb #60](https://omotesandorb.connpass.com/event/205513/)でしたところ、「SHA256などでHash化するとどうか」というアイデアを頂きました。

```ruby
def read_entry(key, options)
  raw = options&.fetch(:raw, false)
  resp = @client.get_object(
    {
      bucket: @bucket,
      key: ::Digest::SHA2.hexdigest(key),
    })
  deserialize_entry(resp.body.read, raw: raw)
rescue Aws::S3::Errors::NoSuchKey
  nil
end
```

そこで、このようにCache keyとして一度SHA2を通すことにより、cache key長の制限は回避することができました。

![一部通るようになった](2021/s3_cache_store_test_fail2.png)

## どこまでがんばるか
ここまで実行してきたテストは、 `activesupport/test/cache/behaviors/cache_store_behavior.rb` がその実体となります。

Cache storeのテストは、各storeについてのテストが  `activesupport/test/cache/stores/` 以下にあり、それらの内部で `activesupport/test/cache/behaviors/` 以下にある程度まとめられた振る舞いをincludeすることによってstoreに実装されている振る舞いをテストする、という構造になっています。 例を挙げると、 `RedisCacheStoreTest` と `MemCacheStoreTest` では `EncodedKeyCacheBehavior` をincludeしていますが、 `FileStoreTest` ではそうではありません。

ここでは一旦、およそ基本的な振る舞いのテストとなっているであろう `CacheStoreBehavior` の完走を目指して実装していきます。

Key長の課題を解決した時点で、失敗しているテストは以下3つです。

- `test_crazy_key_characters`
- `test_expires_in`
- `test_delete_multi`

このうち、 `test_delete_multi` と `test_crazy_key_characters` については実装を少し修正することによってテストが通るようになりました。しかし、 `test_expires_in` はそうもいきません。

## test_expires_in をどうするか
このテストの内容は以下です。

<https://github.com/rails/rails/blob/v6.1.3.1/activesupport/test/cache/behaviors/cache_store_behavior.rb#L392-L407>

```ruby
def test_expires_in
  time = Time.local(2008, 4, 24)

  Time.stub(:now, time) do
    @cache.write("foo", "bar")
    assert_equal "bar", @cache.read("foo")
  end

  Time.stub(:now, time + 30) do
    assert_equal "bar", @cache.read("foo")
  end

  Time.stub(:now, time + 61) do
    assert_nil @cache.read("foo")
  end
end
```

ここでは、Cacheの内容が指定した時間にちゃんとexpireされるかどうかを確認しています。テスト時に、各Cache storeにoptionとして `expires_in` を60として渡しており、その時間が経過した後にCache keyがexpireされて `nil` が返ってくることを確認しています。

このテストが落ちてしまっているのは、  `Aws::S3::Errors::RequestTimeTooSkewed` という例外が発生しているためで、これはリモートのS3とリクエストを送信しているローカルマシンの時刻が大幅にずれているために発生するものです。

テスト内で `Time.now` をstubし、2008年4月24日にリクエストを送信するようなテストになっているので、これをそのままなんとかするのは非常に困難 [^time] です。

では、テスト側を変更するのはどうでしょう。Too skewedで怒られるのであれば、tooでなければいいと思いませんか？

ということで、以下のように変更しました。(ある程度の余裕を持たせて120秒戻しました)

```diff
   def test_expires_in
-    time = Time.local(2008, 4, 24)
+    time = Time.current - 120.seconds
 
     Time.stub(:now, time) do
       @cache.write("foo", "bar")
```

こうすると、 `CacheStoreBehavior` に定義されているテストは全てpassしました。

![通るようになった](2021/s3_cache_store_test_pass.png)

## gemにする
ここまでは既存のテストの使い回しなどの都合上、rails/rails の内部に実装していましたが、どうせならgemにしてしまいましょう。

<https://github.com/unasuke/s3_cache_store>

してしまいました。rubygems.orgでhostするほどのものでもないなと感じたので、使用したい場合は直接GitHubのURLを指定するようにしてください。

## Pros/Cons
下らないひらめきがきっかけで実装したこのS3CacheStoreですが、既存のCache storeに対して優位となる点があるかどうか考えてみます。

### Pros: 高い可用性
S3の可用性は「99.99%を提供する」とされており[^s3]、これは月間で4分程度、年間で1時間に満たない程度のダウンタイムが発生する程度です。これはRedisCacheStoreのバックエンドに同じAWSのElastiCacheを採用した場合のSLAと比較[^sla]すると、ElastiCacheは99.9%なので1ケタ高い可用性を持ちます。

S3は、S3CacheStoreを使用するRails appよりはるかに高い可用性を持つことは明らかでしょう。

### Pros: (事実上)無限のCache storage
無限ではないですが……少なくともRedisやMemcachedをCache storeにした場合、S3はそれらよりはるかに大容量のCache storageとして振る舞うことができます。
例えばRedisの基本的なdata typeであるStringsは、サイズの上限が512MBとなっています[^redis]が、S3では1つのオブジェクトの最大サイズは5TBです[^s3size]。

そんなでかいサイズのものをCacheとして保存する意味はわかりませんが、とにかく大きなデータについてもCacheできます。

### Cons: 遅い
……と言い切ってしまいましたが、本当に遅いのでしょうか？試してみましょう。

<https://github.com/unasuke/s3_cache_store/blob/master/benchmark.rb>

```ruby
def bench_redis_cache_store
  store = ActiveSupport::Cache::RedisCacheStore.new({
    url: 'redis://localhost:6379'
  })
  redis_start = Time.now
  (1..COUNT).each do |e|
    store.write(e, e)
    store.read(e)
  end
  redis_duration = Time.now - redis_start
  puts "RedisCacheStore duration: #{redis_duration} sec (#{redis_duration / COUNT} s/key)"
end

def bench_s3_cache_store
  store = ActiveSupport::Cache::S3CacheStore.new({
    access_key_id: 'minioadmin',
    secret_access_key: 'minioadmin',
    region: 'us-east-1',
    endpoint: 'http://127.0.0.1:9000',
    force_path_style: true,
    bucket: BUCKET
  })
  s3_start = Time.now
  (1..COUNT).each do |e|
    store.write(e, e)
    store.read(e)
  end
  s3_duration = Time.now - s3_start
  puts "S3CacheStore duration: #{s3_duration} sec (#{s3_duration / COUNT} s/key)"
end
```

重要な部分のみ切り出したものを上に貼りました。

検証には、どちらもlocalのDockerで起動したRedisとMinIOを使用しました。では実行してみましょう。

```shell
$ ruby benchmark.rb
Fetching gem metadata from https://rubygems.org/.............
Fetching gem metadata from https://rubygems.org/.
# ...snip...

===== start benchmark ==========
RedisCacheStore duration: 1.2188961 sec (0.0012188961 s/key rw)
S3CacheStore duration: 9.5209312 sec (0.009520931199999999 s/key rw)
===== end benchmark ============

# ...snip...
```

何度か実行しても8～9倍の開きがあることがわかりました。よって、遅いですね。MinIOを使用しているのでS3とElastiCacheではまた違った結果になることが予想できますが、localhostに閉じた通信ですらこのような速度差が出ることを考えると、Cache storeとしては実用的ではないでしょう。

## まとめ
Amazon S3の内部実装は Key-Value Storeです。

[^time]: ですよね？
[^s3]: <https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/DataDurability.html>
[^sla]: 実際にはS3のSLAはElastiCacheと同様に99.9%なので、SLAの範囲で比較すると差はないことになります。 <https://aws.amazon.com/jp/s3/sla/> と <https://aws.amazon.com/jp/elasticache/sla/> より
[^redis]: <https://redis.io/topics/data-types#strings>
[^s3size]: <https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/UsingObjects.html>
