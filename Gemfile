source 'http://rubygems.org'

ruby '~>2.4.6'

gem 'rails', '~>4.2.11'
gem 'pg'
gem 'omniauth_cobot'
gem 'cobot_client'
gem 'virtus'
gem 'sentry-raven'
gem 'cobot_assets', '~>0.10.0'
gem 'font-awesome-sass'
gem 'sass-rails'
gem 'puma'

group :production do
  gem 'rails_12factor'
  gem 'uglifier'
end

gem 'jquery-rails'
gem 'test-unit'

# Use unicorn as the web server
# gem 'unicorn'

gem 'rspec-rails', group: [:test, :development]

group :development do
  gem 'dotenv-rails'
end

group :test do
  gem 'database_cleaner'
  gem 'cucumber-rails', require: false
  gem 'capybara'
  gem 'webmock'
  gem 'launchy'
end
