require_relative 'boot'

require 'rails/all'
require 'active_job'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Chowpocket
  class Application < Rails::Application
    require Rails.root.join('lib/properties.rb')
    # Initialize configuration defaults for originally generated Rails version.

    config.load_defaults 5.1
    config.time_zone = 'Asia/Taipei'
    config.active_record.default_timezone = :local

    # -- END --

    # Facebook Messenger Bot Files

    config.paths.add File.join('app', 'bot'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'bot', '*')]

    # -- END --

    config.active_job.queue_adapter = :resque

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    
    config.assets.version = '10.1'
  end
end
