source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.1'
gem 'pg'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

# Installed Gems

gem 'bootstrap-sass', '~> 3.3.6'
gem 'webpacker', git: 'https://github.com/rails/webpacker.git'
gem 'devise'
gem 'activeadmin', github: 'activeadmin'
gem 'arctic_admin'
gem 'slim'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'foreman'
gem 'font-awesome-sass'
gem 'paranoia', '~> 2.2'
gem 'carrierwave'
gem 'resque-web', require: 'resque_web'
gem 'timecop'
gem 'mini_magick'
gem 'fog'
gem 'activeadmin_addons'
gem 'select2-rails'

# -- END --

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'

  # Installed Gems
  
  gem 'figaro'
  gem 'pry-rails'
  gem 'rails-erd', require: false

  # -- END --
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
