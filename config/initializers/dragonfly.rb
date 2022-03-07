# frozen_string_literal: true

require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret '16adc9e374e3286216262da53ea5f581c8d5d3fdc565fb6f21e15f6d23447fa3'

  url_host CONFIG['domain']
  url_format '/media/:job/:name'

  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
