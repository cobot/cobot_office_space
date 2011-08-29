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
end

Given /^the space "([^"]*)" has a member "([^"]*)" on cobot$/ do |space_name, member_name|
  WebMock.stub_request(:get, "https://co-up.cobot.me/api/memberships").to_return(
    body: [
      {id: '2359', address: {name: member_name}}
    ].to_json,
    headers: {
      content_type: 'application/json'
    }
  )
end