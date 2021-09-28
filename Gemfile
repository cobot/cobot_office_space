source 'http://rubygems.org'

ruby '~>2.6.5'

gem 'rails', '~>5.0.0'
gem 'pg'
gem 'omniauth_cobot'
gem 'cobot_client'
gem 'virtus'
gem 'sentry-raven'
gem 'cobot_assets', '~>0.10.0'
gem 'font-awesome-sass'
gem 'sass-rails'
gem 'puma'
gem 'rails_same_site_cookie'

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
  gem 'rails-controller-testing'
end
