source 'https://rubygems.org'

# Rails, MySQL, Puma
gem 'rails', '~> 5.1.4'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'puma', '~> 3.7'
gem 'rake'

# Rails Dependencies
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'

# Authentication Sys
gem 'rubycas-client', :git => 'https://github.com/rubycas/rubycas-client.git'

# frontend
# gem 'bourbon'
# gem 'neat'
# gem 'bitters'
# gem 'normalize-scss'
gem 'font-awesome-sass'
gem 'pickadate-rails'
gem "select2-rails"
gem "simple_calendar", "~> 2.0"

# TEST ONLY GEMS
group :test  do
  gem 'simplecov', :require => false
  gem "codeclimate-test-reporter", "~> 1.0.0"
  gem 'simplecov-shield'
  gem 'rails-controller-testing'
end

# DEVELOPMENT ONLY GEMS
group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]  
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rubocop', require: false
  gem 'brakeman', :require => false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]