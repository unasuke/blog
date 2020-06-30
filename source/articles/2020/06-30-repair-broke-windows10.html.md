---

title: "パソコンが壊れて、直した話"
date: 2020-06-30 23:57 JST
tags: 
- diary
- windows
---


![windows](2020/windows-recover.jpg)

## 前提条件
- ThinkPad T470s
- Windows 10 Home
- WSL2のため、Windows Insider ProgramのFastを有効化

## 起こったこと
<blockquote class="twitter-tweet"><p lang="und" dir="ltr"><a href="https://t.co/Fm7KgLQe77">pic.twitter.com/Fm7KgLQe77</a></p>&mdash; うなすけ (@yu\_suke1994) <a href="https://twitter.com/yu_suke1994/status/1277259344808009735?ref_src=twsrc%5Etfw">June 28, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

まずはこの動画の状況になるまでの出来事を書いていきます。

1. Windows Updateが来ているので実行する
    - 時期的にはこれだろうか？ <https://blogs.windows.com/windowsexperience/2020/06/24/announcing-windows-10-insider-preview-build-20152/>
1. Windows Updateの途中で何度か再起動される
1. 再起動のどこかのタイミングで、「Synaptics ドライバーのアンインストールに失敗しました」というエラーメッセージが出て、そこで止まってしまった
    1. 文言はあやふや、今思えばこの写真を撮っておくべきだった。
1. どのような操作もできないまま固まってしまったので泣く泣く電源ボタン長押しによる中断
    1. 多分これが原因だが、他にどうすればよかったのだろうか。
1. 再度起動すると、「前回のWindows Updateを修復しています」、のようなメッセージが出る
1. ログイン画面に遷移するが、一切の操作ができない状態になる
    1. マウス操作不可能、キー入力不可能
1. 電源ボタン操作で終了、起動し、UEFIメニューから回復オプションに入る
1. システムの復元ポイントからWindows Updateを実行する前の状態に戻すも状況変化せず
1. 「インストールされている Windows Update を削除する」を実行するも状況変化せず
1. 「インストール メディアを使用して PC を復元する」も効果なし
1. 別のマウス、キーボードを接続するも認識せず
1. セーフモードで起動するも状況変化せず
1. セーフモードで起動した結果、UEFIメニューに入れなくなる
    1. 起動直後のキー入力がすっ飛ばされるようになる。これ仕様なの？
1. 詰み……

一度セーフモードに入ると抜けられなくなるというのは結構な絶望感がありました。

## どう直したか
1. セーフモード画面のまま放置して電池が切れるのを待つ
    1. ここで一旦寝る
1. 起動し、UEFIメニューに入れること、回復オプションに入れることを確認
    1. これは賭けだったが、入れてよかった。
1. 「個人用ファイルを保持する」設定で「PC を初期状態に戻す」を実行
1. キー入力を受け付けるようになり、復活！

という流れだったのでした。イチから環境構築をやりなおしになってしまいましたが、ひとまず直ってよかったです。

※ この記事は復旧させたWindowsのWSL上で書かれました。