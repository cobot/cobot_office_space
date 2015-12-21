require 'spec_helper'
require 'webmock/rspec'

describe Space, 'callbacks' do
  it 'sets the name on create' do
    space = Space.new(url: 'https://www.cobot.me/api/spaces/co-up')
    space.run_callbacks :create

    space.name.should == 'co-up'
  end
end

describe Space, '#to_param' do
  it 'returns the name' do
    Space.new(name: 'co-up').to_param.should == 'co-up'
  end
end

describe Space, 'members' do
  it 'retries with other access token when one access token is invalid and remove the email' do
    WebMock.stub_request(:get, "https://co-up.cobot.me/api/memberships?attributes=id,name")
      .to_return(status: [403, "Forbidden"])
      .to_return(body: [{id: '1', name: 'Joe'}].to_json)

    # fake the users we load in the space from admin emails
    User.stub(where: [
      User.new(oauth_token: 'auth_1', email: 'joe@doe.com'), 
      User.new(oauth_token: 'auth_2', email: 'jane@doe.com')
    ])

    space = Space.new(url: "/co-up", name: 'co-up', admins: ['joe@doe.com', 'jane@doe.com'])
    space.members
    WebMock.should have_requested(:get, 'https://co-up.cobot.me/api/memberships?attributes=id,name')
      .with(headers: {'Authorization' => "Bearer auth_1"})
    WebMock.should have_requested(:get, 'https://co-up.cobot.me/api/memberships?attributes=id,name')
      .with(headers: {'Authorization' => "Bearer auth_2"})

    space.admins.should == ['jane@doe.com']
  end

  it 're-raises the exception when no valid token found' do
    WebMock.stub_request(:get, "https://co-up.cobot.me/api/memberships?attributes=id,name")
      .to_return(status: [403, "Forbidden"])

    User.stub(where: [User.new])
    space = Space.new(url: "/co-up", name: 'co-up', admins: ['joe@doe.com', 'jane@doe.com'])
    expect { space.members }.to raise_error(RestClient::Forbidden)
  end
end

describe Space, 'admin?' do
  it 'returns true if the user is in the admin list' do
    Space.new(admins: ['joe@doe.com']).should be_admin(stub(:user, email: 'joe@doe.com'))
  end

  it 'returns false if the user is not in the admin list' do
    Space.new(admins: ['joe@doe.com']).should_not be_admin(stub(:user, email: 'jane@doe.com'))
  end

  it 'returns false if the space has no admins' do
    Space.new.should_not be_admin(stub(:user, email: 'jane@doe.com'))
  end
end
