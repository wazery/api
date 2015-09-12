source 'https://rubygems.org'

gem 'rails', '4.2.4'

gem 'rails-api'

# gem 'activeresource'

# Data related gems
gem 'mongoid'
gem 'bson_ext'

gem 'mongoid'

# To use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn', group: :production

group :development do
  gem 'spring'
  # Deploy with Capistrano
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-secrets-yml', '~> 1.0.0', require: false
  gem 'sshkit-sudo'
  gem 'awesome_print', require: 'ap'
end

group :test do
  gem 'rspec-rails'
  gem 'mongoid-rspec', '~> 2.1.0'
  gem 'database_cleaner'
end

# To use debugger
# gem 'ruby-debug19', require: 'ruby-debug'
