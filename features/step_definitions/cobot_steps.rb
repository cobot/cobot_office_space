Given /^on cobot I have a space "([^\"]*)"$/ do |space_name|
  subdomain = space_name.gsub(/\W+/, '-')

  OmniAuth.config.mock_auth[:cobot] = {
    "provider"=>"cobot",
    "uid"=>"janesmith",
    "credentials"=>{"token"=>"12345"},
    "info"=> {
      "email"=>"janesmith@example.com"},
    "extra"=> {
      "raw_info"=> {
        "email"=>"janesmith@example.com",
        "id"=>"123456",
        "memberships"=>[],
        "admin_of"=>[
          {"space_link"=>"https://www.cobot.me/api/spaces/#{subdomain}"}
        ]
      }
    }
  }
  WebMock.stub_request(:get, "https://#{space_name}.cobot.me/api/memberships?attributes=id,name").to_return(
    body: [].to_json,
  )
end

Given /^the space "([^"]*)" has a member "([^"]*)" on cobot$/ do |space_name, member_name|
  WebMock.stub_request(:get, "https://#{space_name}.cobot.me/api/memberships?attributes=id,name")
    .with(headers: {'Authorization' => 'Bearer 12345'})
    .to_return(body: [
      {id: '2359', name: member_name}
    ].to_json)
end
