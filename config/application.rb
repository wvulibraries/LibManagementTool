require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module LibraryManagementTool
  class Application < Rails::Application
    ## Set Configuration of Time Zone Here
    ## Although this should be handled by the server
    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_record.default_timezone = :local
  end
end
