source 'https://rubygems.org'

gem 'github-pages', group: :jekyll_plugins

# enable tzinfo-data for local build
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
gem 'jekyll-paginate'
gem 'jekyll-paginate-v2'
gem 'jekyll-remote-theme'
gem 'jekyll-seo-tag'
gem 'jekyll-sitemap'
gem 'kramdown'
gem 'kramdown-parser-gfm'
gem 'webrick'
gem 'faraday-retry'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ /%r!mingw|mswin|java!/ } do
  gem 'tzinfo'
  gem 'tzinfo-data'
end

# Performance-booster for watching directories on Windows
gem 'wdm', install_if: Gem.win_platform?
