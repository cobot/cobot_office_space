source 'http://rubygems.org'

ruby '~>2.7'

gem 'rails', '~>5.0.0'
gem 'pg'
gem 'omniauth_cobot', '~>0.2.0'
gem 'omniauth-rails_csrf_protection', '~>1.0.0'
gem 'cobot_client'
gem 'virtus'
gem 'sentry-raven'
gem 'cobot_assets', '~>0.10.0'
gem 'font-awesome-sass'
gem 'sass-rails'
gem 'puma'
gem 'rails_same_site_cookie'

group :production do
  gem 'uglifier'
end

gem 'jquery-rails'


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
  gem 'test-unit'
end
