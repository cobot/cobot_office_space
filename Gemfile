source 'http://rubygems.org'

ruby '2.2.2'

gem 'rails', '~>3.2.20'
gem 'pg'
gem 'omniauth_cobot'
gem 'inherited_resources'
gem 'cobot_client'
gem 'virtus'
gem 'sentry-raven'
gem 'cobot_assets', '~>0.0.11'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.0'
  gem 'uglifier'
end

group :production do
  gem 'rails_12factor'
  gem 'puma'
end

gem 'jquery-rails'
gem 'test-unit'

# Use unicorn as the web server
# gem 'unicorn'

group :development do
  gem 'rspec-rails'
  gem 'dotenv-rails'
end

group :test do
  gem 'database_cleaner'
  gem 'turn', require: false
  gem 'cucumber-rails', require: false
  gem 'capybara'
  gem 'webmock'
  gem 'launchy'
end
