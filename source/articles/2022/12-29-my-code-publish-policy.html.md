---

title: "書いたコードを公開するのかしないのかについての僕の考え"
date: 2022-12-29 01:20 JST
tags: 
- diary
- programming
- oss
---

![GitHubのWeb上でライセンスを追加するUI](2022/github-license-adding-ui.png)

## 経緯
[失われた「フリーソフト」の哀愁と、今を生きる開発者への願い。 - Zopfcode](https://www.zopfco.de/entry/2022/12/23/173235) とインターネット上の反応を読んで、自分がコードを公開する場合、しない場合それぞれの理由を現時点で書いておきたいなと思ったので、書きます。

## 公開する理由
### 利用しやすい
例えば便利なライブラリを思いついて実装したとします。そのライブラリを実際に使う場合、実装したコードがある手元のマシンであればそのまま使用することができますが、どこかのクラウドで動かしてるWebアプリで使用したい場合はどうすればいいでしょう？

Repositoryが公開されているのであれば、大抵のパッケージマネージャーではgit repositoryのURLを指定することでインストールができるでしょう。ではそのrepositoryがprivateの場合はどうでしょうか。readを許可したPersonal Access Tokenを発行して適切に設定するなどの手間が発生します。面倒ですね。

### 自分を知ってもらいやすい
GitHubにコードを公開することで、自分がどんな言語をよく書いているのか、どのような技術に触れたことがあるのか、などという情報が伝わりやすくなります。

また、今でこそ立場的に採用に関わることはありませんが、もし採用に関係する立場になったとして、その人が公開しているコードを見ることで得られる情報はとても多いでしょう。これは以下のonkさんの記事に、どのような点を見ているかということが詳しく書かれています。

[書類選考時に見ているポイント - id:onk のはてなブログ](https://onk.hatenablog.jp/entry/2019/11/29/080831)

僕の意見ですが、採用選考の状況においてはGitHubアカウントがない、もしくはあっても公開されているリポジトリがないから減点、ということではなく、あったら参考になる情報が増えるので基本的にプラス、というのがより正しいと思っています。公開しているコードが明らかにどこかから剽窃したものだったり、ハラスメント行為にあたるような内容が含まれていたりしない限りは、GitHubアカウントの有無、公開リポジトリの有無やその数で採用の結果が左右されることはないと考えています。

## 公開しない理由
### ビジネスロジックや公開できないロジックが含まれている
企業が提供しているサービスのコードを原則公開しないように、これは公開するとちょっとマズいことがあるな、というものは公開しません。表現としては「公開できない」のほうが正しいでしょう。僕に経験はありませんが、例えば発見した脆弱性の概念実証コードもこの分類になると思います。

裏を返せば、僕は公開できない明確な理由がない限りはコードを公開するようにしています。

### (今は昔) private repositoryは限りある資源だった
今でこそGitHubの無料プランであってもprivate repositoryは作り放題になっていますが、2020年までは有料プランを契約していないとprivate repositoryを自由に作成することはできませんでした。

[GitHub is free for teams | The GitHub Blog](https://github.blog/2020-04-14-github-is-now-free-for-teams/)

他にもTravis CIやCircleCIではpublic repositoryであれば無料で計算資源を使えたので、コードを公開することは財布にも優しいという時代がありました。今ではGitHub Actionsがありますが、これもprivate repositoryでは使用できる時間に上限がありますね。

## ネットで見かけた公開しない理由に対する個人的見解
### 自分の書いたコードは汚くて恥ずかしいので公開しない
これは気持ちはわかるものの、それは公開しない理由にはならないというのが僕の意見です。

そもそも、自分の書いたコードが綺麗である、と胸を張って言える人というのはいるのでしょうか。そして、たとえ公開されていてとても広く使われているコードであっても、誰が見ても汚いと判断されるようなコードはあるはずです。近年であれば静的解析ツールやLintも充実しているでしょうし、これらは普段のコーディングにおいてもミスを防いでくれるので、導入しない理由はありません。そしてLintを導入している時点で、コードの品質はある程度保たれていると言って差し支えないでしょう。

また、身も蓋も無いことを言ってしまえば、あなたの書くコードも私の書くコードも、そんなに見られることなんてないと思います。そりゃあ前述のように就職活動とかで提出したりすれば見られはしますが、そうでなければよっぽど人気が出たりしない限りは誰にも見られません。ただし、 `AWS_ACCESS_KEY_ID` などのお金になりそう、もしくはイタズラできそうな秘匿情報が書かれていそうな場合はめちゃくちゃ(Botに)見られます[^aws-secret]。 それは気をつけましょう。

[^aws-secret]:  [GitHub に AWS キーペアを上げると抜かれるってほんと？？？試してみよー！ - Qiita](https://qiita.com/saitotak/items/813ac6c2057ac64d5fef)  このような秘匿情報は、そもそも環境変数経由で取得するようにするべきです。

### 保守しないといけなくなる
公開したからといって、保守する義務はありません。例えばMITライセンスの下でコードを公開している場合は、以下のように現状のまま、無保証で提供されることが明記されています。

> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND
>
> <https://spdx.org/licenses/MIT.html>

作者に保守し続ける義務はないので、ほったらかしにしていてもいいのです。僕もめちゃくちゃ放置しています。そして大抵、自分が使うために作ったものを保守しないでいて困るのは自分だったりします。READMEやCIを整備するのは、そうやって放置していて動かなくなったときに自分が直しやすくするためでもあります。Repositoryの体裁を整えるのは結局自分のためなのです。

## 逆にこれはやめてほしいと思うこと
極論、個々人それぞれの考えがあってコードを公開する、しないを決めること、それについては個人の自由だと思います。

ただ、「コードを公開するが、ライセンスを明記しない」これはやめてほしい[^no-license]です。なぜでしょうか。なまじ公開されている分自由に使えそうに見えてしまいますが、ライセンスが不明瞭なため、使用することが一切できないからです。例えばGitHubの場合だと、利用規約上は閲覧することができますが、それ以上のことはできません。これについては以下の記事によくまとまっています。

[^no-license]: もし僕の公開しているrepositoryでライセンスが設定されてないものがあって困っていたら連絡してください

* [ライセンスをつけないとどうなるの？ - Qiita](https://qiita.com/Tatamo/items/ae7bf4878abcf0584291)
* [Ruby 1.9.2リリースとWEBrick脆弱性問題の顛末 - 西尾泰和のはてなダイアリー](https://nishiohirokazu.hatenadiary.org/entry/20100819/1282200581)

基本的に、コードを公開するのであれば、例えば[SPDX](https://spdx.org/licenses/)で "FSF Free/Libre" であるか、"OSI Approved" であるか、もしくはその両方なライセンスを付けていてほしい[^add-license]と思っています。そうでなければ、あなたがどんなに素晴らしいライブラリを作っていようと、そのコードは誰にも利用できないものになってしまいます。OSI Approvedなライセンスで公開されていれば、安心して自分達のアプリケーションでも利用できるかどうか判断することができます。特に業務で使用するのであれば、ライセンスまわりはしっかりチェックする必要があるので、どのようなライセンスの下で公開されているかというのは非常に重要な情報となります。

リポジトリにライセンスを設定することは、GitHubであればWeb上からでも簡単にできます。

[リポジトリへのライセンスの追加 - GitHub Docs](https://docs.github.com/ja/communities/setting-up-your-project-for-healthy-contributions/adding-a-license-to-a-repository)

[^add-license]: 強い言葉を使うなら、「何らかのライセンスを付けるべきである」と考えます。例えそれがNYSLなどのOSI Approvedでない独自ライセンスであったとしても、です。

## まとめ
結局、私がコードを基本的に公開するようにしているのは、自分にとってメリットがあるからそうしているだけだったりします。結果として他者にとっても嬉しいことがあったりしますが、基本的にそういうのはレアケースです。

puhitakuが注力している電子辞書(Linux及びWindows CE)のハックという領域において、過去に作成されたクローズドなソフトウェアがバイナリでしか手に入らないという状況がつらいというのは非常によくわかります。そういう立場から書かれたあの記事は、いわば「利用者」からの視点が多かったのではないでしょうか。なので僕は、ソフトウェアを公開する「作成者」側の立場でちょっと書いてみました。とはいっても「作成者」の立場でも僕よりpuhitakuのほうが広く使われるソフトウェアを公開していそうではありますが、それはそれ。