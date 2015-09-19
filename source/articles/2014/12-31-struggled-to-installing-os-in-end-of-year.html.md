---
title: 年末OS奮闘記
date: '2014-12-31'
tags:
- diary
- linux
---

![OSインストールディスクたち](2014/os-install-discs.jpg)

## 12月29日

usbメモリにubuntuを入れ、uefiブートが出来るようになったらいいなと考える。
[UbuntuTips/Install/UEFI - Ubuntu Japanese Wiki](https://wiki.ubuntulinux.jp/UbuntuTips/Install/UEFI)を参考にするも、grubが立ち上がらない。
[窓の外には: How To UEFI and BIOS Bootloader on USB Flash Drive](http://resourcefulbrain.blogspot.jp/2014/07/how-to-uefi-bios-boot-usb-flash-drive.html)
[UEFIBooting - Community Help Wiki](https://help.ubuntu.com/community/UEFIBooting)
これらを参考に奮闘するも、うまくいかない。
USBインストーラのboot領域をコピーするという案を試すも、上手くいかず。

## 12月30日

そうこうしているうちに母艦側のブートローダーを飛ばしてしまったらしく、母艦側OSが起動しない。
母艦側LinuxMintをubuntuに差し替えインストールするも、ブートローダーは起動せず。
FedoraをDVDから起動させようとするも、起動せず。
boot-repairはubuntuのLiveDVDから起動すると起動が途中で止まる。

## 12月31日

boot-repairのCDイメージを焼くも、「uefi環境で使うならUnetbootin使え」と怒られる。
ubuntu LiveDVDからunetbootinでUSBメモリに焼こうとするも、メモリがなんかおかしくてフォーマットが出来ない。
別のUSBメモリで試すも、boot-repair起動後は同じメッセージが出てくる。
unetbootinで焼いたFedora、起動せず。
[Super Grub2 Disk](http://www.supergrubdisk.org/super-grub2-disk/)を作成し、HDDにインストールしたubuntuを起動させる。
起動したubuntuで以下のコマンドを実行。

```shell
$ sudo grub-mkconfig -o /boot/grub/grub.cfg
$ sudo grub-install /dev/sda
```

これで母艦側は修復完了。
