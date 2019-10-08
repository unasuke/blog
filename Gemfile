source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem "builder"
gem "middleman", "~> 4.0"
gem "middleman-blog"
gem "middleman-deploy", "2.0.0.pre.alpha"
gem 'middleman-hatenastar'
gem "middleman-livereload"
gem 'middleman-s3_sync', github: 'fredjean/middleman-s3_sync'
gem 'middleman-somemoji'
gem "middleman-syntax"
gem 'redcarpet'
gem "redcarpet-render-html_lazy_img"
gem "slim"
