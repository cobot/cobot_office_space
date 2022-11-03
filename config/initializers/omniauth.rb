require "omniauth/strategies/cobot"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cobot, ENV['COBOT_CLIENT_ID'], ENV['COBOT_CLIENT_SECRET'],
    scope: 'read navigation'
end
