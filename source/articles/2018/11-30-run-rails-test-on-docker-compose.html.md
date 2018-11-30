---
title: Railsのテストを実行する環境をdockerで構築したが使いみちがない
date: 2018-11-30 22:00 JST
tags: 
- rails
- docker
- programming
---

![docker-compose ps](2018/run-rails-test-on-docker-compose.png)
※ Rails アプリのテストではなく、Rails本体のテストについての話です。

僕がそうだったように、皆さんにもふと「Rails本体のテストを実行してみたいな〜」と思うことがあるでしょう。

ところが、Rails本体のテストというのは大変です。ActiveRecordひとつ取ってみても、網羅するためにはMySQL、PostgreSQL、MariaDB、SQLiteの4つのRDBを用意しなければいけません。

もちろん、公式でそのような環境を構築するためのものは用意されています。

[https://github.com/rails/rails-dev-box](https://github.com/rails/rails-dev-box)

rails-dev-boxを使うと、Vagrantを用いて、Rails本体の開発環境を構築できます。(yahondaさんありがとうございます)

ですが、Dockerが仮想環境の主流となっている今、VagrantでなくDockerを使いたい、そう思うのもおかしくはないでしょう。ないですよね？

なので、docker-compose を使用して、Railsのテストを実行する環境を構築してみました。以下、それに伴って行なったことの解説になります。


## Dockerfile
```dockerfile
FROM ruby:2.5.3-stretch

WORKDIR /rails
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt update && apt install --assume-yes \
    ffmpeg \
    sqlite3 \
    imagemagick \
    mupdf \
    mupdf-tools \
    poppler-utils \
    libmariadbclient-dev \
    libsqlite3-dev \
    postgresql-contrib \
    libpq-dev \
    libxml2 \
    libxml2-dev \
    libxslt1-dev \
    libncurses5-dev \
    mysql-client \
    git \
    make \
    nodejs \
    yarn \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY . .
RUN bundle install --jobs=4
RUN npm install
RUN cd actionview && npm install
```

`FROM` から `WORKDIR` の指定までは飛ばして、aptによるパッケージのインストールを見てみます。
ここで指定しているパッケージ郡ですが、 [https://github.com/rails/rails-dev-box/blob/master/bootstrap.sh](https://github.com/rails/rails-dev-box/blob/master/bootstrap.sh) を参考にしました。



続く `COPY . .` で、 rails/rails のファイルを一気にimageに追加しています。いわゆるDocker image buildのお作法としては、Gemfile、Gemfile.lock 、package.json などのファイルをCOPYして、bundle installなりnpm installなりを行ってからアプリケーションのコードをCOPYしてくるのが一般的です。しかしRailsのしかも開発環境では、Rails gem自体がActiveRecordやActiveModelなどの複数のgemに依存しており、それらがmonorepo構成で rails/rails に含まれているため、このようにしないと bundle installが実行できません。

あとは bundle installとnpm installを実行しているだけです。


## docker-compose.yml
```yaml
version: '3'
services:
  rails:
    build: .
    command: /bin/bash
    environment:
      - MYSQL_HOST=mariadb
      - PGHOST=postgres
      - PGUSER=postgres
      - REDIS_URL=redis://redis:6379
      - MEMCACHE_SERVERS=memcached
    tty: true
    volumes:
      - ".:/rails"
    links:
      - mysql
      # - mariadb
      - postgres
      - redis
      - memcached
      - rabbitmq
  mysql:
    image: mysql:5.7
    environment:
      - MYSQL_ALLOW_EMPTY_PASSWORD=yes
  postgres:
    image: postgres:11.1-alpine
  mariadb:
    image: mariadb:10.4.0-bionic
    environment:
      - MYSQL_ALLOW_EMPTY_PASSWORD=yes
  redis:
    image: redis:5.0.1-alpine
  memcached:
    image: memcached:1.5.12-alpine
  rabbitmq:
    image: rabbitmq:3.7.8-alpine
```

Rails本体のテストを行うにあたり、必要な関連サービスはMySQL PostgreSQL MariaDB Redis Memcached RabbitMQ の6つになります。SQLiteについてはrails service内に含まれています。


## testの実行

`$ docker-compose up -d rails でrails serviceが立ち上がります。そしたら、 

    $ docker-compose exec rails bash

でcontainerに入り、testを実行します。

とはいえ、test suiteはTravis CIで実行されることに最適化されているため、以下のようなpatchを当てる必要がありました。


<script src="https://gist.github.com/unasuke/8ffc91c4ea10daacf2e9d46a710de425.js"></script>

testそのものは、travis.ymlを参考に、このように実行します。


    $ GEM=am,amo,as,av,aj,ast ci/travis.rb

このコマンドでは、ActionMailer、ActiveModel、ActiveSupport、ActionView、ActiveJob、ActiveStorageのtestを実行します。

例えばActiveRecordの、SQLite3でのテストの実行結果は以下のようになりました。

```shell
root:/rails# time GEM=ar:sqlite3 ci/travis.rb

[Travis CI] activerecord with sqlite3
Running command: bundle exec rake sqlite3:test

...snip...

Rails build finished successfully

real    63m17.484s
user    12m22.931s
sys     6m50.865s
root@ebdba3a4da12:/rails#
```


## あきらめたやつ

### multi stage buildによる Node.js ランタイムの構築
tootsuite/mastodon などで採用されているテクニックですが、multi stage buildを用いてNode.js、npm、yarnのバイナリを main imageに追加することにより、パッケージマネージャやバイナリの直接ダウンロードと比較して高速に別言語のランタイムを構築することができます。今回もmsatodonと同様にNode.js、npm、yarn を `COPY --from node` で持ってこようとしたのですが、 ` cannot find module'../lib/utils/unsupported.js'` というエラーが発生し、解決策として出てくるのがNode.jsのサイインストールばかりだったので、aptからインストールすることにしました


## で、これどうするのか

どうすればいいんでしょうね。

## 他の皆さんはどうしているのか
気になったのでTwitterで聞いてみたところ、Travis, VPS, localなどがあるようですね。確かにlocalhostに直にインストールしてしまうのが一番楽だと思いました。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">皆さんRailsのテストってどうやってますかね。あ、RailsアプリのテストではなくRails本体のテストのことです。</p>&mdash; うなすけ (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/status/1065234555089510400?ref_src=twsrc%5Etfw">2018年11月21日</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
<blockquote class="twitter-tweet" data-conversation="none" data-lang="ja"><p lang="ja" dir="ltr">VPS借りてUbuntu 18.04入れて回してます。期待する答えじゃないかもしれませんが、何か困ってますかね。</p>&mdash; Yasuo Honda (@yahonda) <a href="https://twitter.com/yahonda/status/1065248203572830208?ref_src=twsrc%5Etfw">2018年11月21日</a></blockquote>
<blockquote class="twitter-tweet" data-conversation="none" data-lang="ja"><p lang="ja" dir="ltr">homebrewある環境だったらMySQLとPostgreSQL bottleで入れてActiveRecordのtestに必要なdatabaseやuser作るのは1分ぐらいあればできるので僕はローカルにインストールしてますね。</p>&mdash; Ryuta Kamizono (@kamipo) <a href="https://twitter.com/kamipo/status/1065321801834622976?ref_src=twsrc%5Etfw">2018年11月21日</a></blockquote>
<blockquote class="twitter-tweet" data-conversation="none" data-lang="ja"><p lang="ja" dir="ltr">すごい手抜きなやり方だとRailsをforkした自分のリポジトリに対してtravis設定して雑にpushしながらテストするとかですかね？</p>&mdash; sue445 (@sue445) <a href="https://twitter.com/sue445/status/1065255998128975872?ref_src=twsrc%5Etfw">2018年11月21日</a></blockquote>
