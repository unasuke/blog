---
title: 'Hyper.shでTwitter botを運用する'
date: 2017-08-14 19:58 JST
tags:
- Programming
- Ruby
- Docker
- Hyper.sh
- twitter
---

![hyper.shのコンソール](2017/hyper-sh-console.png)

## Hyper.shとは
[Hyper.sh - Container-native Cloud](https://hyper.sh/)

Hyper.shは、とても手軽にDocker containerをhostingできるサービスです。課金は秒単位で行なわれ、一番安いプランだと月に$1ちょっとしか費用がかかりません。

これを使って、特定の単語に反応するTwitter Botを運用してみます。

## Twitter Botを作る
### Applicationの作成
[Twitter Application Management](https://apps.twitter.com/)

まずはここからCreate New Appします。`Consumer Key`、`Consumer Secret`、`Access Token`、`Access Token Secret`を入手します。

### Bot本体の作成
今回つくるBotは、特定の文字列からなるDMを受けとったときに返信するというものです。

```ruby
require 'logger'
require 'twitter'
logger = Logger.new(STDOUT)

config = {
  consumer_key:        ENV['CONSUMER_KEY'],
  consumer_secret:     ENV['CONSUMER_SECRET'],
  access_token:        ENV['ACCESS_TOKEN'],
  access_token_secret: ENV['ACCESS_TOKEN_SECRET'],
}

rest_client = Twitter::REST::Client.new(config)
logger.info 'REST client initialized'

streaming_client = Twitter::Streaming::Client.new(config)
logger.info 'Streaming client initialized'

streaming_client.user do |tweet|
  if tweet.is_a?(Twitter::DirectMessage) && %r[\A年収\z].match?(tweet.text)
    logger.info "Recieved DM #{tweet.text} from #{tweet.sender.screen_name}"
    rest_client.create_direct_message(tweet.sender, "#{ENV['ANNUAL_INCOME']}万円")
  end
end
```

このようになりました。

[unasuke/annual-income-bot](https://github.com/unasuke/annual-income-bot)

### Hyper.shにdeployする
さて、まずはこのDocker imageをDocker Hubにpushします。
[unasuke/annual-income - Docker Hub](https://hub.docker.com/r/unasuke/annual-income/)

次に、hyperの中にpullしてきます。hyperをローカルマシンと同様のものだと考えるとわかりやすいかもしれません。

```shell
$ hyper pull unasuke/annual-income:v0.1.1
```

そして、docker-compose.ymlを作成してあるので、次のコマンドでもうBotが動作し始めます。

```shell
# project名にハイフンが使えないと怒られたので直接指定
$ hyper compose up -d -p unasuke_annual_income
```

という訳で、僕に「年収」とだけ書いたDMを送ると僕の年収が返ってきます。

## 超簡単Hyper.sh
どうですか、Hyper.sh。ちなみにプランは自動で決まるのか、僕のBotはS4(月$5.18)で実行されています。

以下にinvitation linkを置いておくので是非活用してください。
<a href="https://console.hyper.sh/register/invite/yApE4Arn3osDm9RPDG3LuLJPj1BwR8fK">https://console.hyper.sh/register/invite/yApE4Arn3osDm9RPDG3LuLJPj1BwR8fK</a>