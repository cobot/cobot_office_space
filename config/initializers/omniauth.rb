Rails.application.config.middleware.use OmniAuth::Builder do
  provider :Cobot, ENV['COBOT_CLIENT_ID'], ENV['COBOT_CLIENT_SECRET'],
    scope: 'read', client_options: {
      site: Rails.application.config.cobot_site,
      authorize_url: "#{Rails.application.config.cobot_site}/oauth/authorize",
      token_url: "#{Rails.application.config.cobot_site}/oauth/access_token"
    }
end
