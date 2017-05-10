# Load the Rails application.
require_relative 'application'

# ruby cas client requirements
require 'casclient'
require 'casclient/frameworks/rails/filter'

# Initialize the Rails application.
Rails.application.initialize!

# CAS Configurations
# See github repo for more doucmentation https://github.com/ddavisgraphics/rubycas-client.git
CASClient::Frameworks::Rails::Filter.configure(
  cas_base_url: 'https://ssodev.wvu.edu/cas',
  login_url: 'https://ssodev.wvu.edu/cas/login',
  logout_url: 'https://ssodev.wvu.edu/cas/logout',
  validate_url: 'https://ssodev.wvu.edu/cas/proxyValidate'
)
