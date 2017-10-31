require 'simplecov'

SimpleCov.profiles.define 'ignore_vendor' do
  load_profile 'rails'
  add_filter 'vendor' # Don't include vendored stuff
end

SimpleCov.start 'ignore_vendor'

# require 'simplecov-shield'
# SimpleCov.formatter = SimpleCov::Formatter::ShieldFormatter

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
