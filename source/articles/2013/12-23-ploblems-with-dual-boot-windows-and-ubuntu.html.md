---
title: ubuntu13.10とWindows8(8.1)のデュアルブートで悩まされたいくつかの問題
date: '2013-12-23'
tags:
- howto
- linux
- ubuntu
- windows
---

この記事はうなすけAdvent Calendarの23日目の記事です。
冬休みということもあり、早速OSのインストールを始めたわけですが、いくつかの問題にぶち当たりググってる間にもうクリスマスになってしまいました。
ここでは、Windows8をUEFIでインストール→ubuntu13.10を別パーティションにインストール→Windows8.1にアップデートの手順の中で発生した問題について自分なりの解決方法を書き留めておく記事なので間違ってたりしても責めないでほしい。僕はこれで満足している。いや問題が発生する時点で満足なんてしていないけども。

## UEFI環境でのデュアルブート

Windows8のインストールは特に問題もなく終了。さあubuntuのインストールに移る。
参考にしたこれら
[デュアルブート（UEFI Win8 + Ubuntu13.04） その4 - Ubuntuをインストールする・UbuntuをUEFIから起動する](http://kledgeb.blogspot.jp/2013/10/uefi-win8-ubuntu1304-4-ubuntuubuntuuefi.html)
~~ [Ubuntu13.04]Windows7とのデュアルブート(リンク切れ) ~~
の記事には、
「ブートローダはefiパーティションにインストールしろ」
「ブートローダはrootパーティションにしろ」
と書いてあることが違う。実際に試してみたが、どちらにブートローダをインストールしてもWindowsしか立ち上がらなかった(grubは起動しなかった)。

結局、 __ブートローダ(grub)はハードディスクを指定してインストール__ した。(例えば/dev/sdaとか。)

## Windows8.1にアップデートするとgrubが行方不明

Windows8からはWindows8.1へ無料でアップデート(アップグレード？)できるのだが、アップデートしたらgrubをすっ飛ばしWindowsしか起動しなくなった。これはいかん。
過去に[帰ってきたGRUB](http://d.hatena.ne.jp/yu_suke1994/20121115/1352987791)として同じような問題の解決法を書いたが、今はもっといいものがある。
それが[Boot-Repair](https://help.ubuntu.com/community/Boot-Repair)である。
LiveDVDなどからubuntuを起動し、端末で以下のコマンドを実行、Boot-Repairをインストールする。

```shell
$ sudo apt-add-repository ppa:yannubuntu/boot-repair
$ sudo apt-get update
$ sudo apt-get install boot-repair
```

※$←は一般ユーザ権限で実行(それにsudoがついて管理者権限)なので入力しなくていい
あとはBoot-Repairを起動しRecommended repairでなんとかなった。
参考URL
[Boot-Repair](https://help.ubuntu.com/community/Boot-Repair)
[Ubuntu Boot Repair その1 - OSの起動に関する問題を修復するアプリの紹介・インストールと起動](http://kledgeb.blogspot.jp/2013/11/ubuntu-boot-repair-1-os.html)

## WindowsのNTFSパーティションがマウントできない

Windows領域にアクセスしようとすると、以下のようなメッセージが出てマウントできない。

> Error mounting system-managed device /dev/sda4: Command-line `mount "/media/unasuke/windows"' exited with non-zero exit status 14: Windows is hibernated, refused to mount.
> Failed to mount '/dev/sda4': Operation not permitted
> The NTFS partition is in an unsafe state. Please resume and shutdown
> Windows fully (no hibernation or fast restarting), or mount the volume
> read-only with the 'ro' mount option.

![引用したエラー文とちょっと違うのは、問題解決後にエラーを意図的に発生させたから。](dual-boot-plobrems-01.png)
要するに、ハイバーネートとか高速起動するなと言っている。
そこで、まずWindowsでコントロールパネル→ハードウェアとサウンド→電源ボタンの動作の変更を開き、「高速スタートアップを有効にする(推奨)」のチェックを外す。
![チェックを外す](dual-boot-plobrems-02.png)
その後、ubuntuから以下のコマンドでマウントできる。

`sudo mount -t ntfs-3g -o remove_hiberfile /dev/sda4 /media/unasuke/windows`

/dev/sda4 とか/media/unasuke/windowsとかは適宜変更する。
ただ、ntfs-3gのmanページにあるremove_hiberfileオプションについて見ると……

> remove_hiberfile
>       Unlike  in  case  of  read-only  mount,  the read-write mount is
>       denied if the NTFS volume is hibernated.  One  needs  either  to
>       resume  Windows  and  shutdown  it  properly, or use this option
>       which will remove the Windows  hibernation  file.  Please  note,
>       this  means  that  the  saved Windows session will be completely
>       lost. Use this option under your own responsibility.

とあるように自己責任で。
ただ、このコマンドは一時的なもので、再起動するたびにこんなことになる。
![こんなこと](dual-boot-plobrems-03.png)
ので、
` $ sudo vim /etc/fstab`
なりなんなりでfstabにremove_hiberfileオプションを付加しなければならない。

```
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>

#Entry for /dev/sda4 :
UUID=AAAAAAAAAAAAA  /media/unasuke/windows  ntfs-3g defaults,remove_hiberfile,locale=ja_JP.UTF-8    0   0

#UUID=307B-FA73    /boot/efi   vfat    defaults    0   1
```

例えばこんなふうに。UUIDはblkidコマンドなどで調べられる。書き込めたら再起動で確認してみよう。起動しなかったらOS再インストールしよう。

### 参考URL
[How do I mount a hibernated NTFS partition?](http://askubuntu.com/questions/204166/how-do-i-mount-a-hibernated-ntfs-partition)
[・NTFS パーティションを起動時に mount する](http://furyo.on-air.ne.jp/linux/ntfs.html)

これで問題は解決した。メリークリスマス。
