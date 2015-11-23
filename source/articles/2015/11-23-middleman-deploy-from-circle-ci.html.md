---
title: CircleCIでmiddlemanのdeoloyを自動化した
date: 2015-11-23 20:06 JST
tags:
- Programming
- middleman
- cicleci
- howto
---

![Circle ci](2015/blog-ci-deploy.png)
## まずはdeploy方法
さてmiddlemanでbuildした記事は、どこかにdeployしないと公開されません。github pagesでもいいですし、herokuでも、Amazon S3でもいいでしょう。

ただ、僕は[さくらのVPS上でh2oを動かして](/2015/blog-with-middleman-and-vps-server)いるので、それにそったdeployをする必要があります。

## middleman-deploy
どのような方法でdeployするにしても、[middleman-contrib/middleman-deploy](https://github.com/middleman-contrib/middleman-deploy)を使うことになると思います。これは便利です。

rsyncを用いてdeployしようと思い、このような設定を`config.rb`に書きました。

```ruby
activate :deploy do |deploy|
  deploy.method       = :rsync
  deploy.host         = "blog.unasuke.com"
  deploy.path         = "/var/www"
  deploy.user         = ENV["MIDDLEMAN_USER"]
  deploy.port         = ENV["MIDDLEMAN_PORT"]
  deploy.flags        = '-rltgoDvzO --no-p --del'
  deploy.build_before = true
end
```

`deploy.user`と`deploy.port`が環境変数になっているのは、一応このblogのリポジトリは公開になっていて、この設定も誰でも見られるようになっている状態で、sshが繋がるポートを明記するのが危険だからです。

この状態で、

```shell
$ bundle exec middleman deploy
```

を実行すると、buildされ、deployされます。

## 自動化
さて、これをいちいち手でやるのは面倒です。なので、CIサービスを使って自動化してやります。今回はCircleCIを選びました。理由は使い慣れているからです。

とはいっても、masterにmergeされたら自動でdeployくらいの設定なら、こんなにも書かなくてよく、多分、ただ`deployment`の項目だけ書けばいいと思います。

```yaml
machine:
  timezone: Asia/Tokyo

  ruby:
    version: 2.2.3

dependencies:
  pre:
    - gem install bundler -v 1.10.6

  override:
    - bundle install --jobs=4

test:
  override:
    - bundle exec middleman build

deployment:
  publish:
    branch: master
    commands:
      - bundle exec middleman deploy
```

ただ、よくわからないのは、この場合testとして何を実行すればいいのか、ということです。今は`bundle exec middleman build`が成功することをテストのpassと見なしていますが、Circle CIではこの前段階にcompileとして`middleman build`が行われてしまうので、2重に`middleman build`が走ってしまい、時間の無駄です。(さらに、`deploy.build_before = true`なので、計3回の`build`が走り時間の無駄)

## まとめ
- 自動化できた
- compileを無効化したい
