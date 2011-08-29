require 'spec_helper'

describe SessionsController, '#create' do
  before(:each) do
    User.stub(:find_by_login)
    User.stub(:create) {stub.as_null_object}
    User.stub(:find_by_id) {stub(:user).as_null_object}
    Space.stub(:create) {stub(name: 'co-up').as_null_object}
    Space.stub(:find_by_url)
    @access_token = stub(:accessToken, get: stub(:response, body: '[]')).as_null_object
    OAuth2::AccessToken.stub(:new) {@access_token}
  end

  before(:each) do
    request.env['omniauth.auth'] = {
      "credentials"=>{"token"=>"12345"},
      'user_info' => {'name' => 'joe', 'email' => 'joe@doe.com'},
      "extra"=>{
        "user_hash"=>{
          "admin_of"=>[
            {"space_link"=>"https://www.cobot.me/api/spaces/co-up"}
          ]
        }
      }
    }
  end

  it 'tries to find the user' do
    User.should_receive(:find_by_login).with('joe')

    get :create, provider: 'cobot'
  end

  it 'creates a user if none found' do
    User.stub(:find_by_login) {nil}

    User.should_receive(:create).with(login: 'joe', email: 'joe@doe.com',
      oauth_token: '12345', admin_of: ['https://www.cobot.me/api/spaces/co-up'])

    get :create, provider: 'cobot'
  end

  it 'updates an existing user if one found' do
    user = stub(:user).as_null_object
    User.stub(:find_by_login) {user}

    user.should_receive(:update_attributes).with(email: 'joe@doe.com',
      admin_of: ['https://www.cobot.me/api/spaces/co-up'])

    get :create, provider: 'cobot'
  end

  it "creates the spaces that don't exist" do
    Space.stub(:find_by_url).with('https://www.cobot.me/api/spaces/co-up') {nil}

    Space.should_receive(:create).with(url: 'https://www.cobot.me/api/spaces/co-up')

    get :create, provider: 'cobot'
  end

  it 'creates members for the spaces' do
    @access_token.stub(:get).with("https://co-up.cobot.me/api/memberships") {
      stub(:response, body: [{'id' => '654', 'address' => {'name' => 'joe'}}].to_json)
    }
    space = stub(:space, members: stub(:members, find_by_cobot_member_id: nil), name: 'co-up')
    Space.stub(:create) {space}

    space.members.should_receive(:create).with(name: 'joe', cobot_member_id: '654')

    get :create, provider: 'cobot'
  end

  it 'does not create members that already exist' do
    @access_token.stub(:get).with("https://co-up.cobot.me/api/memberships") {
      stub(:response, body: [{'id' => '654', 'address' => {'name' => 'joe'}}].to_json)
    }
    space = stub(:space, members: stub(:members), name: 'co-up')
    space.members.stub(:find_by_cobot_member_id).with('654') {stub(:member)}
    Space.stub(:create) {space}

    space.members.should_not_receive(:create)

    get :create, provider: 'cobot'
  end

  it 'does not create spaces that already exist' do
    Space.stub(:find_by_url).with('https://www.cobot.me/api/spaces/co-up') {stub(:space).as_null_object}

    Space.should_not_receive(:create)

    get :create, provider: 'cobot'
  end

  it 'sets the user id in the session' do
    User.stub(:find_by_login) {stub(:user, id: 1).as_null_object}

    get :create, provider: 'cobot'

    session[:user_id].should == 1
  end

  it 'redirects to spaces' do
    get :create, provider: 'cobot'

    response.should redirect_to(spaces_path)
  end
end