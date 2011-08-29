Rails.application.config.middleware.use OmniAuth::Builder do
  provider :Cobot, ENV['COBOT_CLIENT_ID'], ENV['COBOT_CLIENT_SECRET'], scope: 'read'
end