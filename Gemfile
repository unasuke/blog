source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem "middleman", "~> 4.0"
gem "middleman-blog"
gem "middleman-livereload"
gem "middleman-deploy", "2.0.0.pre.alpha"
gem 'middleman-s3_sync', github: 'fredjean/middleman-s3_sync'

# synatax highlight
gem "middleman-syntax"

# emoji
gem 'middleman-somemoji'

# hatenastar
gem 'middleman-hatenastar'

# markdown engine
gem 'redcarpet'

# For feed.xml.builder
gem "builder"

# slim
gem "slim"
