---
title: 'Middlemanで生成したHTMLの&lt;img&gt;にloading="lazy"を付与するgemを作りました'
date: 2019-11-29 18:37 JST
tags: 
- ruby
- gem
- middleman
- programming

---

![performance](2019/lazy-loading.png)

ChromeがNative lazy loadingをサポートするようになったので、僕のblogでもこれを使おうと作ってみたgemになります。

## Markdownの変換に介入する
Chrome v76から、Native lazy loadingがサポートされるようになりました。

[Native lazy-loading for the web](https://web.dev/native-lazy-loading/)

ところで僕のblogは、本文をMarkdownで記述したものをHTMLに変換しています。Markdown記法で画像を挿入した場合に、どのようにloading属性を付与すればいいのでしょうか。Markdown内にHTMLを記述した場合、それはそのまま出力されるので、手で<img>タグを書くことで実現できますが、果たしてそのようなことをしたいでしょうか。面倒です。

なので、Markdownの変換過程に介入することで解決できないだろうかと思い、調べてみました。

僕のblogでは、Markdown engineとしてRedcarpet gemを使用しています。そして、RedcarpetにはCustom Rendererという仕組みがあります。これで、`![alt text](src)` の変換に介入します。

[Railsでカスタムmarkdownを実装する - k0kubun's blog](https://k0kubun.hatenablog.com/entry/2013/09/19/223400)

```ruby
class CustomRenderer < ::Redcarpet::Render::HTML
  def image(link, title, alt_text)
    "<img loading=\"lazy\" src=\"#{link}\" alt=\"#{alt_text}\" />"
  end
end
```

上記のようなコードで、<img> に loading attrを付与することができます。そして、それをgemにしたのがこれです。

- <https://github.com/unasuke/redcarpet-render-html_lazy_img>
- <https://rubygems.org/gems/redcarpet-render-html_lazy_img>

実際には loading 属性には lazyの他にも autoとeagerを指定できるので、gemでもRendererをそれぞれ使い分けることでlazy以外を指定できます。
(なのでgem名にlazyと入れたのはちょっと失敗だったかもしれない)

ここまでが表参道.rb #51 での発表内容になります。

<iframe src="https://slide.rabbit-shocker.org/authors/unasuke/omotesandorb-51/viewer.html"
        width="320" height="285"
        frameborder="0"
        marginwidth="0"
        marginheight="0"
        scrolling="no"
        style="border: 1px solid #ccc; border-width: 1px 1px 0; margin-bottom: 5px"
        allowfullscreen> </iframe>
<div style="margin-bottom: 5px">
  <a href="https://slide.rabbit-shocker.org/authors/unasuke/omotesandorb-51/" title="omotesandorb #51">omotesandorb #51</a>
</div>

## 生成されたHTMLを改変する
ところで、この手法は上手くいきませんでした。実際にこのgemを使用してblogをdeployすると、画像が全てリンク切れとなってしまったので、急いでrevertしてdeployをし直しました。

この原因は、Middleman側の設定である `asset_hash` を有効にしていたためです。この設定によって尊重されるべきMiddleman側のCustom Rendererを自分のgemで上書いてしまっていたために、画像のsrcが正しくないものになってしまっていました。

`asset_hash` を有効にしたまま `loading="lazy"` をするには、もう変換後のHTMLを編集するMIddleman pluginを作成するしかなさそうです。

という訳で、`after_build` のタイミングで以下のようなコードを実行するようなgemを作成しました。

```ruby
def after_build(builder)
  files = Dir.glob(File.join(app.config[:build_dir], "**", "*.html"))
  files.each do |file|
    contents = File.read(file)
    replaced = contents.gsub(%r[<img], "<img loading=\"#{options[:loading]}\"")
    File.open(file, 'w') do |f|
      f.write replaced
    end
  end
end
```

このコードは、build directory 以下に存在する `.html` ファイルについて、全ての `<img>` タグに対して loading 属性を付けて上書き保存します。

- <https://github.com/unasuke/middleman-img_loading_attribute>
- <https://rubygems.org/gems/middleman-img_loading_attribute>

ここまでが表参道.rb #52 での発表内容になります。

<iframe src="https://slide.rabbit-shocker.org/authors/unasuke/omotesandorb-52/viewer.html"
        width="320" height="285"
        frameborder="0"
        marginwidth="0"
        marginheight="0"
        scrolling="no"
        style="border: 1px solid #ccc; border-width: 1px 1px 0; margin-bottom: 5px"
        allowfullscreen> </iframe>
<div style="margin-bottom: 5px">
  <a href="https://slide.rabbit-shocker.org/authors/unasuke/omotesandorb-52/" title="omotesandorb #52">omotesandorb #52</a>
</div>

## 改変してはいけない `<img>` を除外する
この実装では、 pre や code の内部の img にも loading 属性を付与してしまいます。これはどうやって解決するか悩んだのですが、Nokogiriによって親に pre 、 code 、blockquote がある img に関しては属性を編集しない、というように処理を変更しました。

<https://github.com/unasuke/middleman-img_loading_attribute/pull/1/files#diff-ea964f9b9ef0f5bc6bdab0998e722d4e>
 
## まとめ
これで、ようやく僕のblogでlazy image loadingが実現できました。といってもChrome v76以降のみですが。

ということで、Starやpull reqなど頂けると大変ありがたいです。
