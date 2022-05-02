source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# アプリ作成時 ruby '2.6.5'
# 2022/05/02 '2.7.4'からアップデート
ruby '2.7.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# 2022/05/02 セキュリティ対策のため'~> 5.2.5'からアップデート
gem 'rails', '~> 5.2.7'
# Use Puma as the app server
# 2022/05/02 セキュリティ対策のため'~> 3.11'からアップデート
gem 'puma', '~> 5.6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
#gem 'duktape'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use mechanize
gem 'mechanize'
# 2022/05/02 セキュリティ対策のため「nokogiri」を個別でバージョンアップ
gem 'nokogiri', '~> 1.13'
# ユーザー認証用のgemを追加
gem 'devise'
# Rails日本語化
gem 'rails-i18n', '~> 5.1'
# devise日本語化パッケージ
gem 'devise-i18n'
gem 'devise-i18n-views'
# Bootstrap
gem 'bootstrap', '~> 4.5'
gem 'jquery-rails'
gem 'devise-bootstrap-views', '~> 1.0'
# 削除確認gem
gem 'data-confirm-modal'
# Accept-Languageからのlocale変更を可能にする
gem 'http_accept_language'
# gem 'clockwork'
gem 'clockwork'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Use sqlite3 as the database for Active Record
  # 2021/10/6 デフォルト位置からこのグループ内に移動。2021/10/27 記述をバージョン直接指定へ変更。
  #gem 'sqlite3', git: "https://github.com/larskanis/sqlite3-ruby", branch: "add-gemspec"
  gem 'sqlite3', '1.4.2'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  # このgemは2019年3月31日にサポートが終了
  #gem 'chromedriver-helper'
  # 'chromedriver-helper'の後継として使用
  gem 'webdrivers'
end

group :production do
  gem 'pg', '1.2.3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
