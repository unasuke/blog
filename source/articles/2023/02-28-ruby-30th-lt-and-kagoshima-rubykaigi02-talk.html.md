---
title: "Ruby30周年イベントでLTをしました&鹿児島Ruby会議で登壇します"
date: 2023-02-28 20:00 JST
tags: 
- ruby
- python
- quic
---

![](2023/raioquic-loc-202302.png)

## まとめ
- Ruby 30周年イベントでLTをしました
    - <https://30.ruby.or.jp/>
    - [イベント/2023/02/14/Ruby 30周年イベントLT発表一覧 - esa-pages.io](https://esa-pages.io/p/sharing/19703/posts/51/d26f8bcf02caba5e7b06.html)
    - 発表資料 [ruby30th-lt - unasuke - Rabbit Slide Show](https://slide.rabbit-shocker.org/authors/unasuke/ruby30th-lt/)
- 鹿児島Ruby会議02で「QUICをRubyの世界に持ってくる活動をしています」という発表をします
    - <https://k-ruby.com/kagoshima-rubykaigi02/>

本当は30周年LTをする前にこの記事を公開したかったのですが、色々あって今になりました。

## 最近やっていること
昨年末から、Rubyアソシエーション開発助成の対象として採択され、QUICプロトコルをRubyにて実装する活動をしています。具体的には、PythonによるQUIC実装 aioquic をRubyに移植するということを行っています。

"移植"とはいっても、**aioquic の完全な移植を作成するつもりはなく**、あくまでもこれはQUICの実装の感じを掴むために行なっているものです。現状、QUICの実装として主要な部分と言える、以下の移植を終わらせています。

- [aioquic/_buffer.c](https://github.com/aiortc/aioquic/blob/main/src/aioquic/_buffer.c) → [raioquic/buffer.rb](https://github.com/unasuke/raioquic/blob/main/lib/raioquic/buffer.rb)
- [aioquic/tls.py](https://github.com/aiortc/aioquic/blob/main/src/aioquic/tls.py) → [raioquic/tls.rb](https://github.com/unasuke/raioquic/blob/main/lib/raioquic/tls.rb)
- [aioquic/quic/configuration.py](https://github.com/aiortc/aioquic/blob/main/src/aioquic/quic/configuration.py) → [raioquic/quic/configuration.rb](https://github.com/unasuke/raioquic/blob/main/lib/raioquic/quic/configuration.rb)
- [aioquic/quic/crypto.py](https://github.com/aiortc/aioquic/blob/main/src/aioquic/quic/crypto.py) → [raioquic/quic/crypto.rb](https://github.com/unasuke/raioquic/blob/main/lib/raioquic/quic/crypto.rb)
- [aioquic/quic/events.py](https://github.com/aiortc/aioquic/blob/main/src/aioquic/quic/events.py) → [raioquic/quic/event.rb](https://github.com/unasuke/raioquic/blob/main/lib/raioquic/quic/event.rb)
- [aioquic/quic/packet.py](https://github.com/aiortc/aioquic/blob/main/src/aioquic/quic/packet.py) → [raioquic/quic/packet.rb](https://github.com/unasuke/raioquic/blob/main/lib/raioquic/quic/packet.rb)
- [aioquic/quic/packet_builder.py](https://github.com/aiortc/aioquic/blob/main/src/aioquic/quic/packet_builder.py) → [raioquic/quic/packet_builder.rb](https://github.com/unasuke/raioquic/blob/main/lib/raioquic/quic/packet_builder.rb)
- [aioquic/quic/rangeset.py](https://github.com/aiortc/aioquic/blob/main/src/aioquic/quic/rangeset.py) → [raioquic/quic/rangeset.rb](https://github.com/unasuke/raioquic/blob/main/lib/raioquic/quic/rangeset.rb)
- [aioquic/quic/recovery.py](https://github.com/aiortc/aioquic/blob/main/src/aioquic/quic/recovery.py) → [raioquic/quic/recovery.rb](https://github.com/unasuke/raioquic/blob/main/lib/raioquic/quic/recovery.rb)
- [aioquic/quic/stream.py](https://github.com/aiortc/aioquic/blob/main/src/aioquic/quic/stream.py) → [raioquic/quic/stream.rb](https://github.com/unasuke/raioquic/blob/main/lib/raioquic/quic/stream.rb)

また現時点では [aioquic/quic/connection.py](https://github.com/aiortc/aioquic/blob/main/src/aioquic/quic/connection.py) の移植作業を行っています[^connection]。冒頭の画像は、GitHubにpushしていないものも含めた現時点での行数を[tokei](https://github.com/XAMPPRocky/tokei)によって集計したものです。

## Ruby 30周年LTで話したこと
Ruby 30周年記念イベントにおいて、これら数千行のPythonのコードを読み、Rubyへと書き換えていくなかで、RubyにもPythonのこういう機能があれば便利だと思う、という意図のLightling Talkを行いました。

<iframe src="https://slide.rabbit-shocker.org/authors/unasuke/ruby30th-lt/viewer.html"
        width="640" height="404"
        frameborder="0"
        marginwidth="0"
        marginheight="0"
        scrolling="no"
        style="border: 1px solid #ccc; border-width: 1px 1px 0; box-sizing: content-box; margin-bottom: 5px"
        allowfullscreen> </iframe>
<div style="margin-bottom: 5px">
  <a href="https://slide.rabbit-shocker.org/authors/unasuke/ruby30th-lt/" title="ruby30th-lt">ruby30th-lt</a>
</div>


## 鹿児島で話すこと

鹿児島では、QUICの簡単な説明と、発表時点での実装においてどこまでのことが可能なのか実際に動かして説明し、今後の展望について話そうと考えています。

[^connection]: これの移植がうまくいかず、テストケースが通ったらこのブログを書こうと考えていましたが、結局まだ完走できていません。
