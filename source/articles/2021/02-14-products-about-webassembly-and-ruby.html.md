---
title: "RubyとWebAssemblyの関係についてわかる範囲でまとめる"
date: 2021-02-14 20:26 JST
tags: 
- programming
- ruby
- webassembly
---

![Artichoke](2021/wasm-and-ruby-artichoke.png)

## はじめに
2021年1月にv1.0がリリースされたWasmerにRuby Gemが存在することに触発されて調べてみました。RubyとWebAssemblyが関わっているものについてわかる範囲でまとめ、軽くどのようなものかを書いていきます。

僕自身、業務はおろかプライベートでもWASMを書いたことはなく浅い理解しかしていないですが……

## WebAssembly (WASM)とは

> WebAssembly は最近のウェブブラウザーで動作し、新たな機能と大幅なパフォーマンス向上を提供する新しい種類のコードです。基本的に直接記述ではなく、C、C++、Rust 等の低水準の言語にとって効果的なコンパイル対象となるように設計されています。
> 
> この機能はウェブプラットフォームにとって大きな意味を持ちます。 — ウェブ上で動作するクライアントアプリで従来は実現できなかった、ネイティブ水準の速度で複数の言語で記述されたコードをウェブ上で動作させる方法を提供します。
> *https://developer.mozilla.org/ja/docs/WebAssembly/Concepts*

なんか、そういうやつです。

* [WebAssembly | MDN](https://developer.mozilla.org/ja/docs/WebAssembly)
* [WebAssembly Community Group](https://www.w3.org/community/webassembly/)

## Ruby to WASM
Rubyを何らかの方法で最終的にWASM Bitecodeにコンパイルするものたちです。

### blacktm/ruby-wasm
<https://github.com/blacktm/ruby-wasm>

紹介記事がTechRachoさんによって日本語訳されたので見覚えのある方もいるかと思います。

- [Tom Black — Ruby on WebAssembly](https://www.blacktm.com/blog/ruby-on-webassembly)
- [mrubyをWebAssemblyで動かす（翻訳）｜TechRacho（テックラッチョ）〜エンジニアの「？」を「！」に〜｜BPS株式会社](https://techracho.bpsinc.jp/hachi8833/2018_08_22/60810)

記事内に言及がありますが、以下のようにmrubyを経由して最終的にWASM binaryを生成します。

> Ruby script → MRuby bytecode → C → emcc (Emscripten Compiler Frontend) → LLVM → Binaryen → WebAssembly

ここで登場する[binaryen](https://github.com/WebAssembly/binaryen)ですが、GitHubのWebAssembly org以下で開発されている、公式のtoolchainです。上記で行われているようなWebAssemblyへのコンパイルの他にも、wasm bitecodeからのunassemble(text formatへの変換)などの様々なツールが同梱されています。

<https://github.com/WebAssembly/binaryen>

###  Rlang
<https://github.com/ljulliar/rlang>
> a Ruby-like language compiled to WebAssembly

Rubyのsubsetである "Rlang" からWASM bitecodeへのコンパイルを行うものです。このRlangとRubyの差異は以下にまとまっています。例えば整数型のサイズを32bitか64bitかを指定するsyntaxや、可変長引数が使用できないなどの違いがあります。

<https://github.com/ljulliar/rlang/blob/master/docs/RlangManual.md>

名前の由来として、C言語に変換できるSmalltalkのsubsetであるSlangからもじって付けられているようです。(そういう意味でRと名前が被っているのは仕方がないとも述べられています)

<http://wiki.squeak.org/squeak/slang>


### prism-rb/prism
<https://github.com/prism-rb/prism>
> Build frontend web apps with Ruby and WebAssembly

frontend web applicationをRubyとWebAssemblyで作成できるようにするframeworkです。`Prism::Component`から継承したClassに記述されたapplication logicがEmscriptenによりWAMにコンパイルされて実行されるようです。

## Ruby on WASM
WASM上でRubyを実行できるようにするものたちです。

### Artichoke
<https://www.artichokeruby.org>

> Bundle Ruby applications into a single Wasm executable with Artichoke, a Ruby made with Rust.

Rust実装によるRuby runtimeです。Ruby界隈ではArtichokeの名前を聞いたことのある方は多いと思います。RustはコードをWASMにコンパイルすることができるので、ArtichokeもWASMとして動かすことができます。
<https://artichoke.run> がPlaygroundなのですが、inspectorからWASMが動いている様子を観測できます。

![Artichoke](2021/wasm-and-ruby-artichoke.png)

### runrb.io
- <https://runrb.io>
- <https://github.com/jasoncharnes/run.rb>

ruby/rubyをEmscriptenで動かしているようです。もっと詳しく説明すると、独自patchを適用したRuby 2.6からEmscripten(emmake)でminirubyのbitecodeを生成しています。それをさらにEmscripten(emcc)でWASMにコンパイルしています。ここから先がちょっとよくわからなかったのですが、最終的にRubyをWASM bitecodeにしているのでしょうか？

<https://github.com/jasoncharnes/run.rb/blob/d0f5cf9c954335795fca7c24760e728dbf47b425/src/emscripten/ruby-2.6.1/Dockerfile>

PlaygroundでRubyを実行する度にworkerが生成されて別のbitecodeを実行しているようなのですが……`RUBY_PLATFORM` は `x86_64-linux`、`RUBY_VERSION`は `2.6.1`となっていました。`Encoding.list`の結果が少なかった[^isminiruby]から実際に動いているのはminirubyなのかもしれません。

![runrb.io](2021/wasm-and-ruby-runrb.png)

### wruby
<https://github.com/pannous/wruby>

minirubyをEmscriptenでWASMにコンパイルしています。なんとmruby/mrubyをforkしています。

<https://github.com/mruby/mruby/compare/master...pannous:master>

### mwc
<https://github.com/elct9620/mwc>

> The tool for the developer to help them create mruby applications on the WebAssembly.

とのことですが、READMEからはイマイチどういうものかつかめなかったので、`Create Project`に記載のある`mwc init`が何をするか見てみたところ、`<mruby.h>`をincludeしてmrubyの機能を使用するC言語のコードをEmscriptenによりWASMへとコンパイルしているようでした。

<https://github.com/elct9620/mwc/tree/master/lib/mwc/templates/app>

### mruby-L1VM
<https://github.com/taisukef/mruby-L1VM>

BASICが動く教育向け(でいいのか？)マイコンボードのIchigoJam上で動くmruby実装をWebAssemblyに移植したものです。`mruby_l1vm.h`がキモのようですね。

[mruby on web - WebAssemblyのバイナリ4KB以下で動かす超軽量クライアントサイド用Ruby #ruby / 福野泰介の一日一創 / Create every day by Taisuke Fukuno](https://fukuno.jig.jp/2480)

### emruby
<https://github.com/mame/emruby>

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">作り込みはぜんぜんダメですが、仲間にいれてあげてください！ 最近の ruby/ruby master を emscripten できるようにしてます<a href="https://t.co/7PvkHsZ0In">https://t.co/7PvkHsZ0In</a></p>&mdash; Yusuke Endoh (@mametter) <a href="https://twitter.com/mametter/status/1362226547151622145?ref_src=twsrc%5Etfw">February 18, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

作者のmameさんから直接教えていただきました。 ruby/rubyにpatchを当てたものをEmscriptenによってWASMにコンパイルしています。(WASMにしているのはminiruby) <https://mame.github.io/emruby/> で試すこともできます。最近作成されていることもあり、Rubyのversionが3.1.0devなのが凄いですね。

読み方は「いーえむるびー」であり、「えむるびー」ではないのに注意。この40行ほどのpatchでWASMにコンパイルできるんですね……

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">ありがとうございます！patch は、文字列を JS eval する emscripten API を生やすだけなので、なくてもコンパイルできるはずです</p>&mdash; Yusuke Endoh (@mametter) <a href="https://twitter.com/mametter/status/1362243221120716800?ref_src=twsrc%5Etfw">February 18, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Emscriptenって、凄いですね。

## WASM runs by Ruby
RubyからWASMを実行できるようにするものです。

### wasmer.io
- <https://wasmer.io>
- <https://github.com/wasmerio/wasmer-ruby>

冒頭で紹介したものです。Wasmerは、WebAssemblyをWebブラウザ外で実行できるランタイムです。wasmer gemはそのWasmerをRubyから扱えるようにするgemとなっており、以下のドキュメントから具体的な使い方を知ることができます。

<https://www.rubydoc.info/gems/wasmer/>

上記ドキュメントにあるように、例えばRustのコードをWASMにコンパイルしてRubyから実行する、ということができますね。

### wasmtime-ruby
<https://github.com/dtcristo/wasmtime-ruby>

WasmtimeのRuby bindingとあります。Wasmtimeは、(Wasmerのように)あらゆるプラットフォームでのWASMの実行を可能にすることなどを目指すBytecode Allianceのプロジェクトのひとつで、WASM及びWASIの軽量ランタイムです。

- <https://bytecodealliance.org>
- <https://wasmtime.dev>
    - <https://github.com/bytecodealliance/wasmtime>
- [コンテナ技術を捨て、 WASIを試す. こんにちは、NTTの藤田です。 | by FUJITA Tomonori | nttlabs | Medium](https://medium.com/nttlabs/wasi-6060b243ac90)

`require 'wasmtime/require'` とすることで、WASMバイナリ及びテキスト表現を直接 `require`して実行できるのは面白いですね。

## WASM to Ruby
WASMをRubyのコードに変換するものです。(逆アセンブル？)

### edvakf/wagyu
<https://github.com/edvakf/wagyu>

READMEには

> Wagyu aims to be a library to parse and execute Web Assembly binaries on Ruby.

と書かれていますが、2019年に行われたTama Ruby会議の発表によると、WASMのテキスト表現を一度Rubyのコードへ変換してから実行するようなアプローチになっています。

[WebAssemblyを Rubyにコンパイルする 黒魔術コード完全解説 - Speaker Deck](https://speakerdeck.com/alice345/webassemblywo-rubynikonpairusuru-hei-mo-shu-kodowan-quan-jie-shuo)


## その他
「こんなものもありますよ」と教えていただいたものの、現時点でWASMは使用されていなかったものです。

### webruby
<https://github.com/xxuejie/webruby>

Rubyではなくmrubyではありますが、Web上でruby scriptを実行できるようにするものです。
<http://joshnuss.github.io/mruby-web-irb/> から実際に試すことができます。

これはEmscriptenによってmrubyをJavaScriptに変換しているのみで、WASMは使用されていませんでした。

### DXOpal
まず、RubyのコードをJavaScriptに変換するOpalというコンパイラがあります。例えばRuby公式Webサイトからリンクされている、Webブラウザ上でRubyを試すことのできる <https://try.ruby-lang.org> ではOpalが使われています。

- <https://opalrb.com>
- <https://github.com/opal/opal>
- <https://try.ruby-lang.org>

そして、RubyからDirextXのAPIを利用することができ、RubyによってWindows向けにゲームを開発することのできるライブラリ、DXRubyというものがあります。

- <http://dxruby.osdn.jp>
- <https://github.com/mirichi/dxruby>

DXOpalは、そのDXRubyのAPIを「だいたいそのまま」移植してWebブラウザ上でゲームを開発できるようにしたライブラリです。

- <https://yhara.github.io/dxopal/index.html>
- <https://github.com/yhara/dxopal>
- [Rubyで始めるゲームプログラミング - DXOpal編 -](https://magazine.rubyist.net/articles/0057/0057-GameProgramingWithDXOpal.html)

そのDXOpalですが、RubyKaigi 2017にて一部をWebAssmeblyにしてみたとの発表がありました。

<iframe width="560" height="315" src="https://www.youtube.com/embed/bNTajEO_ndA" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

[Ruby, Opal and WebAssembly - Speaker Deck](https://speakerdeck.com/yhara/ruby-opal-and-webassembly)

発表では、RubyをWebAssemblyに移植する難しさについても言及されています。

しかし発表内でデモされていたWebAssembly実装ですが、現時点ではmasterにmergeされてはいないようでした。

- <https://github.com/yhara/dxopal/tree/rk2017>
- <https://github.com/yhara/dxopal/issues/1>

## 追記
### 2021-02-18
emrubyについての記述を追加しました。

### 2021-02-22
「その他」を追加しました。

[^isminiruby]: <https://naruse.hateblo.jp/entry/20110118/1295345908> より
