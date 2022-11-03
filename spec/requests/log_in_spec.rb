require 'spec_helper'

RSpec.describe 'logging in', type: :request do
  include Capybara::DSL
  
  it 'passes the space subdomain to the cobot oauth endpoint' do
    OmniAuth.config.test_mode = false

    get '/spaces/1', params: {cobot_subdomain: 'xyz'}
    follow_redirect!
    continue_url = Nokogiri::HTML(response.body).css('form[method=post]').attribute('action').value
    post continue_url
    
    expect(response.redirect_url).to start_with('https://xyz.cobot.me/oauth/authorize')
  end
end