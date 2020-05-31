---
title: "Itamae v1.10.8 リリース"
date: 2020-05-31 22:26 JST
tags: 
- ruby
- programming
- itamae
---

![itamae v1.10.8](2020/itamae-v1_10_8.png)

久々に自分がReleaseしたので、なにが入ったのかを軽くまとめます。

## mergeしたもの
### [Print "(in action_XXX)" as a debug log by pocke · #315](https://github.com/itamae-kitchen/itamae/pull/315)
debug logにどのactionによる実行なのかを表示するものです。descriptionに貼ってあるlogを見るとわかりやすいですね。 

### [Reduce `check_package_is_installed` calling when package version is not specified by pocke · #314](https://github.com/itamae-kitchen/itamae/pull/314)
`package` resourceにおいて、そのresourceのversionが指定されていない場合には不要となる処理を実行せずfast returnすることによって処理の高速化を図るものです。具体的には。installするactionにおいては、versionが指定されていない場合にはどのversionが存在するかの確認はしなくていいですし、removeするactionにおいてはinstallされているかどうかのみ確認すればよいだけです。
patch authorによるbenchmarkでは1.3倍高速になったとか。

### [Simplify Git resource's get_revision method by pocke · #313](https://github.com/itamae-kitchen/itamae/pull/313)
git resourceにおいて、`git rev-list` の最初行を取得するのではなく、`git rev-parse` の結果を使用するように変更するものです。無駄な出力をさせなくてよくなり、実行速度も少し向上するようです。

## mergeしなかったもの
### [Fix to set "verify_host_key" based on "strict_host_key_checking" value by musaprg · #312](https://github.com/itamae-kitchen/itamae/pull/312)
SSH時の設定について、 `StrictHostKeyChecking` が `no` に設定されている場合にはその設定値を削除し、代わりに`verify_host_key` を `:never` に設定するものです。
net-ssh gemの v6.0.2 において `ArgumentError: invalid option(s): strict_host_key_checking` が出てしまったことからいただいたpull requestではあるのですが、itamaeが依存しているSpecinfra側で対応がされたため、こちらでは特に対処しないこととしました。

[Remove strict_host_key_checking option when net-ssh does not support it by mizzy · Pull Request #717 · mizzy/specinfra](https://github.com/mizzy/specinfra/pull/717)

## 蛇足
基本的に僕のレスが遅れがちでちょっと申し訳なさがあります。そして6月もリリースする予定です。
