###
# Blog settings
###
require_relative 'lib/auto_ogp'

Time.zone = "Tokyo"

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "blog"

  blog.permalink = "{year}/{title}.html"

  # Matcher for blog source files
  blog.sources = "articles/{year}/{month}-{day}-{title}.html"
  blog.taglink = "tag/{tag}.html"
  blog.layout = "layouts/article"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  blog.year_link = "{year}.html"
  blog.month_link = "{year}/{month}.html"
  blog.day_link = "{year}/{month}/{day}.html"
  blog.default_extension = ".md"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  blog.paginate = true
  blog.per_page = 10
  blog.page_link = "page/{num}"
end

page "/feed.xml", layout: false
page '/404.html', layout: false
page '/500.html', layout: false

activate :directory_indexes

# Reload the browser automatically whenever files change
activate :livereload


set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

activate :syntax
set :markdown_engine, :redcarpet
set :markdown,
  fenced_code_blocks: true, smartypants: true, strikethrough: true, tables: true, footnotes: true
Slim::Engine.set_options pretty: true, sort_attrs: false

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash, ignore: %r[images/favicon\.png]

  # Use relative URLs
  #activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

activate :external_pipeline,
  name: :npm,
  command: "npm run scss",
  source: "./source/stylesheets"

Tilt::SYMBOL_ARRAY_SORTABLE = false

# activate :somemoji, provider: 'twemoji'
activate :hatenastar,
  token: 'd87af8244bf9abaa30fcb93185c4fe1a43ece711',
  uri: 'h2 a',
  title: 'h2 a',
  container: 'h2',
  entry_node: 'section.article'

activate :img_loading_attribute do |c|
  c.loading = 'lazy'
end

activate :auto_ogp
