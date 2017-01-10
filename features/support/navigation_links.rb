Before do
  WebMock.stub_request(:get, 'https://co-up.cobot.me/api/navigation_links')
         .to_return(body: '[]')
  WebMock.stub_request(:post, 'https://co-up.cobot.me/api/navigation_links')
         .to_return do |request|
           request_body = JSON.parse(request.body, symbolize_names: true)
           # we pretend to be a cobot iframe, i.e. we load the same page but with cobot_embed=true
           {body: {user_url: "#{request_body[:iframe_url]}?cobot_embed=true"}.to_json}
         end
end
