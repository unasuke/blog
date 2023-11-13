---
title: "AquaSKKで全角の？や！を入力したい2022"
date: 2022-08-29 0:40 JST
tags:
- skk
- mac
---

![](2022/aquaskk-hiragana-mode.png)

これは自分用備忘録です。

## 方法
1. `/Library/Input Methods/AquaSKK.app/Contents/Resource/kana-rule.conf` を `~/Library/Application Support/AquaSKK/kana-rule.conf` にコピーする
2. `~/Library/Application Support/AquaSKK/kana-rule.conf` の末尾に以下を追記する (~~EUC-JP~~ EUC-JIS-2004であることに注意)

```
!,！,！,!
?,？,？,?
```

### 参考
- [AquaSKK プロジェクト::フォルダとファイル](https://aquaskk.osdn.jp/folders_and_files.html)
- [AquaSKKの各変換モードで入力できる記号を設定する - ぬいぐるみライフ？](https://mickey24.hatenablog.com/entry/20081112/1226454977)

## 余談 歴史を紐解く
元記事で書かれている `~/Library/AquaSKK/kana-rule-list` とは何で、現在はどうなっているのでしょうか。調べてみました。

※ 以下記述はインターネット上の記述から僕が理解した内容で、憶測を含むため間違いが含まれている可能性が大です。当時を知っていて間違いに気付いた方は正しい歴史を教えてください……

まず当初、AquaSKKはText Services Manager[^tsm]を利用したソフトウェアで、この時点での設定ファイルは `~/Library/AquaSKK` に置く[^tsm-confdir]ようになっていました。

後にMac OS X 10.5 (Leopard)で導入されたInputMethodKit[^imk] (以下IMK)を使った実装では、設定ファイルは `~/Library/Application Support/AquaSKK/` に置く[^ikm-confdir]ようになりました。

冒頭で言及した記事が書かれたのは2008年11月12日ですが、AquaSKKのIMK対応が開始されたのが2007年12月15日、IMK対応のコードがSVNリポジトリにコミットされたのが2008年6月26日です。(以下ChangeLogより)

<https://ja.osdn.net/projects/aquaskk/scm/svn/blobs/head/aquaskk/trunk/ChangeLog>

そして、IMK版対応の中で、2008年8月3日に移行スクリプトが作成され、この内容から `~/Library/AquaSKK/kana-rule-list` に書いていた内容は  `~/Library/Application Support/AquaSKK/kana-rule.conf` に書くようになったことが推測できます。

<https://ja.osdn.net/projects/aquaskk/scm/svn/commits/15>

この移行スクリプトは2015年に削除されました。

<https://github.com/codefirst/aquaskk/commit/da2ad5c264e7d9b91c4c9c4e015cb2db8a2a87c5>


[^tsm]: <https://web.archive.org/web/20040407002805/http://developer.apple.com:80/documentation/Carbon/Conceptual/UnderstandTextInput_TSM/index.html>
[^tsm-confdir]: <https://moch-lite.hatenadiary.org/entry/20090116/p1> の 「TSM版の設定ファイルは以下にあります。」より
[^imk]: <https://developer.apple.com/documentation/inputmethodkit>
[^ikm-confdir]: <https://moch-lite.hatenadiary.org/entry/20090116/p1> の 「Imk版の設定ファイルは以下になります。」より

<https://ja.osdn.net/projects/sourceforge/wiki/potm_0811_AquaSKK>

## 更新履歴
* 2023-11-13 `kana-rule.conf` の文字コードについて訂正
  * <https://twitter.com/tobetchi/status/1722908547045019681>
