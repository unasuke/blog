---
title: "OCI Runtime Spec v1.0.2 is coming soon"
date: 2020-03-27 03:17 JST
tags: 
- docker
- oci
- container
---

![](2020/oci-runtime-spec.png)

以前、udzuraさんがOCI Runtime Specを簡単にまとめた以下のようなブログを書かれていました。

[OCI Runtime Specification を読む - ローファイ日記](https://udzura.hatenablog.jp/entry/2016/08/02/155913)

この記事にてまとめられているのは [95a6ecf](https://github.com/opencontainers/runtime-spec/commit/95a6ecffd04732bdf7db0518fdfd59bcabdad442) であり、このrevisionから一番近いreleaseはpre-releaseである [v1.0.0-rc2](https://github.com/opencontainers/runtime-spec/releases/tag/v1.0.0-rc2) です。

さて、 [v1.0.2 のリリースがそろそろ](https://github.com/opencontainers/runtime-spec/pull/1037)ということもあり、ここでは簡単のため、v1.0.0-rc2からv1.0.2までの間に入った変更について見てみようと思います。ただし全部は取り上げません。

## v1.0.0-rc3
<https://github.com/opencontainers/runtime-spec/releases/tag/v1.0.0-rc3>

rcの間は駆け足で行きます。
Windowsについての記述が追加されています。 [#565](https://github.com/opencontainers/runtime-spec/pull/565), [#573](https://github.com/opencontainers/runtime-spec/pull/573)
それに関してか？consoleのサイズについての情報を格納するfiledが [#563](https://github.com/opencontainers/runtime-spec/pull/563) で追加されています。これらはMicrosoftの人によるcommitですね。

## v1.0.0-rc4
<https://github.com/opencontainers/runtime-spec/releases/tag/v1.0.0-rc4>

いくつかのresouceに負の値を指定できるようになっています。でもmemory usage limitとかに負を指定できて嬉しいんだろうか？ [#648](https://github.com/opencontainers/runtime-spec/pull/648)

## v1.0.0-rc5
<https://github.com/opencontainers/runtime-spec/releases/tag/v1.0.0-rc5>

platformについての記述がREQUIEDに指定されています。 [#695](https://github.com/opencontainers/runtime-spec/pull/695/files)
それに関連してWindowsやSolarisについての記述が追加されたり修正されたり。 [#673](https://github.com/opencontainers/runtime-spec/pull/673)

あ、rc4 で負の値を指定できるようになったいくつかのfieldで、またunsignedに戻されていますね。[#704](https://github.com/opencontainers/runtime-spec/pull/704)

libseccompのバージョンが v2.3.0からv2.3.2に上がっています。 [#705](https://github.com/opencontainers/runtime-spec/pull/705)

## v1.0.0-rc6
<https://github.com/opencontainers/runtime-spec/releases/tag/v1.0.0-rc6>

最後のrc release。
WindowsでのCPU使用率についての記述がperecnt指定からmaximum指定になっていたり。[#777](https://github.com/opencontainers/runtime-spec/pull/777) 指定したいパーセントに100を掛けた値を設定するように読めますけども。

やっぱりmemory usageに負の値を指定できるようになりました。`-1` を指定するとunlimitedの意味になるようですね。 [#876](https://github.com/opencontainers/runtime-spec/pull/876)

platformについてのfiledが削除されました。runcでは使用されておらず、image-specのみが気にすることだろうということで？ [#850](https://github.com/opencontainers/runtime-spec/pull/850)

## v1.0.0
<https://github.com/opencontainers/runtime-spec/releases/tag/v1.0.0>

first release!

`disableOOMKiller` がmemory section配下に移動しました。[#896](https://github.com/opencontainers/runtime-spec/pull/896)
breaking chnageとされているのはこれだけ。

## v1.0.1
<https://github.com/opencontainers/runtime-spec/releases/tag/v1.0.1>

ほぼほぼwordingやtypo fixですね。当然ですけど。

## v1.0.2 (予定)
<https://github.com/opencontainers/runtime-spec/pull/1037>

v1.0.1に比べるとたくさんあります。
差分は(多分)これ
<https://github.com/opencontainers/runtime-spec/compare/v1.0.1...c4ee7d1>

hookが追加されました。 `createContainer`, `startContainer`, `createRuntime`の3つです。代わりに`prestart`がdeprecatedに指定されています。LXCと同じ名前だとか。 [#1008](https://github.com/opencontainers/runtime-spec/pull/1008)

memoryに関してcgroupのuse_hierarchyが使用できるようになっています。 [#985](https://github.com/opencontainers/runtime-spec/pull/985)
[第3回　Linuxカーネルのコンテナ機能［2］ ─cgroupとは？（その1）：LXCで学ぶコンテナ入門 －軽量仮想化環境を実現する技術｜gihyo.jp … 技術評論社](http://gihyo.jp/admin/serial/01/linux_containers/0003?page=2)

WindowsにおいてDeviceをschemaに含められるようになっています。 [#976](https://github.com/opencontainers/runtime-spec/pull/976)

libseccompが v2.4.0になり、`SMCP_ACT_LOG`が使用できるようになっています。[#1019](https://github.com/opencontainers/runtime-spec/pull/1019)
syscallのlogを残すようにする設定？ <http://man7.org/linux/man-pages/man3/seccomp_init.3.html> 

また、実装の一覧にgVisor、kara-container、crunが追加されています。crunはOCIのC実装で、runcより高速に動作するようです。元々はRedHatのgiuseppe氏による個人project？がContainers org配下に移動しています。
<https://github.com/containers/crun>

## まとめ
取り上げられていない変更がめちゃくちゃあるので気になった人は直接見てください。
