---
title: Kaigi on Rails 2021 の運営スタッフをしました
date: 2021-10-24 21:30 JST
tags:
  - kaigionrails
  - diary
---

![OBS](2021/kaigionrails-2021-end.png)

## Kaigi on Rails 2021 おつかれさまでした

Kaigi on Rails 2021 に参加していただいた皆様、素晴らしい発表をしてくださった発表者の皆様、そして Proposal を提出してくださった皆様、協賛していただいたスポンサーの皆様、本当にありがとうございます。今年も Kaigi on Rails を開催することができました。

まだまだ残っている作業は多いのですが、ひとまず本編終了ということで振り返りを書こうと思います。

## 担当範囲

- cfp-app のお世話
  - deploy とか色々
- ドメイン周り
- 動画編集
  - いただいた動画の合成&書き出し
  - 字幕付け
- 当日配信(バックアップ)
- 雑用少々

大体昨年と同じような範囲を担当しました。

[Kaigi on Rails STAY HOME Edition 配信の裏側](/2020/kaigionrails-backstage/)

配信については昨年と少し変わって、OBS から配信するマシンと Zoom に入場して映像・音声を拾うマシンを完全に別にしました。こうすることによって Slack など他アプリの音がまちがって入ることのない体制を組むことができました。

昨年から cfp-app は用意したかったのですが、様々な事情[^cfp-app]により導入は今年からとなってしまいました。また、cfp-app はやっぱり便利だけど、これまたとある事情[^cfp-app]により今年は使いこなすことができませんでした。来年に向けてやっていく気持ちがあります。

[^cfp-app]: 飲みに行くぞ！！！！

## オンラインカンファレンスと "手応え"

終わってみれば Doorkeeper の参加者登録は 700 人超というすごい数字になりました。YouTube の配信も同時視聴者数が 200 人超と、とても多くの方々に参加していただけたと思います。

しかし今回、準備から開催終了まで、スタッフは一切リアルで集合することはありませんでした。

また、実際に会場を抑えて開催するイベントにおいて、数百人が集まるというのは、それを実際に "見る" ことができます。

ですが、Kaigi on Rails 2021 の本編運営においては、言ってしまえばパソコンの前でポチポチしているだけ[^pc]で、家から一歩も出ずに終わってしまいました。

[^pc]: もちろんですがお気楽ということはありません。OBS の操作ひとひとつで手が震えています。

これは技術が発展したからだという良い面ももちろんありますが、どうにもこれまでのスタッフ業と比較すると「やった感」があまりないというか、本当にみんな来てくれて、楽しんでくれたんだろうか、そういうイベントをやれていたんだろうかという気持ちが残ります。

なので、皆さんの Twitter での投稿や reBako、SpatialChat 、感想ブログでの反応をありがたく頂いています。

## Next

準備期間中は先輩イベントである RubyKaigi の取り組みからの着想であったり、他にも様々なアイデアが出てきましたが、どうにも開催までの期間では他にやることも多く中々手が出せていませんでした。

来年というか次回の Kaigi on Rails でどれだけお手伝いできるかはわかりませんが、しばらく(Kaigi on Rails の運営業が)ゆっくりできる時間に細々と手を動かしていけたらいいなと思っています。

そして、もしかしたら来年の開催ではリアル会場で開催できるのか、できないのか……という情勢になってきています。そうなったとき、どこまでオンライン重点で準備をしていくべきか[^offline]というのが全く見えていません。難しいですね。

---

この記事は The Mark 65 によって書かれました。

[^offline]: 例えばコロナウイルスの感染脅威が十分に低下し、これまでのようなオフラインイベントの開催にあたっての制限が現実的なものに落ち着いたとして、そもそも会場はどうするかという問題があり、なので来年も引き続きフルオンラインイベントとして開催し、再来年にようやくリアルで、となる可能性は十分にある、というかそのほうが高いんじゃないだろうか……等