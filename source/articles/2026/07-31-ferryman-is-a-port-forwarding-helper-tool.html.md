---
title: "リモートマシンでListenしているポートをPort forwardingするのを手軽にするツールを作りました"
date: 2026-07-31 20:30 +0900
tags: 
- golang
- windows
---

![ferrymanのスクリーンショット。現在接続しているhost、forwardingしているポート、forward候補のサジェスト、ステータス、forwardの追加フォームが表示されている。](2026/ferryman-screenshot.png)


## Zedを常用するようになって地味に困っていること
もっぱらVS Codeを日々の開発で使用していたのを、最近はZedを使うようにしています。キーバインドやUIの作法が違っていて操作にとまどうのは慣れの問題なのでいいとして、機能そのものが欠けている点についてはどうしようもありません。

現在のZedになく、VS Codeで常用していた機能に、リモートマシンのポートを自動でPort forwardingしてくれるというものがあります。僕の日々の開発は家の中にあるUbuntuマシンに対して、同じく家の中のWindowsマシンからVS Code Remote SSHしたり、外出先のMacBookやiPhoneからTailscale経由で接続してコードを書いたり書かせたりして行っています。VS CodeやZedを動かしているのはWindowsやMacBook上ですが、SSH先のUbuntu上で起動したrails serverやbridgetownでlisternし始めたポートに対してホスト機からアクセスしたくなることが頻繁にあります。そのようなとき、VS Code Remote SSHであれば、VS Code上のterminalで起動したプロセスのlistening portに自動でport forwardingしてくれる便利機能がありますし、そうでなくてもforwardしたいポートを手軽に追加できます。

<https://code.visualstudio.com/docs/remote/ssh#_forwarding-a-port-creating-ssh-tunnel>

対してZedでは、port forwardを指定する機能はあります。ですがこれはZedを再起動する必要がありますし(自分が試したとき確かそうだった)、設定ファイルを編集する必要があります。

<https://zed.dev/docs/remote-development#port-forwarding>

この便利な機能のためにVS CodeをZedの裏で動かしておく、ということをしていたのですが、単機能のものなら作れるんじゃないかということでClaude Codeとお話ししながら作ったのがこのFerrymanというGUIアプリケーションです。

## unasuke/ferryman

<https://github.com/unasuke/ferryman>

実装はGo、GUIにはFyneを使っています。Goを使った理由は開発、配布が簡単なことが主な理由です。名前もClaudeに考えてもらいました[^ferryman]。

[^ferryman]: Go界隈で "ferryman" はユニークではなく、 <https://pkg.go.dev/github.com/rharmse/ferryman> という既存のものがありますし、「ネットワーク」という観点で見れば領域も被ってはいるのですが……どちらも一個人のツールというところで衝突はそんなに問題にならないだろうとは思っています。

開発はWindows上で、Claude Codeと行いました。一応macOSでも動くことは軽く確認していますが、検証という意味ではWindowsでしか行っていません。

設定の保持、forward対象の追加、新規forward対象の提案を行います。ターミナルの出力を監視するのではなく、裏側で新規にlisternしているportを見つけるという挙動になっているため、Railsのsystem specを実行するとSuggestionsが暴れるという挙動があったのですが、提案上限や検出方法を調整して、まあこのくらいなら……という挙動にしています。

7月中はこれを使ってKaigi on Rails 2026のWebページの開発であったり、cfp-appの開発などを行っていました。その過程で個人的には大分満足できる程度の完成度まで上げられたので公開に踏み切りました。

## まとめ
万人に使ってほしいと思っているわけではないですし、似たようなツールも見つけられてないだけで既に存在しそうですが、同じような課題を抱える人が自分以外にも数人くらいはいそうなので公開しました。こういうちょっとしたツールをAIの力で作れるようになったのは良いですね。
