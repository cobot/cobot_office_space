require "omniauth/strategies/cobot"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cobot, ENV['COBOT_CLIENT_ID'], ENV['COBOT_CLIENT_SECRET'],
    scope: 'read navigation', client_options: {
      site: Rails.application.config.cobot_site,
      authorize_url: "#{Rails.application.config.cobot_site}/oauth/authorize",
      token_url: "#{Rails.application.config.cobot_site}/oauth/access_token"
    }
end
