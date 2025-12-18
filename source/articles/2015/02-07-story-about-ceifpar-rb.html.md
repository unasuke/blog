---
title: Rubyとrmagickでjpegのexif削除、サイズ変更ツールを作った話
date: '2015-02-07'
tags:
- diary
- programming
- ruby
---

## きっかけ

前回記事[TEX Yoda Trackpoint Keyboardを買った](/2015/tex-yoda-trackpoint-keyboard-assembly/)を書くときに、多くの写真を加工することになった。


スマートフォンで撮影した写真には、exif情報として、撮影地の緯度経度などが記録されていることが多い。そういう写真をブログに載せるときは、一応exif情報を削除している。まあ僕の個人情報になんの価値があるかはわからないが、自衛のためだ。



また、クリックした時に画面に収まりきらなくなるほど拡大されることもあるので、リサイズもすることが多い。(それでも前回記事は大きすぎた)



そういうときに使うツールが、jheadとimagemagickだ。jheadでexif情報の削除を行い、imagemagickで画像のリサイズをする。(imagemagick単体でもexifの削除はできる)
```shell
$ jhead -purejpeg hoge.jpeg                      #exif情報の削除
$ convert -geometry 50% hoge.jpeg smallhoge.jpeg #画像を半分の大きさに縮小

#imagemagickのみの場合
$ convert -geometry 50% -strip hoge.jpeg smallhoge.jpeg
```

で、なにを思ったか、これをRubyで書いてみようと思った。


## ceifpar.rb

[unasuke/ceifpar](https://github.com/unasuke/ceifpar)

```ruby
#!/usr/bin/ruby
#ceifpar
#conceal(clear) exif info from photo and resize it.

require 'optparse'
#require 'rugygems'
require 'rmagick'
#require 'mimemagic'

def is_jpeg? filepath
  if File.extname(filepath).downcase =~ /jpe?g/ then
    return true
  else
    return false
  end
end

#example for resize ratio format
# "1/2" , "0.5" , "50%" -> 0.5
def normalize_ratio str
  #fraction
  if str.include?("/") then
    rat = str.partition("/")
    ratio = Rational(rat[0].to_f , rat[2].to_f).to_f
  #percent
  elsif str.include?("%") then
    ratio = str.to_f / 100
  #decimal
  else
    ratio = str.to_f
  end
  return ratio
end

params = ARGV.getopts('r:')
ARGV.each{ |arg|
  if is_jpeg?(arg) then
    #open image
    img = Magick::ImageList.new(arg)

    #resize image
    img.resize!(normalize_ratio(params["r"])) unless params["r"] == nil

    #delete exif
    img.strip!

    #output image
    dst = File.basename(arg)
    dst[/\./] = "-dst."
    img.write(dst)

  else
    warn "#{arg} is not jpeg image."
  end
}

warn "No input image." if ARGV.size == 0
```


動作には、imagemagickとrmagickが必要となる。


### つかいかた


事前にimagemagickとrmagickのインストールをしておく必要がある。

```shell
#exif情報を削除し、画像を半分の大きさにリサイズ
$ ruby ceifpar.rb -r 1/2 hoge.jpg
$ ruby ceifpar.rb -r 0.5 hoge.jpg
$ ruby ceifpar.rb -r 50% hoge.jpg

#exif情報の削除のみを行う
$ ruby ceifpar.rb hoge.jpg
```

-rオプションに続く小数、分数、パーセントに応じてリサイズする。-rオプションがない場合は、exif情報の削除のみを行う。出力画像はカレントディレクトリに元ファイル名-dst.jpgという名前で保存される。


## つくってみて

まあこんなもんはどこの誰もが考えることで、そもそもshell scriptで書けば一番手っ取り早いし、同じことをするプログラムなんてものはもう既に世の中に数えきれないほどある。いわば、ただの車輪の再発明だ。



それでも作った理由は、まず1つが「勉強になるから」である。Rubyを書いた経験は短いので、とにかく色々なものを作って、文法を体で覚えたり、解決策がどこにあるのかを見つけることが大事だ。このプログラムを書くのに、Rubyの公式リファレンス、RMagickの公式リファレンス、その他いろんなブログを見て回った。



2つ目が、「自分に合うものを作りたい」である。そうやっていろんな人が作った世に出回っているツールのやり方が、自分には合わないことが多い。いちいち-purejpgなんていうオプションを覚えたくないし、むやみにソフトウェアをインストールするのもあまり好まない。この程度の作業なら、自分で作ってしまえば動作は隅から隅まで把握しているし精神衛生上よい。



そもそも車輪の再発明とか言ったら、プログラミングの練習課題として出される素数判定とかはどうなんだと思う。あんなのわざわざ実装しなくたって素数判定メソッドとかあるし、全く無駄だということになる。俺が1年生の時に素数判定のプログラムで悩んだ数ヶ月はまったくの無駄なんだ。あの数ヶ月を返せ。


## これから


とりあえずREADMEを書きたい。あとは出力先ディレクトリ、名前指定とかだろうか。まあでも、自分しか使わないだろうしこのままでもいい気がしないでもない。
