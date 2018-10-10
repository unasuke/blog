---
title: 'Itamaeのメンテナになりました'
date: 2018-10-11 00:00 JST
tags: 
- diary
- programming
- ruby
- itamae
---

![invited](2018/invited-itamae-org.png)

## きっかけ
<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr"><a href="https://twitter.com/ryot_a_rai?ref_src=twsrc%5Etfw">@ryot_a_rai</a> こんどitamaeの話をしたいので飲みに行きましょう!!!! CC <a href="https://twitter.com/sue445?ref_src=twsrc%5Etfw">@sue445</a></p>&mdash; うなすけ (@yu_suke1994) <a href="https://twitter.com/yu_suke1994/status/1048787143286435840?ref_src=twsrc%5Etfw">2018年10月7日</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

僕が以前書いた、[落ちていたitamaeのintegration specを直しました](/2018/fix-itamae-integration-spec/) から、[@sue445](https://github.com/sue445) さんもtravis-ciに移行させるpull reqを出したりと、停滞していた開発が再開しそうな流れになっていました。

しかし、作者の [@ryotarai](https://github.com/ryotarai) さんに時間がないのか、なかなかmergeまで持っていくことができていませんでした。
そこで冒頭のtweetがあり、3人で集まった結果、 僕とsue445さんが itamae-kitchen organization にMemberとして追加されることになりました。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">【速報】.<a href="https://twitter.com/yu_suke1994?ref_src=twsrc%5Etfw">@yu_suke1994</a> さんが .<a href="https://twitter.com/ryot_a_rai?ref_src=twsrc%5Etfw">@ryot_a_rai</a> さんを詰めた結果（違）、Itamaeのコミッタになりました！ <a href="https://t.co/gSo2oTrhz1">pic.twitter.com/gSo2oTrhz1</a></p>&mdash; sue445@10/8技術書典5 か75 (@sue445) <a href="https://twitter.com/sue445/status/1050015645012615170?ref_src=twsrc%5Etfw">2018年10月10日</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

(今気づいたのですが、現時点で僕のcommitはItamaeには入っていないんですね)

## Itamae について思っていること
近年のWebアプリケーションインフラ界隈は、Docker、Kubernetesなどによって Cloud Native になっていく流れが主流となっているように感じています。今所属している会社でも、Rails on Docker on Kubernetes with GKE という構成になっており、いわゆる「モダン」と呼ばれる構成からはインスタンスのプロビジョニングという概念が消えつつあります。

Itamaeに限らず、ChefやAnsibleなど書くことになる機会も減っていくでしょう。

ただ、世間の潮流がどれだけ Cloud Native になったとしても、インスタンスの構築という作業が消えてなくなることは絶対にありません。それに、個人レベルで生のマシンの構築を行なったりするという概念もなくなりはしないでしょう。

そのような場合において、Itamaeを選択肢のひとつとして十分に検討対象であるという状況を続けていきたいと考えています。何故なら僕はRubyistですし、構成管理ツールの中ではItamaeが最も好きだからです。


今後のItamaeにおいて、後方互換を失う規模の変更が入るということはないと思いますが、ryotaraiさん、sue445さんと話していてまだまだ改善する部分はあるという認識は共通しています。細かい改善をしながら粛々とメンテナンスが行なわれていくことになるでしょう。

今後よろしくお願いします。
