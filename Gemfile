source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'sass-rails', '~> 6.0'
gem 'webpacker', '~> 4.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'slim-rails'
gem 'decent_exposure'
#gem 'devise'
gem 'devise', github: 'heartcombo/devise', branch: 'ca-omniauth-2'
gem 'jquery-rails'
gem 'bootstrap', '~> 4.5.0'
gem "twitter-bootstrap-rails"
gem 'cocoon'
gem 'coffee-rails', '~> 5.0'
gem 'gon'
gem 'handlebars-source'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-facebook'
gem 'omniauth-vkontakte'
gem 'cancancan'
gem 'doorkeeper'
gem 'active_model_serializers', '~> 0.10'
gem 'oj'

gem 'sidekiq'
gem 'sinatra', require: false
gem 'whenever', require: false

gem 'mysql2',          '~> 0.4',    :platform => :ruby
# if not installed mysql2, install: sudo apt install mysql-client mysql-server libmysqlclient-dev

gem 'jdbc-mysql',      '~> 5.1.35', :platform => :jruby
gem 'thinking-sphinx', '~> 5.1'
gem 'database_cleaner', '~> 1.8', '>= 1.8.3'

gem 'mini_racer'
#gem 'therubyracer'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4.0.1'
  gem 'factory_bot_rails'
  gem 'rubocop-rspec', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'dotenv-rails'
  gem 'letter_opener'

  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'chromedriver-helper'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'rails-controller-testing'
  gem 'launchy'
  gem 'capybara-email'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
