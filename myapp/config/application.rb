require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Configure Cross-Origin Resource Sharing (CORS) to allow requests from any origin.
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*' 
        resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head]
      end
    end

    # Configure paths for autoload and eager loading
    config.paths.add 'app/commands', eager_load: true 
    config.autoload_paths << Rails.root.join('app/commands')
    config.eager_load_paths << Rails.root.join('lib')
    # Configure the application as API only
    config.api_only = true
  end
end

