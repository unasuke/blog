---
title: スライド置き場のポリシー
date: 2021-07-30 00:25 JST
tags:
- diary
---


![JavaScriptがとんでもないことになっている様子](2021/slide-share-services-javascript.png)

## スライドをどこに置くか
[スライドをスライド共有サービスに置くのをやめることにした - 私が歌川です](https://blog.utgw.net/entry/2018/03/20/020148) を読み、自分の現時点でのスタンスを書いておこうかなの気持ちになったので書くものです。

- SlideShare
    - 一番最初に使っていた
    - ちいさい
        - 小さい表示かフルスクリーンかの2択になってしまう
- SpeakerDeck
    - スライド内に埋め込まれたリンクがクリックできない
        - これが本当に嫌い
    - URLを自由に指定できない
        - というのは嘘で実は自由に設定できる、けど自分が毎回それを忘れずにできる自信がない
- reveal.js
    - <https://revealjs.com/>
    - 次に使っていた
    - <https://unasuke.com/slides/> の赤くないやつ
    - 大抵のことはできる、機能的には十分
    - ちょっと凝ったデザインにするためにはHTML/CSSでがんばらないといけない
        - しかし、がんばればできる
    - GitHubの情報をとってくるポートフォリオサービスで、おそらくこれのせいでめちゃくちゃJavaScriptを書いている判定になってしまった
        - 冒頭の画像がそれ
    - 書き始めるまでの準備が多いので使わなくなってしまった
        - <https://slides.com/> を使えば解決するけど有料になる
- Rabbit
    - <https://unasuke.com/slides/> の赤いやつ
        -  <https://slide.rabbit-shocker.org/authors/unasuke/>
    - RubyだしOSSだしURL自由にできるしスライド内リンクもクリックできるし機能的には十分
    - 凝ったデザインにするのが厳しい
    - 記法がよくわからない
    - Windowsだと重い
        - WSLgだとどうなんだろう？
    - 埋め込み機能が自分のブログだと崩れる
        - 直しかたがわからないので手を出せていない
    - reveal.js同様、書き始めるまでの準備が多いので使わなくなってしまった
- esa & ブログ
    - 最近はこれが多い
        - esaのスライドモードで発表し、外部に公開するときにはしっかり書いたブログ記事を同時もしくは少し遅れて公開
            - [電子辞書 'Brain' 上でRuby 3.0をビルドするのには○○時間かかる](/2021/building-ruby-on-brainux/)
            - [S3は巨大なKVSなのでRailsのCache storeとしても使える](/2021/use-amazon-s3-as-rails-cache-store/)
            - 上2つの記事はそのスタイルによるもの
- Illustrator
    - めっちゃ凝ったものを作りたい場合
    - 以下2つのnoteはイラレ製 (厳密にはCNDTのほうは <https://pitch.com/> による土台がある)
        - [OOParts -Stateless Cloud Gaming Architecture- #CNDT2020｜うなすけ｜note](https://note.com/unasuke/n/n0f154a1795b1)
        - [Agones移行物語 - Kubernetes Meetup Tokyo 42 #k8sjp｜うなすけ｜note](https://note.com/unasuke/n/neddb8af116fd)
        - noteだと、画像だけ貼ってあるのもなんだか寂しいので文字起こしをした
    - 本当になんでもできる
    - PDFをどうやって共有するかが課題
- Docswell
    - <https://www.docswell.com/>
    - 様子見のフェーズ
      - [海外のスライド共有サービスがやる気ないので自分で作ってみた - Qiita](https://qiita.com/ku_suke/items/7702c7b25aa31672a2bf)
    - スライド内URLがクリックできない
        - 下部にテキストが抽出されているのでそこから遷移はできる

めんどくさい人間だなという自覚はあります。とにかくスライドに出てくるURLをクリックしたいという気持ちが強く、それができないスライド共有サービスに自分のスライドは置きたくないです。

最適解は、歌川さんも書いているようなPDFを置いておくWebサイトを立てておくことになるでしょうが、ちょっと面倒だなあというので外部サービスに頼っていたいです。あと埋め込みどうすればいいんだろう。
