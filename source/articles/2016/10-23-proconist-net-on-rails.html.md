---
title: 'Proconist.netがRails Applicationになりました'
date: 2016-10-23 21:10:00 JST
tags:
- programming
- ruby
- rails
- sinatra
---

![railsです](2016/proconist-net-on-rails.png)

## sinatraからRailsへ
さて皆さんご存知の[Proconist.net](https://proconist.net/)ですが、これはsinatra applicationとして作られました。

そしてsinatra applicationは、いろいろいい感じにしていくとRailsに近づいていく、というのはよく知られたことです。

じゃあRailsにしちゃえということで、しました。

![発端](2016/proconist-net-on-rails-issue-46.png)

[unasuke/proconist.net: The repository links for fighter of KOSEN PROCON.](https://github.com/unasuke/proconist.net)

移行期間がちょうどプロコン本戦とかぶっているので、これもプロコンです。

## sinatraの構成
sinatraは、こういう構成で動作していました。

- sinatra
- SQLite
- unicorn
- nginx
- さくらのVPS

こいつをRailsに移し替えるわけです。

## ただRailsにするだけではない
とはいえそのまんまロジックをRailsに移し替えるだけではなく、modelの正規化等も行いました。具体的には以下を行いました。


- DB 正規化
- model 分割
- specを書く
- CI導入
- erb → slim
- SQLite → MySQL
- unicorn → puma
- ひたすらcontrollerつくる

### DB正規化
sinatraでの、ある高専の作成したプログラムを表すtableは以下のように定義されていました。

```ruby
create_table "entrants", force: true do |t|
  t.integer "contest",      null: false
  t.integer "section",      null: false
  t.integer "registry_num", null: false
  t.string  "school",       null: false
  t.string  "production",   null: false
  t.string  "github"
  t.string  "bitbucket"
  t.string  "other_repo"
  t.string  "slideshare"
  t.string  "other_slide"
  t.string  "twitter"
  t.string  "facebook"
  t.string  "site"
  t.integer "result"
  t.string  "prize"
end
```

たとえば`school`は個別に格納されていて、正規化をおこなう余地がありました。また、`prize`にはその高専のプログラムが獲得した賞が「カンマ区切り」で格納されているので、これも別々のrecordに格納することでより健全な状態にDBを持っていくことができます。

そこで、このようにtableを分割しました。

```ruby
# index、datatimeなど省略

create_table "products", force: :cascade do |t|
  t.integer  "contest_id", null: false
  t.integer  "section",    null: false
  t.integer  "school_id",  null: false
  t.string   "name",       null: false
  t.integer  "rank"
end

create_table "documents", force: :cascade do |t|
  t.integer  "product_id",    null: false
  t.string   "document_type", null: false
  t.string   "url",           null: false
end

create_table "prizes", force: :cascade do |t|
  t.integer  "product_id", null: false
  t.string   "name",       null: false
end

create_table "schools", force: :cascade do |t|
  t.string   "name",       null: false
end
```

このようにtableの定義を書き換え、8 tablesから11 tablesに分け、正規化をおこないました。

### model 分割
DBのtableが分割されたということは、modelも分割されるというのは想像に難くないでしょう。

8 modelsから10 modelsに分割しました。table数と一致しないのはhabtm関連があるためです。

### specを書く
sinatraの頃はspecが存在しなかったのですが、Railsに移行するにあたってRSpecとRuboCopを導入しました。

しっかりとした移行をおこなうのであればもとのsinatra appに対してのブラックボックステストをまず作成すべきだと指摘を受けるかもしれませんが、そこまでする気力はありませんでした。

### CI導入
そしてspecを書くにあたって欠かせないと言っていいのがCI serviceですが、自分が使いたかったのもあってwerckerを選択しました。

またカバレッジを計測するためにCoverallsも導入しました。記事執筆時点でのカバレッジは89%です。

### erb → slim
sinatraのviewは全てerbで書かれていました。僕はerbというか生のhtmlを書くのが本当に嫌で、そういうものは記述量の少ないテンプレートエンジンに置き換えたいと思っているので、slimを使用することにしました。

34のerb filesが、42のslim filesに変換されました。erbが1 file残っているのですが、google analyticsのpartialなので、むしろslimにしないほうが良いかと思いerbのままにしています。

### SQLite → MySQL
sinatraのDBはSQLiteを使用していました。これを、DB schemaも変わるということでMySQLに移行しました。

```yaml
default: &default
  adapter: mysql2
  encoding: utf8mb4
  charset: utf8mb4
  collation: utf8mb4_general_ci
  pool: 5
  username: root
  password:
  host: localhost
```

`config/database.yml`をこのように定義することで、🍣🍺問題、ハハパパ問題への対応をおこないました。

#### 参考
- [MySQL と寿司ビール問題 - かみぽわーる](http://blog.kamipo.net/entry/2015/03/23/093052)
- [RailsとMySQLでiOSの絵文字に対応(UTF8MB4化)した話 - Akata Works](http://akataworks.hatenadiary.jp/entry/2016/02/26/102439)

### unicorn → puma
rails 5のリリースということがこの移行のきっかけの1つということもあり、特に理由もなくunicornからpumaに移行しました。

### ひたすらcontrollerつくる
あとは、既存のviewに対応するControllerを作成していきました。管理画面用のcontrollerは改装を分けるなどを行い、結果的に17のcontrollerを作成しました。

![controller list](2016/proconist-net-on-rails-controllers.png)

ヘタにtableを分割したので、controllerが肥大化した部分があり、今後refactoringしていきたいと思っています。

[proconist.net/products_controller.rb at caa35ad4 - unasuke/proconist.net](https://github.com/unasuke/proconist.net/blob/caa35ad440a2fd235c93e0f6c684e934f1edebd4/app/controllers/consoles/products_controller.rb)

### 本番VPSへのdeploy
後述しますが、既存のVPSにdeployをすることになりました。しかし(おそらく)sinatraはインスタンスからgit pullをしているので、これをCapistranoによるdeployに置き換えました。

deploy時に、VPS上の環境変数が評価されないという問題があり、login shellを設定するという変更を行いましたが、基本的にはデフォルトの設定をそのまま使用しています。(pumaのrestartだけ変更)

```ruby
# config/deploy/production.rb

# fetch environment variable from .bashrc
set :default_shell, '/bin/bash -l'
```

## できなかったこと
### AWS上に構築
もともとAWS上に構築していきたい気持ちがあったのですが、移行までにかかる手間、[酒田　シンジ](https://twitter.com/NKMR6194)さんとの共同作業のコストを考えると、既存のVPSに構築するのが一番楽でかつ素早いものでした。

### Dockerize
またAWS上に構築しないことで、必然的にDockerizeする意味もなくなりました。(ECRを使いたかった気持ちがありました。)

## これからやること
### specの充実
実装を急いでいた部分もあり、specは不十分です。とくに管理画面のcontrollerに対するspecは全く無いので、カバレッジ90%台まではせめて持っていきたい気持ちがあります。

### refactoring
付随して、実装が冗長な部分や汚い部分がいくつかあるので、それを修正していくのも早急に行いたいです。PullRequest待ってます。

### 監視
uptimerobotによる外形監視のみが有効なので、CPUやMemoryのUsageも見るようにしたいです。

## ふりかえって

[unasuke/proconist.net: The repository links for fighter of KOSEN PROCON.](https://github.com/unasuke/proconist.net)

大変だったのは、controllerの移行だったと思います。modelを分割したせいで、あるformをsubmitした時に複数のmodelの更新、または作成をする必要があり、paramsからfetchしてくる部分などとにかく泥臭いコードになってしまったと感じています。

次いで大変だったのは、VPS上へのdeployです。慣れないCentOSという環境、そして移行とはいえDBも変わるので、ほとんど一からの構築となると、まっさらの環境へapplicationが動作する状態を構築した経験のない僕にとっては試行錯誤の連発でした。

そしてそれらはいい経験になりました。

あとこの記事を書いている最中にもバグを見つけたので修正しなきゃなあと焦っています。

まず初めにProconist.netというweb applicationを作成し、Rails化という大役を僕に一任してくれた酒田　シンジ(NKMR6194)さん、結局採用されなかったインフラ構成に関してアドバイスをして頂いたやまま(kirikiriyamama)さん、本当にありがとうございます。

## Dentoo.LTでの発表

[発表の録画(youtube)](https://youtu.be/c5jokfnCgic?t=3h4m2s)

[発表資料(GitHub)](https://github.com/unasuke/dentoolt-15)

この日の朝7時まで移行作業をしていて完全に寝不足状態だったので、落ち着いた感じで発表していこうと思っていたのですが、いざ発表となるとスライドの枚数の多さと緊張から完全にハイテンションになって超早口になってしまいました。間に合わせるとはいえ、聞き苦しくて申し訳ない気持ちです。

## Gitter部屋
移行のついでに、Gitterで部屋を作りました。

[proconist.net/Lobby - Gitter](https://gitter.im/proconist-net/Lobby)


ここはProconist.netの実装のことや、その他プロコンに関連する雑多な話ができる交流の場として使って欲しいという思いで作成しました。参加について特に制限等を設けるつもりはないので自由に入って(抜けて)いただいて構いません。もちろん、プロコン参加者や高専生に限らず、どなたでも入室していただいて構いません。

ぜひご活用ください。

![GitHub addition and deletion](2016/proconist-net-on-rails-addition-and-deletion.png)
