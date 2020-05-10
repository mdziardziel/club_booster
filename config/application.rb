require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ClubBooster
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.eager_load_paths << Rails.root.join('lib')
    
    config.to_prepare { DeviseController.respond_to :json }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    config.middleware.insert_before 0, Rack::Cors do
      allowed_headers = %i(get post put patch delete options head)

      # not safety, but it is just app for university :)
      allow do
        origins '*'
        resource '*', headers: :any, methods: allowed_headers
      end
      
      # allow do
      #   origins 'http://localhost:3000'
      #   resource '*', headers: :any, methods: allowed_headers
      # end
      
      # allow do
      #   origins 'http://localhost:4200'
      #   resource '*', headers: :any, methods: allowed_headers
      # end

      # allow do
      #   origins 'http://localhost:80'
      #   resource '*', headers: :any, methods: allowed_headers
      # end

      # allow do
      #   origins 'http://localhost:8080'
      #   resource '*', headers: :any, methods: allowed_headers
      # end

      # allow do
      #   origins 'http://localhost'
      #   resource '*', headers: :any, methods: allowed_headers
      # end

      # allow do
      #   origins 'https://murmuring-sea-67113.herokuapp.com'
      #   resource '*', headers: :any, methods: allowed_headers
      # end
    end
  end
end
