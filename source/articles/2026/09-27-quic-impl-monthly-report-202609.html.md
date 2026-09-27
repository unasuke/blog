---
title: "QUIC実装月報 2026年9月"
date: 2026-09-27 22:05 +0900
tags: 
- quic
- tls
- quic-impl-monthly-report
---

![](2026/quic-impl-monthly-report-202609-mcp-coderunner-app.png)


<div lang="en">

Translated by AI (and reviewed by me) from handwritten Japanese text. (日本語が後に続きます)

## RubyKaigi 2026 follow up and Fastly Tech Meetup vol.1
I gave talks at two events in September:

<iframe src="https://slide.rabbit-shocker.org/authors/unasuke/rubykaigi-2026-followup/viewer.html"
        width="640" height="404"
        frameborder="0"
        marginwidth="0"
        marginheight="0"
        scrolling="no"
        style="border: 1px solid #ccc; border-width: 1px 1px 0; box-sizing: content-box; margin-bottom: 5px"
        allowfullscreen> </iframe>
<div style="margin-bottom: 5px">
  <a href="https://slide.rabbit-shocker.org/authors/unasuke/rubykaigi-2026-followup/" title="RubyKaigi 2026 followup">RubyKaigi 2026 followup</a>
</div>

<iframe src="https://slide.rabbit-shocker.org/authors/unasuke/fastly-tech-meetup-vol-1/viewer.html"
        width="640" height="404"
        frameborder="0"
        marginwidth="0"
        marginheight="0"
        scrolling="no"
        style="border: 1px solid #ccc; border-width: 1px 1px 0; box-sizing: content-box; margin-bottom: 5px"
        allowfullscreen> </iframe>
<div style="margin-bottom: 5px">
  <a href="https://slide.rabbit-shocker.org/authors/unasuke/fastly-tech-meetup-vol-1/" title="Fastly Tech Meetup vol.1: QUIC, 103 Early Hints">Fastly Tech Meetup vol.1: QUIC, 103 Early Hints</a>
</div>

At both events, the people I met there greatly influenced my progress this month. Thank you all very much. Perhaps I should make a habit of regularly stepping outside my home.

## quic-ruby (quic gem)
<https://github.com/unasuke/quic-ruby>

At the follow-up event, I was encouraged by someone saying, "Since you've secured a good namespace, you should...", which motivated me to finally address the untouched diffs in my repository. The diff in question was related to distributing the gem as a fat package by adopting LibreSSL as the encryption layer, as ngtcp2 had listed it as "experimental" in their README.

Later, during a conversation with kazuho at the Fastly event, he suggested using [h2o/picotls](https://github.com/h2o/picotls). At that time, one unclear point was whether picotls would function properly when running on systems with LibreSSL instead of OpenSSL (specifically, whether the OpenSSL APIs picotls uses were available in LibreSSL). However, subsequent testing with MCP app revealed that this approach might actually work, so I decided to proceed with this direction.
 In other words, instead of distributing as a fat gem containing both ngtcp2 and LibreSSL, I modified the distribution method to download and install ngtcp2 and picotls at runtime, utilizing the C APIs of either OpenSSL or LibreSSL depending on the execution environment.

<https://github.com/unasuke/quic-ruby/releases/tag/v0.0.2>

## Raiha
This is a Pure Ruby implementation. As previously noted in an issue reported by thekuwayama regarding TLS layer implementation, there were some inefficient aspects in the initial design. While I could use AI to drive the development process and successfully discuss the QUIC protocol, I realized that continuing implementation while carrying over these inefficiencies would be overly challenging, so I decided to thoroughly redesign the architecture.

## My Personal MPC: mcp-coderunner-app
Throughout the extensive design iterations, there were numerous instances where I needed to write code to validate whether the design was reasonable or to determine which approach would perform better in benchmarks. While I could technically use Claude Code on my local machine, when I wanted to do this even on my smartphone while on the go, the terminal interface becomes significantly limited in screen size, making operations noticeably sluggish. Therefore, I developed a Rails application that communicates with MCP. The screenshot at the beginning shows the management interface for this application.

<https://github.com/unasuke/mcp-coderunner-app>

This is a MCP server that allows you to execute arbitrary Dockerfiles and scripts on your home machine via MCP and return the results. While lightweight scripts can be executed directly on Claude.ai, scenarios like wanting to test different language versions, testing in environments with specific libraries, or verifying that external library builds succeed would naturally benefit from offloading these tasks to more powerful resources. Thus, I created this application that combines a lightweight management interface with local docker run workers. Although it's publicly released as OSS, it's strictly for my personal use. Having the code publicly available means I get free CI services and easier deployment...

## I'll be off in October.
Everyone, please come to Kaigi on Rails 2026.

</div>

---

## RubyKaigi 2026 follow upとFastly Tech Meetup vol.1
9月は2つのイベントで喋っていました。(スライド本体は冒頭にて)

どちらのイベントにおいても、そこで話した人達から今月の進捗に多大な影響を貰っています。皆さんありがとうございます。やはりこまめに家の外に出るべきなのかもしれません。

## quic-ruby (quic gem)
<https://github.com/unasuke/quic-ruby>

follow upイベントにて「いい名前空間を抑えてるんだから」という発破をかけられたので、手付かずだった手元のdiffを整えはじめました。そのdiffというのが、ngtcp2がREADMEに "experimental" として記載していたために暗号化層としてLibreSSLを採用することに伴うfat gemとしての配布です。

その後Fastlyのイベントでkazuhoさんと話し、[h2o/picotls](https://github.com/h2o/picotls)を使うアイデアを頂きました。このときはpicotlsを使用した際、動作環境にOpenSSLではなくLibreSSLがある場合にうまいこと動くのか(picotlsが使用しているOpenSSLのAPIがLibreSSLに存在するか)という部分が不明瞭だったのですが、後述するMCPでの検証でどうやらうまくいきそうだということがわかったので、そのように方針転換しました。

つまり、ngtcp2とLibreSSLを同梱したfat gemとして配布するのではなく、実行環境のOpenSSL/LibreSSLのC APIを使用するようにinstall時にngtcp2とpicotlsをダウンロードしてbuildする形式になったということです。

<https://github.com/unasuke/quic-ruby/releases/tag/v0.0.2>

## Raiha
こっちはPure Rubyでの実装です。以前にthekuwayamaさんからTLSレイヤの実装についてissueで報告を受けたことがあるように、初期の設計に非効率な部分がありました。AIに開発をドライブしてもらってQUICプロトコルを話すことはできたものの、それをひきずったまま実装を重ねてもしんどいだけだなと感じていたので、入念に設計しなおすことにしました。

## 自分専用MPC : mcp-coderunner-app
設計をずっと重ねていくうちに、妥当な設計かどうか、ベンチマーク上で有利なのはどちらかなど、確かめるためにコードを書かなければいけないということが多々あります。ローカルマシンのClaude Codeでやればいいのかも知れませんが、移動中のスマートフォンでもやりたいとなるとターミナルの操作は画面も小さいですし、どうしてももたつきます。というわけでMCPを話すRails appを作りました。冒頭のスクリーンショットはこれの管理画面です。

<https://github.com/unasuke/mcp-coderunner-app>

これは、任意のDockerfileと任意のscriptをMCP経由で自宅マシン上で実行し、結果を返すことのできるMCPサーバーです。軽いスクリプトならClaude.ai上で実行できますが、言語のバージョンを色々試したいだとか、特定のライブラリのある環境で試したいだとか、外部ライブラリのビルドが通るか確認したいだとかは、強力なリソースがあればそこにオフロードしてやりたいものです。なので、薄い管理画面とローカルでdocker runをするワーカーの組み合わせからなるアプリを作りました。OSSとして公開してはいるものの、自分専用です。コードがpublicになっているとCIが無料ですし、deployがやりやすいので……

## 10月はお休みです
みなさんKaigi on Rails 2026に来てくださいね。
