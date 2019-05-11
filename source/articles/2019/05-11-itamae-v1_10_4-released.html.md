---
title: "Itamae v1.10.4 をリリースしました"
date: 2019-05-11 22:55 JST
tags: 
- ruby
- programming
- itamae
---

![](https://repository-images.githubusercontent.com/15393024/7f9b8f00-6834-11e9-9544-1fd0e8427412)

v1.10.3からのdiffはこちらです。

<https://github.com/itamae-kitchen/itamae/compare/v1.10.3...v1.10.4>

## Changelogs
### Suppress Ruby warnings
- [Suppress Ruby warnings by pocke · Pull Request #284 · itamae-kitchen/itamae](https://github.com/itamae-kitchen/itamae/pull/284)
- [Suppress Ruby warning by pocke · Pull Request #287 · itamae-kitchen/itamae](https://github.com/itamae-kitchen/itamae/pull/287)

`RUBYOPT=-w` を指定したときに出る警告を修正するもの。

### [Run test cases correctly by pocke · Pull Request #289 · itamae-kitchen/itamae](https://github.com/itamae-kitchen/itamae/pull/289)
これは v1.10.3 にmergeされている [Add integration test with `itamae local` command](https://github.com/itamae-kitchen/itamae/pull/281) で、test filesを列挙する正規表現が誤っていた問題を修正するもの。 これで `0  examples` → `139 examples` になりました。よかったですね。

このあたりはpull req authorのpockeさんがブログに書いてくれていますね。メンテナとして気付けなかった僕達のミスでもあります。ありがとうございます。

[Itamaeのテストを壊してしまっていた話 - pockestrap](https://pocke.hatenablog.com/entry/2019/05/10/232013)

### [Refine `itamae docker`'s created message by pocke · Pull Request #288 · itamae-kitchen/itamae](https://github.com/itamae-kitchen/itamae/pull/288)

`itamae docker` コマンドに `--tag` オプションを指定した場合、成功したときのmessageにtagも表示するようにしたもの。

### [Add description to --tag option of docker subcommand by pocke · Pull Request #286 · itamae-kitchen/itamae](https://github.com/itamae-kitchen/itamae/pull/286)

`itamae docker` コマンドのhelp messageに `--tag` オプションの説明を足したもの。

