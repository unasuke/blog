---
title: GitHubにSSH鍵を追加してそれからどうするつもり？
date: '2013-08-01'
tags:
- git
- howto
- mac
- programming
---

A君にごめんなさいしながら書く記事。

<h2>SSH鍵とは</h2>

<a href="http://www.adminweb.jp/web-service/ssh/index4.html" target="_blank">共通鍵暗号と公開鍵暗号の解説とSSHでの認証手順</a>
<a href="http://blog.playispeace.com/145/ssh_publickey_login/" target="_blank">SSHの公開鍵と秘密鍵の関係</a>
こういうところを読めば何となく分かるように、つまりは通信を暗号化するための鍵である、と。

<h2>登録方法</h2>

必要な物は

<ul>
<li>GitHubのアカウント</li>
</ul>

まあ言わずもがな。

<h3>公開鍵の生成</h3>

端末で

<pre class="lang:sh highlight:0 decode:true " >$ ssh-keygen</pre>

と入力すると、保存場所とパスフレーズを聞かれるので、それぞれこのように(パスフレーズは好きに)

<pre class="lang:sh highlight:0 decode:true " >$ ssh-keygen 
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/username/.ssh/id_rsa): github_id_rsa
Created directory '/Users/username/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /Users/username/.ssh/github_id_rsa.
Your public key has been saved in /Users/username/.ssh/github_id_rsa.pub.
The key fingerprint is:
00:11:22:33:44:55:66:77:88:99:aa:bb:cc:dd:ee:ff username@username-mac.local
The key's randomart image is:
+--[ RSA 2048]----+
|                 |
|                 |
|                 |
|                 |
|                 |
|                 |
|                 |
|                 |
|                 |
+-----------------+
</pre>

これでSSH鍵ができましたーやったー！

<h3>SSH鍵の設定</h3>

SSH鍵の名前をデフォルトから変更したので、".ssh/config"に以下のように記述する。

<pre class="lang:default decode:true " title=".ssh/config" >Host github.com
 User git
 Hostname github.com
 PreferredAuthentications publickey
 IdentityFile ~/.ssh/github_id_rsa</pre>

あと、権限を変更しておく。

<pre class="lang:sh highlight:0 decode:true " >$ chmod 600 .ssh/github*</pre>

<h3>SSH鍵の登録</h3>

".ssh/github_id_rsa.pub"の中身をまるごとコピーする。
<a href="https://github.com/settings/ssh">GitHub Setting SSH Keys</a>からAdd SSH Keyをクリックして
<a href="http://unasuke.com/wp/wp-content/uploads/2013/08/b6b797a2e9eb5027331d212ab5bf46d8.jpeg"><img src="http://unasuke.com/wp/wp-content/uploads/2013/08/b6b797a2e9eb5027331d212ab5bf46d8-300x157.jpeg" alt="スクリーンシ1_3.46.04" width="300" height="157" class="alignnone size-medium wp-image-192" /></a>
ペーストする
<a href="http://unasuke.com/wp/wp-content/uploads/2013/08/16664dfd0f65a2bf6bf73f48b99cdf98.jpeg"><img src="http://unasuke.com/wp/wp-content/uploads/2013/08/16664dfd0f65a2bf6bf73f48b99cdf98-300x181.jpeg" alt="スクリーンショット_2013-08-01_3.46.55" width="300" height="181" class="alignnone size-medium wp-image-193" /></a>

<h3>接続テスト</h3>

端末で、

<pre class="lang:sh highlight:0 decode:true " >$ ssh git@github.com</pre>

を実行した結果が以下のようになれば成功！

<pre class="lang:sh highlight:0 decode:true " >$ ssh git@github.com
The authenticity of host 'github.com (204.232.175.90)' can't be established.
RSA key fingerprint is 00:11:22:33:44:55:66:77:88:99:aa:bb:cc:dd:ee:ff.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'github.com,204.232.175.90' (RSA) to the list of known hosts.
Identity added: /Users/username/.ssh/github_id_rsa (/Users/username/.ssh/github_id_rsa)
PTY allocation request failed on channel 0
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
Connection to github.com closed.</pre>

<h2>参考サイト</h2>

<a href="http://d.hatena.ne.jp/rightgo09/20101212/p1" target="_blank">[SSH]GithubにSSH公開鍵を設定</a>
<a href="http://design1.chu.jp/setucocms-pjt/?p=580" target="_blank">初心者Git日記その五～GitHubにSSH公開鍵登録～</a>
<a href="http://logrepo.blogspot.jp/2010/08/github-ssh.html" target="_blank">Github に SSH 公開鍵を登録する</a>
<a href="https://help.github.com/categories/56/articles" target="_blank">GitHub Help Categories/SSH</a>

Have a nice GitHub life.

2013-12-26 リンク切れの削除と追加
