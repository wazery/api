source 'https://rubygems.org'

gem 'rails', '4.2.4'

gem 'rails-api'

# gem 'activeresource'

# NoSQL DBs
gem 'mongoid', '~> 4.0.2'
gem 'redis'
gem 'hiredis'

# HTTP Requests
gem 'faraday'
gem 'rack-cors', require: 'rack/cors'

# Authentication
gem 'micro_token'
gem 'jwt'

# To use Jbuilder templates for JSON
# gem 'jbuilder'
gem 'bson_ext'
gem 'multi_json'

# Stream processing
gem 'polling'
gem 'actioncable', github: 'rails/actioncable'
# Use Puma as the app server, for Rails, and Cable servers
gem 'puma'

# Slack integration for Capistrano
gem 'slackistrano', require: false

gem 'active_model_serializers'

gem 'rubocop', require: false, group: [:development, :test]

# Documentation
gem 'yard'
gem 'apipie-rails'

gem 'colorize'

# Background workers
gem 'sidekiq'
gem 'sinatra' # For the Sidekiq panel

group :development do
  gem 'spring'
  # Deploy with Capistrano
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-secrets-yml', '~> 1.0.0', require: false
  gem 'sshkit-sudo' # For sudo prompts while deploying
  gem 'awesome_print', require: 'ap'
  gem 'airbrussh', require: false
  gem 'byebug'
end

group :test do
  gem 'factory_girl_rails'
  gem 'database_cleaner', '~> 1.4.1'
  gem 'simplecov', '~> 0.9.0', require: false
  gem 'rspec-rails'
  gem 'mongoid-rspec', '~> 2.1.0'
  gem 'rspec-sidekiq'
  gem 'webmock'
end

# To use debugger
# gem 'ruby-debug19', require: 'ruby-debug'
