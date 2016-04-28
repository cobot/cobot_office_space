require 'spec_helper'
require 'webmock/rspec'

describe Space, 'callbacks' do
  it 'sets the name on create' do
    space = Space.new(url: 'https://www.cobot.me/api/spaces/co-up')
    space.run_callbacks :create

    expect(space.name).to eq('co-up')
  end
end

describe Space, '#to_param' do
  it 'returns the name' do
    expect(Space.new(name: 'co-up').to_param).to eq('co-up')
  end
end

describe Space, 'members' do
  it 'retries with other access token when one access token is invalid and remove the email' do
    WebMock.stub_request(:get, "https://co-up.cobot.me/api/memberships?attributes=id,name")
      .to_return(status: [403, "Forbidden"])
      .to_return(body: [{id: '1', name: 'Joe'}].to_json)

    # fake the users we load in the space from admin emails
    allow(User).to receive_messages(where: [
      User.new(oauth_token: 'auth_1', email: 'joe@doe.com'), 
      User.new(oauth_token: 'auth_2', email: 'jane@doe.com')
    ])

    space = Space.new(url: "/co-up", name: 'co-up', admins: ['joe@doe.com', 'jane@doe.com'])
    space.members
    expect(WebMock).to have_requested(:get, 'https://co-up.cobot.me/api/memberships?attributes=id,name')
      .with(headers: {'Authorization' => "Bearer auth_1"})
    expect(WebMock).to have_requested(:get, 'https://co-up.cobot.me/api/memberships?attributes=id,name')
      .with(headers: {'Authorization' => "Bearer auth_2"})

    expect(space.admins).to eq(['jane@doe.com'])
  end

  it 're-raises the exception when no valid token found' do
    WebMock.stub_request(:get, "https://co-up.cobot.me/api/memberships?attributes=id,name")
      .to_return(status: [403, "Forbidden"])

    allow(User).to receive_messages(where: [User.new])
    space = Space.new(url: "/co-up", name: 'co-up', admins: ['joe@doe.com', 'jane@doe.com'])
    expect { space.members }.to raise_error(RestClient::Forbidden)
  end
end

describe Space, 'admin?' do
  it 'returns true if the user is in the admin list' do
    expect(Space.new(admins: ['joe@doe.com'])).to be_admin(double(:user, email: 'joe@doe.com'))
  end

  it 'returns false if the user is not in the admin list' do
    expect(Space.new(admins: ['joe@doe.com'])).not_to be_admin(double(:user, email: 'jane@doe.com'))
  end

  it 'returns false if the space has no admins' do
    expect(Space.new).not_to be_admin(double(:user, email: 'jane@doe.com'))
  end
end
