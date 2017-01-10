# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
if Rails.env.production?
  OfficeSpace::Application.config.secret_token = ENV['SECRET_TOKEN']
  OfficeSpace::Application.config.secret_key_base = ENV['SECRET_KEY_BASE']
else
  OfficeSpace::Application.config.secret_token = '2d376b8264f0bf689b9b803e7ac8add5f2d376b8264f0bf689b9b803e7ac8add5f2d376b8264f0bf689b9b803e7ac8add5f2d376b8264f0bf689b9b803e7ac8add5f2d376b8264f0bf689b9b803e7ac8add5f'
  OfficeSpace::Application.config.secret_key_base = 'new secret key base' * 5
end
