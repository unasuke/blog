---
title: Gitのコミットメッセージの2行目に何か書くとどうなるのか？
date: '2015-03-10'
tags:
- bitbucket
- git
- github
- info
- programming
---

<h2>Gitのコミットメッセージの書き方</h2>
<p>
Gitのコミットメッセージの書き方は、多くのwebサイトや書籍では2行目を空行とする、と説明している。
</p>
<figure>
<blockquote cite="https://www.atlassian.com/ja/git/tutorial/git-basics#!commit">
<p>Git ではコミットメッセージの形式に関して制約はありませんが、1 行目にコミットの全体的説明を 50 字以内で記述し、2行目は空白行とし、3行目以降に変更内容の詳細を記述するのが標準的な形式です。</p>
</blockquote>
<figcaption>
<cite><a href="https://www.atlassian.com/ja/git/tutorial/git-basics#!commit">Atlassian Gitチュートリアル The git commit Command</a></cite>より
</figcaption>
</figure>
<p>
GitHubのOS X用クライアントでは、そもそもコミットメッセージの2行目に何かを書くことはできない。では、書くとどうなるのか。
</p>

<h2>実践</h2>
<p>
リポジトリを新規に作成し、README.mdを作成した。そしてコミットメッセージを以下のように記述して、コミット。
<a href="http://unasuke.com/wp/wp-content/uploads/2015/03/secondlinecommitmessage.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/03/secondlinecommitmessage.png" alt="2行目に記述があるコミットメッセージ" width="650" height="426" class="alignnone size-full wp-image-1018" /></a>
プラグインか何かの働きかと思うが、2行目が注意色になっていて、あからさまな警告を感じるが、何もエラーメッセージを吐くことなくコミットできた。
</p>
<p>
そしてコミットログを表示したのがこれ。しっかり2行目も表示されている。(メルアドは隠した)
<a href="http://unasuke.com/wp/wp-content/uploads/2015/03/firstcommit.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/03/firstcommit.png" alt="2行目のメッセージも表示されている" width="650" height="426" class="alignnone size-full wp-image-1020" /></a>
</p>
<p>
その後、2行目を記述しないコミットを同様に行ったが、問題なく出来た。
<a href="http://unasuke.com/wp/wp-content/uploads/2015/03/secondcommit.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/03/secondcommit.png" alt="普通のコミットメッセージ" width="650" height="426" class="alignnone size-full wp-image-1022" /></a>
コミットログも。
<a href="http://unasuke.com/wp/wp-content/uploads/2015/03/after2commits.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/03/after2commits.png" alt="2つのコミットのlog" width="650" height="426" class="alignnone size-full wp-image-1023" /></a>
</p>
<p>
GitHubではどのように見えるのか確認したところ、webではこのように表示されている。
<a href="http://unasuke.com/wp/wp-content/uploads/2015/03/Screen-Shot-2015-03-10-at-20.33.56.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/03/Screen-Shot-2015-03-10-at-20.33.56.png" alt="githubでの2行目の表示" width="924" height="306" class="alignnone size-full wp-image-1025" /></a>
普通のコミットメッセージはこのように。
<a href="http://unasuke.com/wp/wp-content/uploads/2015/03/Screen-Shot-2015-03-10-at-20.34.19.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/03/Screen-Shot-2015-03-10-at-20.34.19.png" alt="普通のコミットメッセージの表示" width="923" height="283" class="alignnone size-full wp-image-1026" /></a>
</p>
<p>
GitHub for Macでは、すこし小さく表示されているように見える。
<a href="http://unasuke.com/wp/wp-content/uploads/2015/03/Screen-Shot-2015-03-10-at-20.35.07.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/03/Screen-Shot-2015-03-10-at-20.35.07.png" alt="GitHub for Macでの2行目" width="903" height="294" class="alignnone size-full wp-image-1028" /></a>
普通のコミットメッセージは、こう。
<a href="http://unasuke.com/wp/wp-content/uploads/2015/03/Screen-Shot-2015-03-10-at-20.35.17.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/03/Screen-Shot-2015-03-10-at-20.35.17.png" alt="普通のコミットメッセージのGitHub for Mac" width="882" height="280" class="alignnone size-full wp-image-1029" /></a>
</p>
<p>
bitbucketでも、このように特に問題なく表示された。
<a href="http://unasuke.com/wp/wp-content/uploads/2015/03/Screen-Shot-2015-03-10-at-20.39.47.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/03/Screen-Shot-2015-03-10-at-20.39.47.png" alt="bitbucketの2行目" width="689" height="468" class="alignnone size-full wp-image-1031" /></a>
</p>
<p>
このように、コミットメッセージの2行目になにか書いても特に問題はないように見受けられる……が、git logをするとおかしなことになる。
</p>
<h2>git logの表示が</h2>
<p>
git logでoneline表示をすると、このように表示される。
<a href="http://unasuke.com/wp/wp-content/uploads/2015/03/onelinecommitlog.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/03/onelinecommitlog.png" alt="複数行が表示される" width="650" height="426" class="alignnone size-full wp-image-1033" /></a>
2行目を記述したコミットメッセージの1行目、2行目、3行目がひとつの行に表示されている。
</p>
<p>
そこで、このように3行目が長い(2行目はそれほどでもない)コミットメッセージを記入し、onelineで表示させるとどうなるだろうか。
<a href="http://unasuke.com/wp/wp-content/uploads/2015/03/longcommitmessage.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/03/longcommitmessage.png" alt="3行目が長いコミットメッセージ" width="650" height="426" class="alignnone size-full wp-image-1035" /></a>
</p>
<p>
結果、こうなった。どうやらgit log --onelineは、コミットメッセージの初めの空行までを読み取って1行に出力する動作をするようだ。(空行をはさんだ後の文章は表示されていない)ソースコードを読んでないので推測だが。
<a href="http://unasuke.com/wp/wp-content/uploads/2015/03/longmessageoneline.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/03/longmessageoneline.png" alt="長いコミットメッセージのgit log" width="650" height="426" class="alignnone size-full wp-image-1036" /></a>
</p>

<h2>まとめ</h2>
<p>
gitのコミットメッセージの2行目に何かを書いたとして、それが何らかの不具合を引き起こすことはないと思われるが、例えば今回実験しなかったgit format-patchやgit amではどのようになるかわからない。そもそも歴史的慣習を打ち破ってまで2行目に何か書きたい需要があるとも思えない。
</p>
<p>
<strong>コミットメッセージの2行目は空けよう！</strong>
</p>
