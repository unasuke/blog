---
title: 年末OS奮闘記
date: '2014-12-31'
tags:
- diary
- linux
---

<a href="http://unasuke.com/wp/wp-content/uploads/2014/12/IMG_5320.jpg"><img src="http://unasuke.com/wp/wp-content/uploads/2014/12/IMG_5320-1024x768.jpg" alt="installdiscs" width="625" height="469" class="alignnone size-large wp-image-866" /></a>

<h2>12月29日</h2>

usbメモリにubuntuを入れ、uefiブートが出来るようになったらいいなと考える。
<a href="https://wiki.ubuntulinux.jp/UbuntuTips/Install/UEFI">UbuntuTips/Install/UEFI</a>を参考にするも、grubが立ち上がらない。
<a href="http://resourcefulbrain.blogspot.jp/2014/07/how-to-uefi-bios-boot-usb-flash-drive.html">How To UEFI and BIOS Bootloader on USB Flash Drive</a>
<a href="https://help.ubuntu.com/community/UEFIBooting">UEFIBooting</a>
これらを参考に奮闘するも、うまくいかない。
USBインストーラのboot領域をコピーするという案を試すも、上手くいかず。</p>

<h2>12月30日</h2>

そうこうしているうちに母艦側のブートローダーを飛ばしてしまったらしく、母艦側OSが起動しない。
母艦側LinuxMintをubuntuに差し替えインストールするも、ブートローダーは起動せず。
FedoraをDVDから起動させようとするも、起動せず。
boot-repairはubuntuのLiveDVDから起動すると起動が途中で止まる。

<h2>12月31日</h2>

boot-repairのCDイメージを焼くも、「uefi環境で使うならUnetbootin使え」と怒られる。
ubuntu LiveDVDからunetbootinでUSBメモリに焼こうとするも、メモリがなんかおかしくてフォーマットが出来ない。
別のUSBメモリで試すも、boot-repair起動後は同じメッセージが出てくる。
unetbootinで焼いたFedora、起動せず。
<a href="http://www.supergrubdisk.org/super-grub2-disk/" target="_blank">Super Grub2 Disk</a>を作成し、HDDにインストールしたubuntuを起動させる。
起動したubuntuで以下のコマンドを実行。

<pre class="theme:github font-size:15 line-height:17 lang:sh decode:true " >$ sudo grub-mkconfig -o /boot/grub/grub.cfg
$ sudo grub-install /dev/sda</pre>

これで母艦側は修復完了。
