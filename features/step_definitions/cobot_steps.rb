Given /^on cobot I have a space "([^\"]*)"$/ do |space_name|
  subdomain = space_name.gsub(/\W+/, '-')

  OmniAuth.config.mock_auth[:cobot] = {
    "provider"=>"cobot", 
    "uid"=>"janesmith", 
    "credentials"=>{"token"=>"12345"},
    "user_info"=>{"name"=>"janesmith", 
        "email"=>"janesmith@example.com"}, 
    "extra"=>{
      "user_hash"=>{
        "login"=>"janesmith", 
        "email"=>"janesmith@example.com", 
        "id"=>"user-janesmith", 
        "memberships"=>[], 
        "admin_of"=>[
          {"space_link"=>"https://www.cobot.me/api/spaces/#{subdomain}"}
        ]
      }
    }
  }

  WebMock.stub_request(:get, "https://www.cobot.me/api/spaces/#{subdomain}").to_return(body: {name: space_name}.to_json)
end