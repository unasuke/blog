---

title: "Rubyアソシエーション開発助成2022を終えて"
date: 2023-03-23 19:10 JST
tags: 
- ruby
- quic
---

![](2023/raioquic-loc-202303.png)

## 成果
* 最終成果報告書
    * Rubyアソシエーション側で公開されたらURLをここに貼ります
* リポジトリ
    * <https://github.com/unasuke/raioquic>
    * <https://github.com/unasuke/lsqpack-ruby>

Rubyアソシエーション開発助成 2022年度の僕のプロジェクトの成果としては、以上の通りとなります。このブログは最終成果方向ではなく、個人的なふりかえりなどを書いています。

## 感想
感想としては、「勉強にはなったが、しんどかった」です。いくら既存の実装を移植するタスクとはいえ、いくらPythonがRubyと似た言語であるとはいえ、移植作業はとても困難[^dev-env]でした。単純に行数が多いというのもその理由のひとつですが、特に移植が大変だった `tls.py` と `connection.py` では、さらに大きな問題がありました。

[^dev-env]: 開発は基本的にUbuntuマシンにSSHして行っていました。これを、福岡Rubyist会議03や鹿児島Ruby会議02のときには飛行機に乗ることもあり、MacBook上に開発環境を構築しようとしましたが、しばらく頑張ってもaioquicのテストをApple SiliconのMac上でネイティブ実行することができずに諦めました。OpenSSL周りに問題がありそうだというところまではわかったのですが……とはいえ移動中にまともなコードは結果的に書けなかったので、これは些細な問題でした。

まずは、処理対象となるデータが暗号化されていることです。テストケースが落ちているとき、どこから実装が誤っているのかの調査が困難でした。とにかく大量のdebug printを出したり、PyCharmのdebuggerとdebug.gemによるstep実行を1行ごとに交互に進め合ったりするなどしてなんとかしました。その結果、基礎的な暗号技術の知見がないために生まれたバグが原因だったり、call stackの奥深くでtypoしていたりして、自分の実力を思い知らされました。

次に、暗号化に関連しますが、OpenSSL binding API の問題です。PythonもRubyも、暗号化や、鍵交換に関わる処理はOpenSSLを利用しています。Python、aioquicだと[pyca/cryptography](https://github.com/pyca/cryptography)が、Rubyだと[openssl gem](https://github.com/ruby/openssl)がOpenSSLのAPIを利用するのに使われますが、この2つのライブラリ間で、OpenSSL APIの抽象化度合いが異なります。なのでOpenSSL APIを使う部分の移植については、まずPython側の実装が最終的に何のOpenSSL C APIを呼んでいるかを突き止め、それがopenssl gemではどんなAPIになっているかを調べる、という手順が必要でした。

言ってしまえば、この分野に首を突っ込むにはまだまだ知識が不足していることを痛感させられた、ということです。

一方、そのような難しいことに取り組むことにあたって、やはり「やります！」と宣言して締め切りが生まれるのは、自分の手を動かすことへの途方もないくらいの後押しになりました。採択されなくても進めるつもりではありましたが、その場合は倍以上の時間がかかるか、そもそも諦めていたでしょう。

また、この取り組みにあたって、どうせならと型定義も書くことにしました。型定義(RBS)を書くことで、補完や警告による恩恵を受けることができました。ただ、nil checkをした後でもnilによる警告が出たり、長大なファイルになってくると補完候補が出てくるまでにふた呼吸必要になったりと、まだまだこれからという印象は否めませんでした。型定義について、これからはなるべく書いていこうと思います。

## 買ったり読み直したりした本
このプロジェクトを進めるにあたって新規に購入したり、既に買っていたけど改めて読み直したりした本が以下です。

### O'Reilly Japan - 入門 Python 3 第2版
<https://www.oreilly.co.jp/books/9784873119328/>

このプロジェクトをやる人間が読むのが「入門」はないだろうという感じではありますが、Pythonについて体系的に学んだことがなかったので購入しました。
この本を読むまで知らなった文法が多々あり、もちろんそれはaioquicでも使われている場面がそこそこあったので、読んでおいてよかったです。

### プロフェッショナルSSL/TLS – 技術書出版と販売のラムダノート
<https://www.lambdanote.com/products/tls>

SSL/TLSそしてOpenSSLに関しては、とりあえずはこの本を読んでおいて間違いないと考えており、以前から所有していました。実装にあたってTLS 1.3を解説した新章がその助けになりました。

### 徹底解剖 TLS 1.3（古城 隆 松尾 卓幸 宮崎 秀樹 須賀 葉子）｜翔泳社の本
<https://www.shoeisha.co.jp/book/detail/9784798171418>

TLSの実装の際に、より役に立ったのはこちらの本でした。「プロフェッショナルSSL/TLS」のほうはSSL/TLSがどのようなものであるかの説明であるのに対し、こちらの本はOpenSSLのAPIを使って実際に通信をするためのコードが出てきたりと、より実装寄りの本となっています。

### 暗号技術のすべて（IPUSIRON）｜翔泳社の本
<https://www.shoeisha.co.jp/book/detail/9784798148816>

TLSが通信を暗号化するために使用している技術について学ぶことができる本です。まだ読み終えてはいませんが、そもそもにTLSを移植しようという人間が、その内部で使われている暗号技術に関して無知というのはいかがなものかと思い読んでいます。

### OpenSSL ―暗号・PKI・SSL/TLSライブラリの詳細― | Ohmsha
<https://www.ohmsha.co.jp/book/9784274065736/>

これもまだ読み終えられていません。なぜこの本を買ったかというと、OpenSSLについての知識が足りないなと思ったためです。この本ではOpenSSLの0.9.6について解説しており、現在OpenSSLの最新リリースは3.1.0です。なので今となっては古い本となってしまいますが、そもそもOpenSSLそのものを解説した(日本語の)本というのは本当に少ないので、まずはこれを読もうと思っています。

## そしてQUICの現状
僕の理解を書きます。なので誤っているかもしれません。

QUICについては、IETFのQUIC working group(以降WGなどと略します)で議論されており、現在activeなDraftは8つあります。またQUICのWG以外でもQUICが関連しているRFCやDraftがあります。例えば最近はQUIC上で映像や音声の転送を行うための仕様について議論する[Media Over QUIC WG](https://datatracker.ietf.org/wg/moq/documents/)が盛り上がっている[^moq]ようです。

[^moq]: Media Over QUIC、実はあまり追い掛けていなかったので調べながら書いています。いや、他のRFCやdraftについても調べながら書いています。

QUICプロトコル自体については、Version 2についてのdraftが出ています。Version 1からの変更点は、まずversion値が変更されます。暗号化について定めされているいくつかの初期値も変更されます。そして、そもそもQUICのどのversionで通信を行うのかを合意するversion negotiationをどのように行うかについてもdraftになっています。

* <https://datatracker.ietf.org/doc/html/draft-ietf-quic-v2-10>
* <https://datatracker.ietf.org/doc/html/draft-ietf-quic-version-negotiation-14>

興味深いのは、これまでのQUIC v1ではversionの値として `0x00000001` が使用されますが、QUIC v2ではその値に `0x6b3343cf` が使われることです。これは硬直化を防ぐのが目的だと記載されています。硬直化とは、通信を処理するプログラムの古い実装が、新しい仕様での通信内容を解釈できずに通信が阻害されてしまうことを指します。既存の例を挙げると、TLS 1.3では、自身のバージョン値として TLS 1.2の値を使用して通信することになっています[^ossify-asnokaze][^bulletproof]。そもそもに、QUIC v2がそのような硬直化を防ぐためにRFCとなる作業が進められている(ように読める)ものなので、QUIC v1がもう古くなって脆弱だ、ということはありません。それはdraft-ietf-quic-v2-10にも

> QUIC version 2 is not intended to deprecate version 1.

と明記されています。

[^ossify-asnokaze]: [HTTPと硬直化 (ossification) の問題 - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2020/07/07/231357)
[^bulletproof]: [プロフェッショナルSSL/TLS](https://www.lambdanote.com/products/tls) 付録A TLS 1.3 A1.1.1 Record Structure 参照のこと

他にもdraftになっているものはいくつかありますが、3月末に開催されるIETF 116 YokohamaにおいてAgendaにあるのは以下の3つです。(QUIC v2についてはAgendaには載っていません)

* Multipath Extension for QUIC
    * <https://datatracker.ietf.org/doc/draft-ietf-quic-multipath/>
    * 複数の通信経路(例えばWi-Fiと4G回線)を用いてQUICによる通信を行う方法について定義するもの
    * [新しいQUICのマルチパス拡張の仕様 - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2021/11/15/010553)
* QUIC Acknowledgement Frequency
    * <https://datatracker.ietf.org/doc/draft-ietf-quic-ack-frequency/>
    * QUICがどのくらいの頻度でackをやりとりするか(どのくらいackを遅延させて負荷を軽減させられるか)について定義するもの
* Main logging schema for qlog
    * <https://datatracker.ietf.org/doc/draft-ietf-quic-qlog-main-schema/>
    * QUICの通信におけるログについて、schemaを定義するもの

Media Over QUICのほうに目を向けてみると、mailing listの投稿がとても活発で追いかけるのが大変なのですが、下記のyukiさんのまとめによれば、Warpをbase draftとして議論が進んでいるようです。まとめではdraftの番号が02となっていますが、今年3/13に04が出ています。

* [Media over QUICの base draft について - ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2022/11/07/012718)
* Mailing list archive <https://mailarchive.ietf.org/arch/browse/moq/>
* <https://datatracker.ietf.org/doc/html/draft-lcurley-warp-04>

おそらくIETF 116においてもこれについてのミーティングが行われるのだと思いますが、今これを書いている段階ではまだAgendaがなにもありません。

## これから
プロジェクトとしては一区切りしましたが、移植作業そのものはまだ途中です。引き続きQUICの実装に取り組むつもりです。が、とりあえず迫っているRubyKaigiの準備があるのでしばらく実装についてはゆっくりになると思います。というかまあ、プロジェクト期間中は結構無茶な開発をやっていたので、しばらくはペースが落ちると思います。

ここで書きすぎると、RubyKaigiで話す内容がなくなってしまうのでこのくらいで。

## Acknowledgment
メンターとして面倒を見てくださった笹田さん、そしてそもそも僕のproposalを採択していただき、このような機会をくださったRubyアソシエーションさんに感謝します。本当にありがとうございました。
