require 'spec_helper'

RSpec.describe 'download resources as csv', type: :request do
  it 'returns all the resources' do
    WebMock.stub_request(:get, "https://co-up.cobot.me/api/memberships?attributes=id,name").
      to_return(body: [{id: '1', name: 'Joe'}].to_json)

    user = User.create!
    space = Space.create! url: 'http://www.cobot.me/api/spaces/co-up'
    category = space.categories.create! name: 'Small Office'
    category.resources.create! name: 'Office 1', member_cobot_id: '1'
    category.resources.create! name: 'Office 2'
    log_in user, space

    get space_path(space), params: {format: :csv }

    expect(response.body).to eq <<-CSV
Resource|Category|Member
Office 1|Small Office|Joe
Office 2|Small Office|
CSV
  end

  def log_in(user, space)
    OmniAuth.config.mock_auth[:cobot] = {
      "credentials"=>{"token"=>"12345"},
      "info"=>{"name"=>"janesmith",
        "email"=>"janesmith@example.com"},
      "extra"=>{
        "raw_info"=>{
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

    get authenticate_path(provider: 'cobot'), params: {}
  end
end
