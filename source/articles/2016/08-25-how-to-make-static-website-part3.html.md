---
title: 静的Webサイトのつくりかた その3
date: 2016-08-25 01:43 JST
tags:
- howto
- static-web-page
---

![ドメイン入力](2016/static-web-03-onamae-01.png)

## つくりかた記事リスト
- [静的Webサイトのつくりかた その1](/2016/how-to-make-static-website-part1/)
- [静的Webサイトのつくりかた その2](/2016/how-to-make-static-website-part2/)
- [静的Webサイトのつくりかた その3](/2016/how-to-make-static-website-part3/)

## ドメインを取る
今回は、webサイトを公開するためのドメインを、お名前.comで取得します。

## ドメインとは
インターネット上で接続することのできるコンピューターには、IPアドレスというものが割り当てられています。例えばこのブログ、`blog.unasuke.com`を配信しているサーバーには`133.130.125.80`というIPアドレスが割り当てられています。(記事公開時点)

しかし、このブログを読むために、いちいちIPアドレスを入力するのは手間ですし、そもそもIPアドレスはそう簡単に覚えられるものではありません。

そこで、ドメインというものを取得し、IPアドレスと紐つけることによって、`blog.unasuke.com`でこのブログにアクセスできるようになります。

ちなみにIPアドレスの取得にもドメインの取得にもお金がかかります。クレジットカードがあると便利です。
この記事ではドメインをお名前.comで、サーバーをConoHaで取得します。どちらのサービスもクレジットカード以外にコンビニ支払いや銀行口座決済に対応しています。

## お名前.comでドメインを探す
__(ここから先の画像は、記事公開時点のもので、将来的に変更されるおそれがあります)__

まずは[お名前.com](http://www.onamae.com/)で、欲しいドメインを入力しましょう。

![ドメイン入力](2016/static-web-03-onamae-01.png)

いくつか空いているものがあるので、欲しい分選択します。

![ドメイン選択](2016/static-web-03-onamae-02.png)

「お申し込みへ進む」と、このような画面になります。今回はドメインだけ取得するので、レンタルサーバー、officeのチェックは外します。

![オプション選択](2016/static-web-03-onamae-03.png)

Whois情報公開代行とは何でしょうか。Whoisというのは、ドメインの所有者情報のことです。Whoisで、そのドメインの所有者が誰なのか、所有者への連絡先は何かなどの情報を取得することができます。

たとえばこれは、[政府広報オンライン](http://www.gov-online.go.jp/)のドメインに対してWhois情報を取得した結果です。

```
$ whois gov-online.go.jp
[ JPRS database provides information on network administration. Its use is    ]
[ restricted to network administration purposes. For further information,     ]
[ use 'whois -h whois.jprs.jp help'. To suppress Japanese output, add'/e'     ]
[ at the end of command, e.g. 'whois -h whois.jprs.jp xxx/e'.                 ]

Domain Information: [ドメイン情報]
a. [ドメイン名]                 GOV-ONLINE.GO.JP
e. [そしきめい]                 ないかくふせいふこうほうしつ
f. [組織名]                     内閣府政府広報室
g. [Organization]               Cabinet Office
k. [組織種別]                   政府機関
l. [Organization Type]          Government
m. [登録担当者]                 HI3920JP
n. [技術連絡担当者]             NH2778JP
p. [ネームサーバ]               ns02.gov-online.go.jp
p. [ネームサーバ]               ns00.vips.ne.jp
p. [ネームサーバ]               ns01.vips.ne.jp
s. [署名鍵]
[状態]                          Connected (2016/12/31)
[登録年月日]                    2001/12/19
[接続年月日]                    2001/12/20
[最終更新]                      2016/01/01 01:02:15 (JST)
```

このWhois情報には、ドメイン登録者の名前や住所を含める必要があります。お名前.comでは、これらの個人情報のかわりにGMOインターネット株式会社(お名前.comの運営会社)の情報を登録してくれるサービスを提供しているので、それを利用したい場合はチェックを入れておきます。

この後は、お名前.comの会員登録を済ませているのであればログインしてドメイン取得、そうでなければ新規会員登録をする必要があります。

![お名前.com 新規会員登録](2016/static-web-03-onamae-04.png)

![購入確認](2016/static-web-03-onamae-05.png)

購入しました。ドメインを購入するとメールが一気に何通も来ます。それらの内容をよく読み、必要な手続きを済ませましょう。(メールアドレスの有効性確認などがあるかもしれません。)

![購入完了](2016/static-web-03-onamae-06.png)

さて、これでドメインの取得は完了しました。ちょっと長くなったのでここで終わりにして、次はサーバーを契約してsshするところまでやりたいと思います。

## 参考
- [Whoisとは | JPドメイン名の検索 | JPドメイン名について | JPRS](https://jprs.jp/about/dom-search/whois/)
- [Whois情報公開代行｜ドメイン取るならお名前.com](http://www.onamae.com/service/d-regist/option.html)
