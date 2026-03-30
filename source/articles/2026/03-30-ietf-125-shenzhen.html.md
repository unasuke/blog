---
title: "IETF 125 Shenzhenの個人的まとめと、そのためのMCPサーバー"
date: 2026-03-30 22:40 +0900
tags: 
- ietf
- quic
- tls
- httpbis
- masque
- ccwg
- moq
- tiptop
- happy
- scone
- rails
---

![](2026/ietf-125-shenzhen.png)


## IETF 125

<https://datatracker.ietf.org/meeting/125/proceedings>

IETF 125は2026年3月16日〜20日に中国・深圳で開催されました。例によって以下は個人的な感想を無責任に書き散らかしたものです。内容の誤りなどについては責任を取りませんし、なんなら今回はAIによって生成したものです。

---------

以下AIによるまとめです。

## ccwg

### Agenda

* <https://datatracker.ietf.org/meeting/125/session/ccwg>

かなり詰め込んだアジェンダだった。ICCRGが今回開催されなかったこともあり、一部ICCRGっぽい発表も含まれていた。ICCRG はIETF 126で開催される見込み。

### Rate Limited

WGLCの最中およびその後にいくつかの非自明な変更があったため、最新版を確認してほしいというcall to action。スライドなし。

### BBRv3

* <https://datatracker.ietf.org/doc/draft-ietf-ccwg-bbr/>

引き続き順調に進展中。ペーシングテキストの改善、SACが利用できない場合の動作規定、drainに3RTT以上留まった場合のexit条件追加などのロジック更新が入った。TCP固有の記述の除去もほぼ完了。テストケースのPRはIanが作成中。BBRv3とCubicの共存性に関する論文（"Promises and Potential of BBRv3"）が話題に上がり、共存性がv2より若干悪化するケースがあることを著者側も認識しているとのこと。Mozillaからは「実装はまだ開始していないが、ドキュメントの品質が実装可能なレベルに近づいてきている」とのコメントがあった。

### SCReAMv2

* <https://datatracker.ietf.org/doc/draft-johansson-ccwg-rfc8298bis-screamv2/>

メディア向け輻輳制御アルゴリズム。-07版に更新された。ネットワーク輻輳制御とメディアレート制御の両方を扱う必要があるという著者の立場は変わらず。新たにqueue delay deviation normという指標を導入し、輻輳状態での参照ウィンドウオーバーヘッドを適応的に制御する仕組みが入った。Chrome CanaryにWebRTC実装が入っており、コマンドラインで有効化して試せる。EricssonはSCReAMを5G製品で利用しており、ドイツの自動運転レンタカー企業WAYでも採用されている。GoogleからもWebRTCの標準輻輳制御としてL4Sとの組み合わせで検討中との発言があった。WGアイテムとしての採用についてshow of handsが行われ、興味ありの方向。

### Rapid Start

kazuhoさんの発表。CDNにおけるスロースタートの3つの問題（半RTTのアイドル期間、2x成長の遅さ、輻輳終了時のバンピーな挙動）に対して、full RTT pacing、3x成長、そしてスムーズな輻輳ウィンドウ収束の3つを組み合わせた手法。輻輳検知時のウィンドウ削減ではsilence factor、ack factor、loss factorの3つのパラメータを使って、3xオーバーシュート時でも正しい送信レートにスムーズに着地するようにしている。本番データで全体14.7%のTTLB削減、地域別では10.8%〜21.5%の改善が報告された。パケットロス率はP50で若干増加するがP99ではslow startとの差が縮まる。BBRとの関係やTCPへの適用可能性（Neilは「Linuxのtcpは必要なデータポイントを持っている」と回答）についても議論があり、Mozillaのlarsがプラガブルなスロースタートフレームワークでの実装とA/Bテストを計画中とのこと。

### C4 (Christian's Congestion Control Code)

* <https://datatracker.ietf.org/doc/draft-huitema-ccwg-c4-design/>

Christian Huitemaによる動画向け輻輳制御アルゴリズムの詳細な発表。ECN、遅延、パケットロスレート、データレートの4つの輻輳シグナルを使い、initial → recovery → cruising → pushingの4フェーズで動作する。MIMD（Multiplicative Increase Multiplicative Decrease）の公平性問題に対して、データレートに応じたsensitivity curveを導入し、低帯域の接続は輻輳時にあまり後退せず、高帯域の接続はより大きく後退することで公平性へ収束させる仕組み。C4同士では良好な公平性を示すがCubicに対してはCubicが1/3程度しか帯域を取れないケースも。Lars（Mozilla）から「学術的なピアレビューを先に受けるべき」というコメントがあった。CiscoのSuhasがMoQスタック内でC4を実装中で、Wi-Fiのロス・ジッター環境での改善が見られるとのこと。

### LEO衛星ネットワークにおける輻輳制御

清華大学からの発表。LEO衛星の軌道移動に伴う15秒間隔のリコンバージェンスがパス特性を急変させ、既存の輻輳制御が非輻輳性のロスやRTT変動を輻輳と誤認する問題を分析。パスをpath-phase boundary（PPB）で区切られた一連のボトルネックレジームとして捉えるモデルを提案した。時間切れで議論は限定的だったが、トランスポート層でのパス変化シグナリングの必要性を提起。

## webtrans

### Agenda

* <https://datatracker.ietf.org/meeting/125/session/webtrans>

3つのドキュメントすべてについてWorking Group Last Call（WGLC）が進行中。

### W3C WebTransport Update

* <https://w3c.github.io/webtransport/>

Working Draftの最新版が2026年2月に公開され、Candidate Recommendationマイルストーンは100%完了。Fetch APIとの統合、接続統計情報の追加、CSP改善など多くの技術的変更が入った。WebTransportがInterop 2026のフォーカスエリアとして採択されたのは好材料だが、SafariのWebTransport対応はまだ0.0%。

### draft-ietf-webtrans-overview-12 / draft-ietf-webtrans-http3-15 / draft-ietf-webtrans-http2-14

* <https://datatracker.ietf.org/doc/draft-ietf-webtrans-overview/>
* <https://datatracker.ietf.org/doc/draft-ietf-webtrans-http3/>
* <https://datatracker.ietf.org/doc/draft-ietf-webtrans-http2/>

overview-12はエディトリアルな変更のみでオープンissueゼロ。webtrans-http3-15ではWT_MAX_SESSIONSがWT_ENABLEDに置き換わり、新エラーコード（WT_ALPN_ERROR、WT_REQUIREMENTS_NOT_MET）が追加された。webtrans-http2-14ではSETTINGS_WT_INITIAL_MAX_STREAM_DATA_BIDIがQUIC方式に合わせてLOCALとREMOTEに分離された。

### ステータスコード問題 (#256)

リソースは存在するがWebTransportをサポートしない場合に返すHTTPステータスコードについて活発な議論。404、405、406、426、400、新規コードなど候補が挙がったがどれも完全にはフィットせず、HTTP Directorateとの協議を経て決定する方針に。Ben Schwartzが提案した「problem type」アプローチのスケッチを作成予定。

### WebTransport Interop Runner

* <https://interop.seemann.io/webtransport>

QUICのInterop Runnerを拡張したWebTransport用のInteropテストツール。Chrome、Firefox、webtransport-go、flupke-webtransportの4実装が参加し、12時間ごとにCIで自動実行されている。

## tls

### Agenda

* <https://datatracker.ietf.org/meeting/125/session/tls>

今回も2回構成。ECH関連のRFC 9847〜9853が正式公開された。

### ML-DSA in TLS 1.3

* <https://datatracker.ietf.org/doc/draft-ietf-tls-mldsa/>

FIPS 204で定義された3つのML-DSAサイズをTLS 1.3のコードポイントとして登録するシンプルなドラフト。TLS 1.2での使用は禁止。WGLCの前にTLS 1.2との技術的境界に関するテキストの解決が必要。

### TLS PAKE

* <https://datatracker.ietf.org/doc/draft-ietf-tls-pake/>

パスワード認証鍵交換のTLS 1.3拡張仕様。CPACEの使用仕様が追加された新バージョン01が公開済み。WGLCの前にProVerif等の形式解析の結果が必要となる可能性が高い。

### ML-KEM for TLS 1.3

* <https://datatracker.ietf.org/doc/draft-ietf-tls-mlkem/>

ポスト量子暗号ML-KEMを単独（ハイブリッドなし）の鍵合意として利用する仕様。2回目のWGLC後も鍵再利用テキスト、ハイブリッド選好理由、モチベーションセクションの3点が未解決で、これらの変更後にターゲットコンセンサスコールを実施予定。ハイブリッドから純粋ML-KEMへの移行が「セキュリティの劣化」かどうかで意見が割れている。

### PQC Continuity

* <https://datatracker.ietf.org/doc/draft-sheffer-tls-pqc-continuity/>

PQCへの移行期間におけるダウングレード攻撃からの保護のためのTOFU型の仕組み。HSTSのTLSレイヤー版に相当するが、実装に興味ある人がまだおらず時期尚早という雰囲気。

### Extended Key Update (EKU)

* <https://datatracker.ietf.org/doc/draft-ietf-tls-extended-key-update/>

金曜セッションで最も長い時間が割かれたトピック。Tom DowlingによるFATの分析結果報告が約30分。transcript hashの問題は修正済みだが、セッションチケットの問題やPost-Compromise Securityの証明など課題が残る。rustlsとmbedTLSの2つのプロトタイプ実装が存在し、相互運用も確認されている。

### TLS 1.3ハンドシェイクの64K制限超え

* <https://datatracker.ietf.org/doc/draft-wagner-tls-keysharepqc/>

一部のPQ KEMの公開鍵がkey_shareに収まらない可能性に対する3つの提案の比較。Eric Rescorlaが「実際の動機（巨大PQアルゴリズム）がまだ存在しない。WGの時間を使うべきではない」と明確に反対し、作業を支持する参加者はいなかった。

### ECH計測報告

Tranco上位10,000ドメインでのテストで、HTTPSリソースレコードは60%のケースでHappy Eyeballs V2ベースラインと同等以上の速度。ECH GREASEではコネクティビティの破壊は確認されなかった。米国.govドメインの一部がHTTPSリソースレコードに応答しない問題が報告されている。

### Signed ECH Configs

* <https://datatracker.ietf.org/doc/draft-sullivan-tls-signed-ech-updates/>

署名用公開鍵のハッシュをDNSレコードに格納し、リトライ時にサーバーが署名した新ECH configで認証する提案。外部SNIにランダム文字列を使用可能になり、CaddyなどがECHをデフォルト有効化できるようになる。raw public keysベースのアプローチに絞る方向で簡素化予定。

## httpbis

### Agenda

* <https://datatracker.ietf.org/meeting/125/session/httpbis>

### HTTP Redirect Headers

OAuthなどの認証プロトコルでURLクエリ文字列を通じて機密パラメータが漏洩する問題に対して、Redirect-Query、Redirect-Origin、Redirect-Pathの3つの新ヘッダを提案。しかしMartin Thompsonが「ビットを別の場所に動かしているだけ」と批判し、採用の議論には至らず。

### HTTP Signature-Key Header

HTTP Message Signatures（RFC 9421）の鍵配布方法として新しいSignature-Keyヘッダを提案。hwk、jwks_uri、jwt、x509の4スキームに加え、ハードウェアセキュアエンクレーブ向けのjkt-jwtも定義。Martin Thompsonは「複雑すぎる」と評価し、これも採用の議論には至らず。

### The Preliminary Request Denied HTTP Status Code

* <https://datatracker.ietf.org/doc/draft-nottingham-httpbis-pre-denied-00/>

プリフェッチリクエストをサーバーが拒否する場合に503を使うと運用担当者がパニックになる問題への対処として、新しい4xxステータスコードを提案。全面的に肯定的な反応で、反対意見なし。Chairsから採用コールを開始するとのこと。

### Unbound DATA for CONNECT in HTTP/3

* <https://datatracker.ietf.org/doc/draft-rosomakho-httpbis-h3-unbound-data/>

CONNECTのようにトレーラーを使わないストリームでDATAフレームのオーバーヘッドを削除する提案。前回は汎用的だったがCONNECTのみに限定して再提出された。Ben Schwartzも「問題ないと思う」と立場を変え、WGから肯定的な反応。

### CONNECT-TCP

* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-connect-tcp/>

IETF 123以降の実質的な変更は1点のみ。Proxy Statusトレーラーの送信に関するRFC 9114との矛盾が発見されたが、「今はドラフトからトレーラーテキストを削除して終了、将来必要になればcapsuleで対応」でコンセンサス。

### Resumable Uploads for HTTP

* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-resumable-upload/>

クライアントリトライ動作のガイダンス、早期レスポンス、失われたレスポンスの回復の3つの課題が議論された。AppleプラットフォームはすでにResumable Uploadsバージョン6をサポート中で、夏までの完了が目標。

### The HTTP Wrap Up Capsule

* <https://datatracker.ietf.org/doc/draft-ietf-httpbis-wrap-up/>

進捗が停滞していたが、Yaroslav Rosomakohoが実装とエディトリアル作業を引き受ける意思を表明。WebTransportには概念的に同じcapsuleの実装がすでに存在することも判明。ウィーン（IETF 126）までに実装を完了しWGLCを進める方向。

### MOQPACK

Alan Frindell（Meta）がMoQ Transport上の圧縮技術を発表。Martin Thompsonは「QPACKから再利用すべき核心は、動的に進化するストリーム間で状態を安全に参照する方法」と助言し、QPACKを文字通りではなく精神的に再利用すべきとした。Huffmanエンコーディングは削除が妥当との結論。

## happy

### Agenda

* <https://datatracker.ietf.org/meeting/125/session/happy>

### Happy Eyeballs v3

* <https://datatracker.ietf.org/doc/draft-ietf-happy-happyeyeballs-v3/>

-03ではTLSハンドシェイク待機のSHOULD強化、SVCB/HTTPSレコード対応、MTU考慮事項などが更新された。Jen LinkovaによるIPv6-onlyネットワーク対応セクションの書き換え（PvD概念の導入）やBen Schwartzによるドキュメント構造の再編も議論された。HEv2が広く実装されなかった理由としてレイヤー化アーキテクチャの問題が挙げられ、HEv3はDNSとTLSの統合が必要で実装のハードルが高い。

### HEv3 in Firefox

Firefox NightlyでHEv3が利用可能になり、`about:config`で有効化できる。Rustで実装された独立ライブラリ（mozilla/happy-eyeballs）がGitHubで公開されている。数週間以内にFirefox Nightlyでデフォルト有効化予定で、IETF 126でテレメトリを共有予定。

### Slow Alternate Detection (SAD)

* <https://datatracker.ietf.org/doc/draft-trammell-happy-sad/>

HEのクライアントのパス選択結果がサーバー側から見えない問題に対し、ICMPの新メッセージタイプで非選択パスにシグナルを送る提案。ネットワーク診断としての発見可能性に利点があるが、コンシューマOSのユーザースペースからICMP送信が困難という実現可能性の問題が最大の課題。

## quic

### Agenda

* <https://datatracker.ietf.org/meeting/125/session/quic>

チェアのLucas PardudeとMatt Jorasは両名リモート参加。時差の関係で通常より短い1時間セッション。

### WGドキュメントステータス

draft-ietf-quic-multipathはIESGバロットに進んでおり、差し戻しなしの見通し。ack-frequencyとreliable-stream-resetはShepherd writeupが必要な段階で、IETF 126までに進展させる予定。qlogはIETF 126前にバーチャルinterimを開催して残課題を処理する計画。receive-tsの-02が公開済みで今が実装・実験の好機。

### QMux (draft-ietf-quic-qmux-00)

* <https://datatracker.ietf.org/doc/draft-ietf-quic-qmux/>

新規WGドキュメントとなったQMuxに大部分のセッション時間が費やされた。レコードレイヤーの導入（PR #26）、フロー制御のデッドロックリスク対処（PR #27）、ALPNの扱い（PR #33）、Transport ParametersのTLSハンドシェイク組み込み（PR #28）、暗黙的ACKとPing（PR #23）、MPTCP対応（PR #29）など13件のオープンイシューが議論された。QUICとの差異を最小に保つ方針で、STREAMフレームからoffsetフィールドは削除しない。

### MoQT over QMux

MoQTをQMux上で動作させる際のALPN設計について3つのオプションが議論された。CullenとSuhasがオフラインで詳細を詰めてMoQ WGにフィードバックする方向。

### Calibrating Minimum RTT Under Low ACK Frequency

ACK頻度を下げるとminimum RTT推定にバイアスが生じる問題を、受信側でのone-way delay計算で対処する提案。Christian Huitemaが自身のタイムスタンプドラフトへの統合を提案し、WG採用済みのquic-receive-timestampsドラフトとの統合が推奨された。

### Explicit Measurement Techniques for QUIC

RFC 9506の明示的測定ビットをQUICにマッピングする提案。SCONEモデルに倣いlong headerパケットを使う方式。Ted Hardyが採用検討の前にフルBOFが必要と強調。

## masque

### Agenda

* <https://datatracker.ietf.org/meeting/125/session/masque>

チェアのDennis JacksonとMarten Seemannはともにリモート参加。

### WGステータス

connect-ethernetとconnect-udp-listenはADに転送しIESGへ。quic-proxyはExperimentalからStandards Trackに変更し2回目のWGLCを実施予定。connect-udp-ecn-dscpとconnect-ip-optimizationsについてメーリングリストでアダプションコール予定。リチャーター後にdraft-schinazi-masque-proxyのアダプションが可能に。

### HTTP Datagram Compression

* <https://datatracker.ietf.org/doc/draft-rosomakho-masque-connect-ip-optimizations/>

テンプレートによる静的セグメント除去、Derived Fields（導出フィールド）、TCP/UDPチェックサムオフロードの3つのスタック可能なメカニズムを提案。チェックサムで約5%のCPU節約、性能が11→12 Gbit/sに向上というデータも。David Schinazi含め採択を支持する声が多い。

### The MASQUE Architecture

* <https://datatracker.ietf.org/doc/draft-schinazi-masque-proxy/>

MASQUEの歴史、アーキテクチャ原則、プライバシー特性をまとめた文書。ドラフト名を「Proxy」から「Architecture」に変更予定。「MASQUEを使え」と言われても現在のRFC群との関連がわからない問題を解決するもの。リチャーター後にアダプション。

### ECN and DSCP support for Connect-UDP

* <https://datatracker.ietf.org/doc/draft-westerlund-masque-connect-udp-ecn-dscp/>

ドラフトを完全に書き直し、単一の統合拡張に再設計。Context IDにECNとDSCPの値をバインドすることでパケットあたりのオーバーヘッドをゼロにする方式。メーリングリストでアダプションコール予定。

## moq

### Agenda

* <https://datatracker.ietf.org/meeting/125/session/moq>

全3枠で非常に盛りだくさん。MoQに関しては相変わらず情報量が多い。

### MOQTアップデート

* <https://datatracker.ietf.org/doc/draft-ietf-moq-transport/>

draft-15からdraft-17でAlan Frindell自身が「ほぼ完全に新しいプロトコルのよう」と表現するほどの大改訂。単一の制御ストリームを廃止しリクエストごとに独自のbidiストリームを使用する形に変更、独自varint（VI64）の導入、Track/Object Propertiesの整理、Greaseの全面導入など。イシューは現在98件で、IETF 126後にイシューゼロを目指す。

### moqt:// URLスキーム

`moqt://`はALPNでトランスポートを決定する仕組み。+q/+wtサフィックスはほぼすべてのケースで不要であることが実証され、強いコンセンサスにより削除が決定。

### Secure Objects

* <https://datatracker.ietf.org/doc/draft-ietf-moq-secure-objects/>

エンドツーエンド暗号化を提供するWGドラフト。鍵をtrack namespaceではなくtrack nameにバインドすべきという変更が合意された。Track Propertiesの保護については複数の選択肢が議論されたが結論は出ず。

### Dynamic Track Switching

サーバーサイド/リレーサイドABRの設計。クライアントがトラックをセットに登録し、リレーがスループット推定に基づきグループ境界で切り替え判断する仕組み。コアMOQTに入れるべきという意見が出つつ、ドラフト開発を継続して準備ができたら決定する方向。

### MOQ Production at Alibaba

AlibabaがMOQを音声検索、クラウドレンダリング、AIアシスタントなどに実デプロイしている報告。WebSocket比で接続レイテンシ75%減、WebRTC比で初フレームレイテンシ50%以上削減などの性能データが共有された。マルチモーダルフィードバックドラフトも提案。

### MOQT over QMUX

UDP/QUICがブロックされる環境向けのTCPフォールバック。bidiストリーム、ユニストリーム、フロー制御パラメータが直接対応し、アプリケーションコード変更不要。ALPNの扱いはQUIC WGとの共同議論に。

### その他の決定事項

Varint最小エンコーディングの要件はSHOUL維持（MUSTではない）。可変長整数型の名称はVI64に決定。ロンドンinterimでのインターロップターゲットはDraft 18。

## scone

### Agenda

* <https://datatracker.ietf.org/meeting/125/session/scone>

### プロトコルステータス

* <https://datatracker.ietf.org/doc/draft-ietf-scone-protocol/>

WGLCを通過済みで、実装の過程で見つかった小さな問題に対応中。同一UDPデータグラム内の複数SCONEパケット処理に関するPR144が追加された。MozillaではFirefoxでSCONEパケットの受信・処理を可能にする作業を開始予定。ウィーン（IETF 126）までにクローズしてshipする方向で強いコンセンサス。

### Applicability & Manageability

* <https://datatracker.ietf.org/doc/draft-ietf-scone-applicability-manageability/>

L4Sとの関係、ユースケース、測定方法論、エンフォースメントなどの追加が期待されている。3GPP Release 20へのSCONE取り込みが17社の支持を得て合意されており、IETFでの進行速度が3GPPのスケジュールに影響する。4月末〜5月初旬にinterim会議を開催予定。

### Wi-Fiアプリカビリティ

Sri Gundavelli（Cisco）がIEEE 802.11アクセスネットワークへのSCONE適用に関する個人ドラフトを紹介。WBAでレビュー済みだが、IETFで行うべきかIEEEで行うべきかの議論がある。

### MASQUE連携・Explicit Measurement

MASQUEプロキシは既存SCONEアーキテクチャ上ネットワークエレメントとして機能しうるため、まず既存シグナリングで検証する方向。SCONEに着想を得たQUICの明示的測定技術も発表されたが、関心があればBoF開催を検討すべきとの位置づけ。

## tiptop

### Agenda

* <https://datatracker.ietf.org/meeting/125/session/tiptop>

### ユースケース文書

* <https://datatracker.ietf.org/doc/draft-ietf-tiptop-usecase/>

用語追加（ラグランジュポイント等）、エネルギー制約・位置情報の記述追加、セキュリティ考慮事項の拡充が行われた。PQCに関してはEric Rescorlaがハイブリッド鍵確立は実施すべきだがPQ認証は帯域幅特性の問題がありより難しいと詳細な見解を述べた。グループ鍵、前方秘匿性、非同期鍵更新の3つのセキュリティ関連PRはまだコンセンサスに至っていない。

### IPアーキテクチャ文書

* <https://datatracker.ietf.org/doc/draft-many-tiptop-ip-architecture/>

WG adoption投票が実施され、Yes 14、No 2、No Opinion 7でラフコンセンサスが得られた。-03版ではQUICを暗黙のデフォルトから一例に変更し、要件・制約フォーカスの記述に改善。Eric Rescorlaはゲートウェイでのコンテンツキャッシュについて「TLSは従来のHTTPキャッシングを破壊する」と根本的な設計問題を警告した。

### 深宇宙向けQUIC最適化

南京大学から、固定輻輳制御ウィンドウ＋積極的FECでRTTに依存しない回復を実現するQUICSpace拡張と、明示的認可分割によるNon-Transparent Secure Proxyの提案。AD Eric Vynckeがトランスポートプロトコルの修正はTIPTOPのチャーター外と指摘し、SPACE RGを紹介。

### 宇宙用IPアドレス空間

Tony Liが宇宙用IPアドレス空間についてRIRとの交渉状況を報告。IANAに大きなIPv6ブロックを確保する方法が提案されたが、NRO NCとの多者間交渉が必要で難航中。アーキテクチャ文書とは別文書として扱う方向。

---------

AIによるまとめがここまで。

## MCPサーバーを作った
というわけで、AIによってまとめを生成してもらったわけですが、そもそもAI agentはdatatracker上のリソースに直接アクセスすることはできません。

![claude.aiでslides-124-quic-new-preferred-addressの内容が取得できなかった様子](2026/ietf-125-claude-cannot-fetch-datatracker-slide.png)

これまでも、Agendaやスライドは手元にダウンロードしてClaudeのプロジェクトファイルとして内容を要約してもらっていたのですが、それを行う手間を削減するため、またAI agentが直接datatracker上のリソースを取得できるようにするため、MCPサーバーを実装しました。

* <https://draft-chamber.unasuke.dev>
* <https://github.com/unasuke/draft-chamber>

![draft-chamber.unasuke.devのLP](2026/ietf-125-draft-chamber.png)


Internet-Draft(など)を取得するので、Draft chamber(和製英語)です。実際は上のまとめは簡略化してもらったもので、フルで出力させると以下のようなMarkdownを生成することができます。

<https://claude.ai/public/artifacts/12dc22ba-57de-44ce-b39f-e45c98242687>

<iframe src="https://claude.site/public/artifacts/12dc22ba-57de-44ce-b39f-e45c98242687/embed" title="Claude Artifact" width="100%" height="600" frameborder="0" allow="clipboard-write" allowfullscreen></iframe>

技術スタックとしては、Rails、Kamal、AWS Lightsail、Amazon S3、SQLite、Solid Queue、Solid Cache、MCPなどなどを使用しています。特にMCPは、koicさんがメンテナのひとりをつとめている <https://github.com/modelcontextprotocol/ruby-sdk> を使ってみたかったということもあってMCPサーバーとして作ろうと思った、という動機もあったりします。

Lightsailの二番目に安いプランで動かしているのでたくさんの人に使用されると厳しいかもしれませんが(そのためにGitHub認証を付けています)、気になる方は使ってみて感想やpull requestを送ってもらえればと思います。
