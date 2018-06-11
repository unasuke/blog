---
title: 'The world of mail.gem (maybe) not you know'
date: 2018-06-11 20:16 JST
tags:
- ruby
- programming
---

![I am contributor of the mail.gem](2018/mail-gem-contributor.png)

RubyKaigi 2018のLTにCFPを提出しましたが、残念ながらnot acceptedとなってしまいました。

なので、その内容を先日開催された表参道.rbで発表してきたのですが、LTにする過程で端折った様々を補完するために記事にまとめました。

発表資料自体はここにあります。

[https://github.com/unasuke/omotesandorb-35](https://github.com/unasuke/omotesandorb-35)

## mail.gemとは
mail.gemはRubyでemailを扱うためのgemであり、actionmailerの依存関係にも含まれるように、世界中で使用されているgemです。

[mail | RubyGems.org | your community gem host](https://rubygems.org/gems/mail/versions/2.6.4)

## RailsのCI

[rails/rails](https://github.com/rails/rails)のCIでは、以下に示すように警告が有効になっています。

[https://github.com/rails/rails/blob/fcfe29cd2641b2ce3c01bc13f39d617ec302fc8d/actionmailer/Rakefile#L11-L17](https://github.com/rails/rails/blob/fcfe29cd2641b2ce3c01bc13f39d617ec302fc8d/actionmailer/Rakefile#L11-L17)

```ruby
# Run the unit tests
Rake::TestTask.new { |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.warning = true
  t.verbose = true
  t.ruby_opts = ["--dev"] if defined?(JRUBY_VERSION)
}
```

さて、ruby-head、つまりRuby 2.6以降では、以下のようなcase-whenに対して警告が出るようになっていました。(余談を参照)

```ruby
case cond
  when 1
    do_something
  when 2
    do_something_another
end
```

そして、Railsはruby-headでもCIを実行しています。そのなかで依存しているgemのコードに、whenが1段深いインデントをしているものが含まれていたので、CIで大量のwarning messageが出るようになってしまいました。

[https://travis-ci.org/rails/rails/jobs/365773392](https://travis-ci.org/rails/rails/jobs/365773392)

依存しているgemのうち、簡単に直せるものについては次のようなpull reqによって修正されています。

[Address \`warning: mismatched indentations at 'when' with 'case'\` by yahonda · Pull Request #74 · rails/rails-dom-testing](https://github.com/rails/rails-dom-testing/pull/74)


しかしmail.gemについては、そのgem単体で発生しているwarningが多く、修正の手間が大きいのではないかという懸念がありました。

そのようなことを [@koic](https://github.com/koic)さんや[@yahonda](https://github.com/yahonda)さんが [#asakusarb](https://asakusarb.esa.io/) にて話されており、偶然その近くにいた僕が興味を持ってやってみようということになりました。

## よくわからない、自動生成されたコード
まずは、警告が出ているコードを見てみます。中には確かにインデントの揃っていないcase-whenがありましたが、それよりも僕は次のコードに疑問を抱きました。

[https://github.com/mikel/mail/blob/fbc5d91ae9b68b3c4ad450a22055a74dfce1caf9/lib/mail/parsers/address_lists_parser.rb#L33166-L33173](https://github.com/mikel/mail/blob/fbc5d91ae9b68b3c4ad450a22055a74dfce1caf9/lib/mail/parsers/addresslistsparser.rb#L33166-L33173)

```ruby
	when 36 then
		begin
 local_dot_atom_pre_comment_e = p-1 		end
		begin
 local_dot_atom_e = p-1 		end
		begin
 address.local = '"' + qstr + '"' if address 		end
		begin
```

Ruby では、次のような後置ifがある場合に、その条件が偽であれば前置されている式は実行されないという文法があります。


```ruby
puts 'message' if false  # この場合 'message' は出力されない
```

このときにifにendが続いてblockになっている場合、後置ifのような動きをするのか、それとも前置の式が評価されてからif blockの中に入るのか僕は即座にはわかりませんでした。

そこでその場にいらしていた [@amatsuda](https://github.com/amatsuda) さんに伺ってみたところ、そもそもそのコードは何らかのツールにより生成されたもののように見える、というアドバイスを頂きました。

自動生成されたコードであるならば、その成果物に対してあれこれ修正するのは再度生成した場合に全て上書きされるので、無意味となります。生成元に対して何らかの対処をしなければなりません。

## Ragel
それでは、mail.gemのRubyコードは一体何によって生成されているのでしょうか。

コードの生成といえば、何らかのスクリプト、あるいはタスクランナーによって生成されることが多いでしょう。例えば一般的にはMakeがその役目を担うでしょうし、RubyのプロジェクトであればRakeも使われます。

というわけでRakefileの中を見てみると、どうやら `ragel` というコマンドを呼び出して、 `.rl` から `.rb` を生成しているようです。
https://github.com/mikel/mail/blob/fbc5d91ae9b68b3c4ad450a22055a74dfce1caf9/tasks/ragel.rake#L12-L21


```ruby
  # Ruby parsers depend on Ragel parser definitions
  # (remove -L to include line numbers for debugging)
  rule %r|_parser\.rb\z| => '.rl' do |t|
    sh "ragel -s -R -L -F1 -o #{t.name} #{t.source}"
  end
  
  # Dot files for Ragel parsers
  rule %r|_parser\.dot\z| => '.rl' do |t|
    sh "ragel -s -V -o #{t.name} #{t.source}"
  end
```

ragelというキーワードでGoogle検索してみると、次のようなるびまの記事が見付かりました。

[Ragel 入門： 簡単な使い方から JSON パーサまで](https://magazine.rubyist.net/articles/0023/0023-Ragel.html)

記事によると、Ragelはステートマシンコンパイラのようです。emailのデータをパースするのに使われていそうだ、というところまでわかりました。公式サイトは以下です。

[http://www.colm.net/open-source/ragel/](http://www.colm.net/open-source/ragel/)

ひとまずRagelをcloneして、内部を眺めてみることにします。

## Ragelをどうにかする
公式にもあるとおり、以下のようにしてRagelをcloneしました。

```shell
$ git clone git://colm.net/ragel.git
```

さてここからどうすればいいのかがわかりませんでした。READMEはありますが非常に簡素なもので、コンパイル方法がわかりません。僕は普段はRubyで開発しているので、C言語で記述されているプロダクトのビルドの作法に疎いのです。

しかしREADMEには `Colm is a mandatory dependency.` という記述があり、とりあえずそれが必要であることはわかりました。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">なんもわからん<a href="https://t.co/8o5oaN7zfZ">https://t.co/8o5oaN7zfZ</a></p>&mdash; うなすけ (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/status/984404239089717249?ref_src=twsrc%5Etfw">2018年4月12日</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## Colm
先程RagelをcloneしたURLにも含まれるように、Colmが同じドメイン下で公開されていました。

[http://www.colm.net/open-source/colm/](http://www.colm.net/open-source/colm/)

公式サイトの記述に

> Colm is a programming language designed for the analysis and transformation of computer languages.

とあるように、これはプログラミング言語のひとつのようです。

mail.gemを直すのに、新しくプログラミング言語を習得し、初めて使うツールの学習もしなけれならないとなると相当時間がかかる上に難易度も高いので、別の方法が無いか考えることにしました。

## 要はgofmtがあればよい
自動生成されたコードのスタイルがめちゃめちゃであれば、それを自動整形してくれる、gofmtのようなものがあれば解決します。

そのようなRubyの自動整形ツールとしては、有名なものであればRuboCopが挙げられるでしょう。RuboCopは `-a` をオプションとして渡すことで、対応しているCopについては自動で整形してくれます。

しかしRuboCopはあくまでも静的解析ツールであり、自動整形ツールではありません。自動整形の機能についても、誤動作が無いというわけではありません。

## ruby-formatter/rufo
用途に合致するものがないか調べていたところ、以下のgemが見付かりました。

[https://github.com/ruby-formatter/rufo](https://github.com/ruby-formatter/rufo)

rufoはRipperという、Rubyに同梱されているRubyの構文解析器を使用してコードの整形を行ないます。なのでその整形結果に関してはある程度の信頼性があると判断してよいと考え、これを使って整形することにしました。

## 動かないRakefile
rufoによる自動整形を、Ragelによるコード生成の後に実行すればよいので、そのようにRakefileを書き変えると、エラーによりコード生成ができませんでした。そこでrufoを呼び出している部分を消し、変更が無い状態でもういちどrakeを実行してみましたが、同様にエラーで生成ができません。

ある時点からRakeの挙動が変わってしまい、既存のRakefileのままではコード生成ができなくなってしまっているようです。Ragelによるコード生成はそこまで頻繁に実行されるものではない(前回は2017年11月)ので、mail.gemのメンテナはこの問題に直面してないようです。

mail.gemのgemspecに記述されているrakeと、その時点でローカルで使用されているrakeの間に入ったコードのどこから挙動が変わったのかを調べる必要があります。そのきっかけとなるcommitを見付けられれば、対処法もわかるはずです。

調査したところ、v12.0.0 では成功し、 v12.1.0 では失敗することがわかりました。

[https://github.com/ruby/rake/compare/v12.0.0...v12.1.0](https://github.com/ruby/rake/compare/v12.0.0...v12.1.0)

さらに調査を進め、次のpull reqがmergeされたことにより、挙動が変わってしまったことが判明しました。

[Chained extensions by pjump · Pull Request #39 · ruby/rake](https://github.com/ruby/rake/pull/39)


これによって対象となるrlのファイル名の解決に失敗するようになったので、以下のpathmapのドキュメントを参考にして、次のpull reqを作成しました。

- [instance method String#pathmap (Ruby 2.5.0) docs.ruby-lang.org](https://docs.ruby-lang.org/ja/latest/method/String/i/pathmap.html)

[Set full path of the ragel source file to rake task by unasuke · Pull Request #1221 · mikel/mail](https://github.com/mikel/mail/pull/1221)

また、結果としてrake taskが正常に実行できるようになったので、前述のpull reqに依存する形で以下のpull reqを作成しました。

[Reduce warnings "mismatched indentations" on ruby 2.6 by unasuke · Pull Request #1222 · mikel/mail](https://github.com/mikel/mail/pull/1222)

## merge
なんとありがたいことに、それほど時間を置かずどちらのpull reqもmergeしてもらうことができました。よかったですね。

- [Set full path of the ragel source file to rake task by unasuke · Pull Request #1221 · mikel/mail](https://github.com/mikel/mail/pull/1221)
- [Reduce warnings "mismatched indentations" on ruby 2.6 by unasuke · Pull Request #1222 · mikel/mail](https://github.com/mikel/mail/pull/1222)

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">やった！！！！！！ <a href="https://twitter.com/hashtag/asakusarb?src=hash&amp;ref_src=twsrc%5Etfw">#asakusarb</a><a href="https://t.co/5tHqN7VWuS">https://t.co/5tHqN7VWuS</a></p>&mdash; うなすけ (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/status/984692590929784834?ref_src=twsrc%5Etfw">2018年4月13日</a></blockquote>

## 余談
case-whenでインデントが以下のようになっていないと警告が出る件についてですが、おそらく以下のcommitで有効になったようです。

- [\[ruby\] Revision 62836 svm.ruby-lang.org](https://svn.ruby-lang.org/cgi-bin/viewvc.cgi?revision=62836&view=revision)
- [parse.y: mismatched indentations at middle · ruby/ruby@d34bc77](https://github.com/ruby/ruby/commit/d34bc779a7f8fc9d8820a8cdeb4a3b5e75958be2)

ところがそれに対し、次のような報告が上げられています。

[Bug #14674: New mismatched indentations warnings? - Ruby trunk - Ruby Issue Tracking System](https://bugs.ruby-lang.org/issues/14674)

> I strongly believe that it is not Ruby's parser job to warn us about styling, especially if there's no strong reason to suspect that it's a programmer error.

case-whenで1段深くインデントするのはよくあることだし、そのようなstyleのcheckはRubyのperserのやることではない、という反対意見ですね。

その報告によって次のようなcommitが為されており、結局のところcase-whenではwhenが1段深くインデントされていても警告は出ないようになっています。

- [\[ruby\] Revision 63165 svn.ruby-lang.org](https://svn.ruby-lang.org/cgi-bin/viewvc.cgi?revision=63165&view=revision)
- [parse.y: \`else\` indent · ruby/ruby@3b93a8b](https://github.com/ruby/ruby/commit/3b93a8bcad1048a46befe1dbaae38c0e74a11be0)

```shell
$ ruby -v
ruby 2.6.0dev (2018-06-10 trunk 63625) [x86_64-linux]

$ cat test.rb
case true
  when true
    p 'true'
  when false
    p 'false'
end

$ ruby -w test.rb
"true"
```

よかったですね。

