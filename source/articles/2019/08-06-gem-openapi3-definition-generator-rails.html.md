---
title: "Railsの config/routes.rb の内容からOpenAPIのpathsの定義を生成する"
date: 2019-08-06 22:59 JST
tags: 
- diary
- ruby
- programming
- rails
- gem
---

![GitHub](2019/openapi3_definition_generator-rails.png)


OpenAPIによる定義から実装を生成したいニーズはあり、その方法は存在します。

- [Swagger Codegen | API Development Tools | Swagger](https://swagger.io/tools/swagger-codegen/)
- [OpenAPIのschema定義からRubyのクラスを生成するgem「openapi2ruby」をつくりました - ZOZO Technologies TECH BLOG](https://techblog.zozo.com/entry/openapi2ruby)

「スキーマファースト開発」という言葉もあるように、一般的にはREST API schemaを定義してから実装にとりかかります。

しかし、様々な事情で「既存のREST API実装に対してOpenAPI schemaを記述したい」というニーズがあります。

例えばRailsの `config/routes.rb` の内容から OpenAPI の `paths` に相当するYAMLやJSONを出力するようなgemがあると助かるのですが、rubygems.org を "openapi" で検索してもそれらしいgemは見当りませんでした。

なので、そういうgemをつくりました。

## 実装にあたって
※ 以下、特記していない場合には Rails v5.2.3 時点のコードになります。

実装にあたって、まず参考にしたのがお馴染み `bin/rails routes` の処理になります。このとき何が行われているのでしょうか。

`bin/rails routes` で実行されるコードは以下です。

```ruby
# frozen_string_literal: true

require "optparse"

desc "Print out all defined routes in match order, with names. Target specific controller with -c option, or grep routes using -g option"
task routes: :environment do
  all_routes = Rails.application.routes.routes
  require "action_dispatch/routing/inspector"
  inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)

  routes_filter = nil

  OptionParser.new do |opts|
    opts.banner = "Usage: rails routes [options]"

    Rake.application.standard_rake_options.each { |args| opts.on(*args) }

    opts.on("-c CONTROLLER") do |controller|
      routes_filter = { controller: controller }
    end

    opts.on("-g PATTERN") do |pattern|
      routes_filter = pattern
    end

  end.parse!(ARGV.reject { |x| x == "routes" })

  puts inspector.format(ActionDispatch::Routing::ConsoleFormatter.new, routes_filter)

  exit 0 # ensure extra arguments aren't interpreted as Rake tasks
end
```
<https://github.com/rails/rails/blob/v5.2.3/railties/lib/rails/tasks/routes.rake>

ここでの本質は 

```ruby
inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)

puts inspector.format(ActionDispatch::Routing::ConsoleFormatter.new, routes_filter)
```

の2行でしょう。

では、 `ActionDispatch::Routing::RoutesInspector` は何でしょう。

```ruby
##
# This class is just used for displaying route information when someone
# executes `rails routes` or looks at the RoutingError page.
# People should not use this class.
class RoutesInspector # :nodoc:
  def initialize(routes)
    @engines = {}
    @routes = routes
  end
  ...sinp
```
<https://github.com/rails/rails/blob/v5.2.3/actionpack/lib/action_dispatch/routing/inspector.rb#L54-L127>

はい、private API ですね。

この RoutesInspector に適切なFormatterを渡して、routesの結果を整形すればよさそうです。

では `ActionDispatch::Routing::ConsoleFormatter` を見てみます。

```ruby
class ConsoleFormatter
  def initialize
    @buffer = []
  end

  def result
    @buffer.join("\n")
  end

  def section_title(title)
    @buffer << "\n#{title}:"
  end

  def section(routes)
    @buffer << draw_section(routes)
  end

  def header(routes)
    @buffer << draw_header(routes)
  end

  def no_routes(routes)
    @buffer <<
    if routes.none?
      <<-MESSAGE.strip_heredoc
      You don't have any routes defined!

      Please add some routes in config/routes.rb.
      MESSAGE
    else
      "No routes were found for this controller"
    end
    @buffer << "For more information about routes, see the Rails guide: http://guides.rubyonrails.org/routing.html."
  end

  private
  # ...snip
```

<https://github.com/rails/rails/blob/5.2.3/actionpack/lib/action_dispatch/routing/inspector.rb#L129-L185>

RoutesInspectorと同様に(明記されていませんが)これもprivate APIでしょう。

少し下に `/rails/info/routes` で使用される `HtmlTableFormatter` も定義されており、それと見比べると、 `result`、 `section_title`、 `section`、 `header`、 `no_routes` を定義した独自のFormatterを作成すればよさそうに見えます。

## OpenAPI v3 の記法
さて、 OpenAPI v3 では、以下のような記述をするよう、仕様で定義されています。

```yaml
openapi: 3.0.2
info:
  title: example
  description: OpenAPI example
  version: 0.1.0
servers:
  - url: http://api.example.com/v1
    description: example server
paths:
  /users:
    get:
      summary: get users
      description: Return all user list
      responses:
        '200':
          description: users json
          content:
            application/json:
              schema: 
                type: array
                items: 
                  type: string
```

<https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.2.md>

これらの定義のうち、 `paths` 以下のいくつかについては、 `config/routes.rb` から自動生成できそうです。

なので、以下のようなFormatterを作成すると、それらしい定義を生成できます。

```ruby
module ActionDispatch
  module Routing
    class OpenAPI3Formatter
      def initialize()
        @view  = nil
        @buffer = []
        @openapi_structute = {
          'openapi' => '3.0.0',
          'info' => {
            'title' => '',
            'description' => '',
            'version' => '0.1.0'
          },
          'paths' => {}
        }
      end

      def section_title(title)
      end

      def section(routes)
        routes.filter do |r|
          !r[:verb].empty?
        end.each do |r|
          @openapi_structute['paths'][r[:path]] ||= {}
          @openapi_structute['paths'][r[:path]][r[:verb].downcase] = {}
          @openapi_structute['paths'][r[:path]][r[:verb].downcase] = {
            'summary' => r[:name],
            'description' => r[:reqs],
            'responses' => nil
          }
        end
      end

      def header(routes)
      end

      def no_routes(*)
      end

      def result
        YAML.dump @openapi_structute
      end
    end
  end
end
```
<https://github.com/unasuke/openapi3_definition_generator-rails/blob/3973f11c50a1ccdc69c1d97fce502222ecd92870/lib/openapi3_definition_generator/rails/openapi3_formatter.rb>

## gemify
そして、それをgemにしたのがこれです。

<https://github.com/unasuke/openapi3_definition_generator-rails>

使いかたはREADMEにあるとおり、Gemfileに追記して bundle installした上で、 `$ bin/rails openapi3_definition:generate_yaml`

雑に表参道.rbで話したのが、これです。

<iframe src="https://slide.rabbit-shocker.org/authors/unasuke/omotesandorb-49/viewer.html"
        width="320" height="285"
        frameborder="0"
        marginwidth="0"
        marginheight="0"
        scrolling="no"
        style="border: 1px solid #ccc; border-width: 1px 1px 0; margin-bottom: 5px"
        allowfullscreen> </iframe>
<div style="margin-bottom: 5px">
  <a href="https://slide.rabbit-shocker.org/authors/unasuke/omotesandorb-49/" title="omotesandorb #49">omotesandorb #49</a>
</div>

上で述べたように、内部でPrivate APIにしっかり依存しているので、いつ動かなくなるかは保障できず、そのため Rails v5.2.3 以上 v6 未満でしかインストールできないようになっています。Pull Requestは大歓迎です。

## 今後
今後、実装するとしたら

- JSON での出力

くらいと、あとは表参道.rbでもアドバイスを頂いたように、Rails本体への機能追加も考えています。
