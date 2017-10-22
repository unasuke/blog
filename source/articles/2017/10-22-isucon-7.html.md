---
title: 'ISUCON 7 やまのほすけ 提出スコア 11,204'
date: 2017-10-22 23:50 JST
tags:
- Programming
- isucon
---

![落ち着くこと](2017/isucon-7-whiteboard.jpg)

## メンバー
- やまま [@kirikiriyamama](https://twitter.com/kirikiriyamama)
  - 参加は3回目？
- のほ [@n0_h0](https://twitter.com/n0_h0/)
  - 初参加
- うなすけ [@yu_suke1994](https://twitter.com/yu_suke1994)
  - 参加は2回目

## やったこと(順不同)
僕らが高速化したのはRuby実装です。

### MySQLのチューニング by のほ
まずはslow query logの有効化、それから`innodb_buffer_pool_size`を1Gにしました。

### deploy scriptの作成 by うなすけ
今回はサーバーが複数台あるので、手元で叩いて各サーバーにssh経由で`git pull`と`sudo systemctl restart`をさせようと思ったのですがなかなかうまくいかず、結局サーバーにsshした上で実行するscriptになってしまいました。

このscriptはちょこちょこ書き替えが発生していました。

### user.nameにindexを張る by うなすけ
```sql
CREATE TABLE user (
  id BIGINT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  name VARCHAR(191) UNIQUE,
  salt VARCHAR(20),
  password VARCHAR(40),
  display_name TEXT,
  avatar_icon TEXT,
  created_at DATETIME NOT NULL,
  INDEX(name)
) Engine=InnoDB DEFAULT CHARSET=utf8mb4;
```

ただ、このQueryを実際に流すのを忘れていて、終了10分前とかに気づいてIndexを張ったというポカミスがあります。

### RACK_ENVをdeploymentに by うなすけ
定石というか、なんというか。あわせて`APP_ENV`(Sinatra)も`production`にしています。

### 静的ファイルをnginxから返すように by やまま
これも定石。しかし、nginxから返すようにしてから数十件の静的ファイルへのリクエストがタイムアウトするようになってしまいました。はじめはnginxが詰まったのだろうか……と考えていましたが、その後Discordでeth0で頻繁にネットワーク遅延が発生していると報告がなされました。もしやと思って僕からnginxへのリクエストがタイムアウトする旨を使えたところ、報告された方も同様の症状だったそうで、「これはインスタンスガチャか……？」となりました。

しかし競技終了後、`Cache-control public`や`last-modified`、`Etag`の値などは考慮していないことに気付き、やはり自分達に原因があったのでは……となりました。(このへん詳細ちょっと不明です)

### /loginと/registerへのGETを静的に返す by うなすけ
これは最初、アプリのコードを読むと静的やんけ〜〜となったので雑にpublic以下にhtmlを生成して置いたところ、ステータスコードでひっかかってダメでした。nginxで返すときにステータスコードも強制的に302に書き替えたりもしてみましたが、Locationヘッダーも必要でアーそうですねとなって一旦撤退しました。

しかしその後、「一度File.openとかで変数に格納して、それを返すようにすればいいのでは？」と気付きを得てそのようにしたところ、有意なスコアの上昇が見られてよかったです。もっと早く気付くべきですね。

### N+1となるクエリをjoinで解消 by うなすけ
`/message`と`/history/:channel_id`へのGETは、その内部で実行しているSQLにN+1問題があることがわかります。なので、これをjoinして解決することにしました。

```ruby
 statement = db.prepare(
   'SELECT message.id, message.created_at, message.content, message.user_id, user.name as user_name, user.display_name as display_name, user.avatar_icon as avatar_icon FROM message INNER JOIN user ON user.id = message.user_id WHERE message.channel_id = ? ORDER BY message.id DESC LIMIT ? OFFSET ?'
 )
 rows = statement.execute(@channel_id, n, (@page - 1) * n).to_a
 statement.close
 @messages = []
 rows.each do |row|
   r = {}
   r['id'] = row['id']
   statement = db.prepare('SELECT name, display_name, avatar_icon FROM user WHERE id = ?')
   r['user'] = statement.execute(row['user_id']).first
   r['user'] = { display_name: row['display_name'], avatar_icon: row['avatar_icon'], name: row['user_name'] }
   r['date'] = row['created_at'].strftime("%Y/%m/%d %H:%M:%S")
   r['content'] = row['content']
   @messages << r
 end
```
hashにぶち込んでレスポンスを返すところ、特にuserの情報の部分では、`/history/:channel_id`ではerbから参照しているのでhashのkeyがSymbolになっているとベンチマークでエラーが出るのにはちょっとハマりました。

あと競技終了後のDiscordで、`statement.close`の漏れがけっこうあることを指摘されていて、この辺の知識がなく`statement.close`の有無がどう影響してくるのか不明で放置してしまっていました。

### /fetchでのsleepを5秒にした(けどやめた) by うなすけ
レギュレーションには`/fetch`へのアクセスは採点対象ではないことが書いてあり、`/fetch`へのアクセス回数を減らせられればその分リクエストの処理が可能なのではないかと思い5秒までのばしてみましたが、ベンチで有意なスコア上昇が見られなかったことと、pumaのスレッド使い尽したらリクエスト受けられないのでは？と思いrevertしました。短くしようかとも思いましたが時間が足りず挑戦していません。

### Varnishを用いたリクエストの分散 by やまま
もともとサーバーそのものは3台提供されていましたが、リクエストはapp1台とdb1台で処理していました。

これをVarnishにより、まずリクエストはapp1で受け、`/profile`へのPOSTと静的ファイルへのリクエストはapp2のnginx + pumaで、それ以外はapp1のpumaで受け、裏のdb1にデータを取りに行くという構成にしました。

多分今回のなかで一番大仕事かつ成果のあった作業だと思います。(これでベストスコアが出た)

## よくわからなかったところ
### pumaが重くなっていく
長時間サーバーを起動しっぱなしにしていると、/initializeが規定時間内に終わらなくなってしまいました。これは、`isubata.ruby.service`の再起動で解消されるので、ベンチマーク実行前にserviceの再起動をかけるようにして凌いでました。

## 感想
去年の提出スコアが0だったことを考えると、スコアが11204というのはもう去年の何倍というスケールには収まらない成長っぷり(？)でめちゃくちゃ嬉しいです。が、もっとやれることあっただろ、というところでもあります。

あと予習とか訓練が足りなかったかなーと思います。(2週間前にisucon4の予選問題でリハーサルをしただけ)

## 行動ログ
分単位で記入していますが曖昧です。

| 時刻 | 行動 |
| -- | -- |
| 9:05 | うなすけ 会場準備 |
| 11:41 | うなすけ ラブライブ サンシャイン 1期完走 |
| 13:00 | 競技開始、みんなで予選当日マニュアルのgistを読む |
| 13:10 | うなすけ Ruby実装を使うようsystemctlで設定、初期実装でのスコアを見るため先頭2台をenqueue (6173) |
| 13:19 | うなすけ アプリのコードをローカルにscp |
| 13:24 | うなすけ private git repositoryを用意 |
| 13:30 以降 | うなすけ → deploy script、のほ → MySQL、やまま → アプリ理解 に分担 |
| 14:32 | のほ slow_query_log など有効化 |
| 14:34 | うなすけ deploy scriptの大枠が完成 |
| 15:00 ごろ | やまま インスタンス内からbundler消失疑惑がありあたふた |
| 15:26 | やまま systemdの設定とnginxの設定をrepository管理下に |
| 15:37 | うなすけ RACK_ENVをdeploymentに |
| 15:43 | のほ innodb_buffer_pool_sizeを1GBに |
| 15:45 | うなすけ user.nameにINDEXを張る(コード上のみで実際には張らず) |
| 15:48:40 | スコア 6227を記録 |
| 16:03 | うなすけ SQLのJoin化に着手 |
| 16:07:40 | スコア 6403を記録 |
| 17:00 ごろ | やまま 静的ファイルをnginxから配信するように悪戦苦闘中 |
| 17:23 | うなすけ SQLをJoinするように |
| 17:44:30 | スコア 5698を記録 |
| 17:45 | やまま pumaとnginxの間をunix domain socketで繋ぐ |
| 17:46:46 | スコア 8540を記録 |
| 18:08 | うなすけ /login と /registerのGETをnginxから返すようにする |
| 18:48 | うなすけ /login と /registerのGETをnginxから返すようにするのをやめる |
| 18:54:47 | スコア 10852を記録 |
| 18:56:27 | スコア 8248を記録 |
| 18:57 | やまま Varnishの導入に着手 |
| 18:59:24 | スコア 3016を記録 |
| 19:04:44 | /initializeがTimeoutし始める |
| 19:17 | うなすけ /fetchで5秒sleepするようにしてみる |
| 19:27:48 | スコア 5678を記録 |
| 19:39 | やまま Varnishを使ったrequestの分散に着手 |
| 19:51:22 | スコア 4032を記録 |
| 19：57 | うなすけ /fetchで5秒sleepするコードをrevert |
| 20:00 | やまま Varnishを使ったrequestの分散を完了 |
| 20:00ごろ | みんなで他になにかできるか確認 |
| 20:31 | うなすけ /loginと/registerを変数から返すようにする |
| 20:31:26 | スコア 11246を記録 |
| 20:35ごろ | あまり覚えてないけど再起動試験とかしてたはず |
| 20:40 | user.nameにINDEXが張られる |
| 20:42:42 | スコア 12033を記録(ベストスコア) |
| 20:51:28 | スコア 11204を記録(提出スコア) |

## 追記
### 2017-10-23 0:14
誤字の修正とメンバー紹介を追加しました。 (ykztsさんありがとうございます :pray: )
