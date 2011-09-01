require 'spec_helper'

describe 'download resources as csv' do
  it 'returns all the resources' do
    user = User.create!
    space = Space.create! url: 'http://www.cobot.me/api/spaces/co-up'
    category = space.categories.create! name: 'Small Office'
    member = space.members.create! name: 'Joe'
    resource = category.resources.create! name: 'Office 1', member: member
    log_in user, space

    get space_path(space, format: :csv)

    response.body.should == <<-CSV
Resource|Category|Member
Office 1|Small Office|Joe
CSV
  end

  def log_in(user, space)
    OmniAuth.config.mock_auth[:cobot] = {
      "credentials"=>{"token"=>"12345"},
      "user_info"=>{"name"=>"janesmith", 
          "email"=>"janesmith@example.com"}, 
      "extra"=>{
        "user_hash"=>{
          "memberships"=>[], 
          "admin_of"=>[
            {"space_link" => space.url}
          ]
        }
      }
    }
    WebMock.stub_request(:get, "https://#{space.name}.cobot.me/api/memberships").to_return(
      body: [].to_json,
    )

    get authenticate_path(provider: 'cobot')
  end
end