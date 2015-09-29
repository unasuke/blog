###
# Blog settings
###

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

activate :directory_indexes

###
# Compass
###

# Change Compass configuration
compass_config do |config|
  config.output_style = :compact
end


# Reload the browser automatically whenever files change
activate :livereload


set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

activate :syntax
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, strikethrough: true
Slim::Engine.set_options pretty: true, sort_attrs: false

activate :google_analytics do |ga|
  ga.tracking_id = "UA-68233014-1"
end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

activate :deploy do |deploy|
  deploy.method       = :rsync
  deploy.host         = "blog.unasuke.com"
  deploy.path         = "/var/www"
  deploy.user         = ENV["MIDDLEMAN_USER"]
  deploy.port         = ENV["MIDDLEMAN_PORT"]
  deploy.flags        = '-rltgoDvzO --no-p --del'
  deploy.build_before = true
end
