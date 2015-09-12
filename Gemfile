source 'https://rubygems.org'

gem 'rails', '4.2.4'

gem 'rails-api'

# gem 'activeresource'

# Data related gems
gem 'mongoid', '~> 4.0.2'
gem 'bson_ext'

# Auth related gems
gem 'devise',   '~> 3.5.2'
gem 'omniauth', '~> 1.2.2'
gem 'octokit',  '~> 4.0'

# To use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn', group: :production

gem 'rubocop', require: false

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
  gem 'database_cleaner'
end

# To use debugger
# gem 'ruby-debug19', require: 'ruby-debug'
