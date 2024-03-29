---
title: "ISUCON予選スコア0"
date: 2016-09-19 00:00 JST
tags:
- Programming
- isucon
---

![isucon競技中に座っていた椅子](2016/isucon-used-chairs.jpg)

## 行動ログ(面倒なので常体)
### 前日(2016-09-16)
- kirikiriyamamaがAzureのアカウントを作るのに無限に失敗してキレる
  - なぜかふりがなを要求されたりされなかったりした
  - 無限に電話番号を聞かれていた

### 当日(2016-09-17)
- 全員起床成功
- 開始直前まで各種記事を予習、secret repositoryを作る
- ホワイトボードに「落ち着く」と書く
- 開始直後はインスタンスの準備が終わるまでまったり
- 「とりあえずベンチ走らすか」で適当やった結果Perl実装のベンチが走る
  - しかしこの時のスコア(Perl実装初期スコア)が結局僕らのチームの最高得点だった
- まずアプリを読む
- とりあえずスロークエリ調査する
  - mysqlの設定ファイルを書き換えても書き換えても`systemctl restart mysql.service`すると設定が無効になる
- nginxをいじって破滅
- POSTリクエストがタイムアウトするのをどうやっても直せない
- おしまい

## やったこと(順不同)
僕らが高速化したのはRuby実装です。

### slow\_query\_logの有効化
まずは定石、SQLのslow_queryが何なのかの調査をはじめました。

しかし、何度mysqlのconfigファイルにその設定を有効化した記述をしても、`systemctl restart mysql.service`すると無効状態に戻ってしまうので、
なんだかわからないままrestartは諦めました。(そもそもrestartするのも正しかったのか……？)

結果として、`stars` テーブルの`keyword`、`entry`テーブルの`keyword`、`user`テーブルの`name`にindexを張った他に、`content_length(keyword)`としていた部分を
`keyword_length`に値を格納してそこを見に行くようにアプリを変更したりするなどを行いました。

### アプリの一元化
`isuda`と`isutar`の2つのsinatra appが相互に通信を行っており、この部分がボトルネックになるのではないかと考えました。

そこで2つのappとdbをまとめてしまいましたが、効果の程はわかりません。(この改善で一瞬だけスコアが0以上を返しました。たしか160から180くらいでした。)

### 静的ファイルをnginxから配信する
`public`以下の静的なファイル群はnginxが返すように変更しました。

### keywordのanchor link化における正規表現での置換で用いるハッシュ関数を高速なものに置き換え
存在するkeywordはそのkeywordのurlへと置き換える実装がありました。その中で、一度keywordをSHA-1で置き換える部分があったのですが、それを`Zlib.crc32`に置き換えて高速化を狙いました。

ただ、おそらくはアルゴリズムの改変もしくは結果のキャッシュ化を行えたほうが良かったのではないかと思います。

### AppArmorの無効化
完全に気休めでした。

### `RACK_ENV`をdeploymentに
~~unicornは`RACK_ENV`をdeploymentかdevelopment以外は無視するので、アクセスログを見るためにproductionになっていたのをdeploymentにしました(thx kirikiriyamama!)~~

### 訂正(2016-09-20)
- [RACK_ENVとUnicorn、SinatraでのRACK_ENVの扱いと注意点 - Shoyan blog](http://shoyan.github.io/blog/2016/05/02/what-is-rack-env-and-unicorn-and-sinatra/)
- [ISUCON5 で準優勝してきた #isucon - diary.sorah](http://diary.sorah.jp/2015/11/02/isucon5f)

`RACK_ENV`とsinatraの環境は分離させることができて、sinatraの`environment`をproductionにすることで高速化できたようです。ただproductionのままだとunicornでログを見ることができないので、いずれにせよこの値はdeploymentにし、sinatraのenvironmentをproductionにすべきでした。

### スパム判定の呼び出しを少なくした
descriptionとkeywordそれぞれでスパム判定している部分を、それらを結合した文字列に対してスパム判定を行うようにしました。

### 不要なエンドポイントの削除
`/register`へはGETもPOSTもされていないので、エンドポイントごと削除しました。~~これやる意味あった？~~

### unix domain socketを使用する
unicornとnginxとの通信にunix domain socketを使用するようにしました。

またそれに限らずnginxまわりのチューニングは全部kirikiriyamamaさんに任せたので、これ以上のことをやってたかもしれません。

### パスワードの平文保存
ユーザー名とパスワードは同一のものが使用されているので、パスワードの暗号化処理をやめて平文で保存するようにしました。

### `/login`の静的ページ化
`/login`のGETは完全に静的ページを返せるので、そのようにしました。

## 反省
とにかく、スコアが0のまま放置していたのが一番の反省かと思います。どのような改善を試行しても、それによって性能が良化したのか悪化したのかが判断できないからです。

競技中間、確か14時頃からはずっと`/login`、`/star`、`/keyword`へのPOSTがタイムアウトする原因を探っていました。アクセスログを見る限り、499が返っているのですが、手元ではmsec単位でresponseが返ってくるので本当に謎でした。それらのPOST requestは終了後に`/`へリダイレクトするのですが、この`/`へのアクセスが重いのでタイムアウトするのではないかと予測もしたのですが、それでは「POSTがタイムアウトする」というベンチマーカーのメッセージへの答えにはなっておらず、本当にうんうん唸ってそのまま終わってしまいました。

次回も参加したい！！！！！！！！

## commit log
![コミットログ](2016/isucon-commit-log.png)
