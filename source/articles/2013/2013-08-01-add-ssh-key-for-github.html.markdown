---
title: GitHubにSSH鍵を追加してそれからどうするつもり？
date: '2013-08-01'
tags:
- git
- howto
- mac
- programming
---

## SSH鍵とは

[共通鍵暗号と公開鍵暗号の解説とSSHでの認証手順](http://www.adminweb.jp/web-service/ssh/index4.html)
[SSHの公開鍵と秘密鍵の関係](http://blog.playispeace.com/145/ssh_publickey_login/)
こういうところを読めば何となく分かるように、つまりは通信を暗号化するための鍵である、と。

## 登録方法

必要な物は

- GitHubのアカウント

まあ言わずもがな。

### 公開鍵の生成

端末で

```shell
$ ssh-keygen
```

と入力すると、保存場所とパスフレーズを聞かれるので、それぞれこのように(パスフレーズは好きに)

```shell
$ ssh-keygen 
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
```

これでSSH鍵ができましたーやったー！

### SSH鍵の設定

SSH鍵の名前をデフォルトから変更したので、".ssh/config"に以下のように記述する。

```
Host github.com
 User git
 Hostname github.com
 PreferredAuthentications publickey
 IdentityFile ~/.ssh/github_id_rsa</pre>
```

あと、権限を変更しておく。

```shell
$ chmod 600 .ssh/github*
```

### SSH鍵の登録

`.ssh/github_id_rsa.pub`の中身をまるごとコピーする。
[GitHub Setting SSH Keys](https://github.com/settings/ssh)からAdd SSH Keyをクリックして
![ssh keyの追加その1](add-ssh-key-github-01.png)
ペーストする
![ssh keyの追加その2](add-ssh-key-github-02.png)

### 接続テスト

端末で、

```shell
$ ssh git@github.com
```


を実行した結果が以下のようになれば成功！

```shell
$ ssh git@github.com
The authenticity of host 'github.com (204.232.175.90)' can't be established.
RSA key fingerprint is 00:11:22:33:44:55:66:77:88:99:aa:bb:cc:dd:ee:ff.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'github.com,204.232.175.90' (RSA) to the list of known hosts.
Identity added: /Users/username/.ssh/github_id_rsa (/Users/username/.ssh/github_id_rsa)
PTY allocation request failed on channel 0
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
Connection to github.com closed.
```

## 参考サイト

[GithubにSSH公開鍵を設定](http://d.hatena.ne.jp/rightgo09/20101212/p1)
[初心者Git日記その五～GitHubにSSH公開鍵登録～](http://design1.chu.jp/setucocms-pjt/?p=580)
[Github に SSH 公開鍵を登録する](http://logrepo.blogspot.jp/2010/08/github-ssh.html)
[GitHub Help Categories/SSH](https://help.github.com/categories/56/articles)

## 追記
2013-12-26 リンク切れの削除と追加
