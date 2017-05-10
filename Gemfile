source 'https://rubygems.org'

# Rails, MySQL, Puma
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'puma', '~> 3.0'
gem 'rake'

# Rails Dependencies
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

# Authentication Sys
gem 'rubycas-client', :git => 'https://github.com/rubycas/rubycas-client.git'

# frontend
gem 'bourbon'
gem 'neat'
gem 'bitters'
gem 'normalize-scss'
gem 'font-awesome-sass'
gem 'pickadate-rails'
gem "select2-rails"
gem "simple_calendar", "~> 2.0"

# TEST ONLY GEMS
group :test  do
  gem 'simplecov', :require => false
  gem 'simplecov-shield'
  gem 'rails-controller-testing'
end

# DEVELOPMENT ONLY GEMS
group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'byebug', platform: :mri
  gem 'rubocop', require: false
  gem 'brakeman', :require => false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
