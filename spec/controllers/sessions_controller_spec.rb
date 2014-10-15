require 'spec_helper'

describe SessionsController, '#new' do
  it 'redirects to spaces if logged in already' do
    log_in

    get :new

    response.should redirect_to(spaces_path)
  end
end

describe SessionsController, '#create' do
  before(:each) do
    User.stub(:find_by_email)
    User.stub(:create) { double.as_null_object }
    User.stub(:find_by_id) { double(:user).as_null_object }
    Space.stub(:create) { double(name: 'co-up').as_null_object }
    Space.stub(:find_by_url)
    @access_token = stub(:access_token, get: stub(:response, body: '[]')).as_null_object
    OAuth2::AccessToken.stub(:new) { @access_token }
  end

  before(:each) do
    request.env['omniauth.auth'] = {
      "credentials"=>{"token"=>"12345"},
      'user_info' => {'email' => 'joe@doe.com'},
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
    User.should_receive(:find_by_email).with('joe@doe.com')

    get :create, provider: 'cobot'
  end

  it 'creates a user if none found' do
    User.stub(:find_by_login) {nil}

    User.should_receive(:create).with(email: 'joe@doe.com',
      oauth_token: '12345', admin_of: ['https://www.cobot.me/api/spaces/co-up'])

    get :create, provider: 'cobot'
  end

  it 'updates an existing user if one found' do
    user = stub(:user).as_null_object
    User.stub(:find_by_email) {user}

    user.should_receive(:update_attributes).with(
      hash_including(admin_of: ['https://www.cobot.me/api/spaces/co-up'],
        oauth_token: '12345'))

    get :create, provider: 'cobot'
  end

  it "creates the spaces that don't exist" do
    Space.stub(:find_by_url).with('https://www.cobot.me/api/spaces/co-up') {nil}

    Space.should_receive(:create).with(url: 'https://www.cobot.me/api/spaces/co-up', admins: ['joe@doe.com'])

    get :create, provider: 'cobot'
  end

  it 'adds the user as admin to an existing space' do
    space = stub(:space, admins: ['jane@doe.com']).as_null_object
    Space.stub(:find_by_url).with('https://www.cobot.me/api/spaces/co-up') {space}

    space.should_receive(:update_attribute).with(:admins, ['jane@doe.com', 'joe@doe.com'])

    get :create, provider: 'cobot'
  end

  it "adds the user to a space that hasn't set any admins" do
    space = stub(:space, admins: nil).as_null_object
    Space.stub(:find_by_url).with('https://www.cobot.me/api/spaces/co-up') {space}

    space.should_receive(:update_attribute).with(:admins, ['joe@doe.com'])

    get :create, provider: 'cobot'
  end

  it 'does not add a user as admin twice' do
    space = stub(:space, admins: ['joe@doe.com']).as_null_object
    Space.stub(:find_by_url).with('https://www.cobot.me/api/spaces/co-up') {space}

    space.should_receive(:update_attribute).with(:admins, ['joe@doe.com'])

    get :create, provider: 'cobot'
  end

  it 'does not create spaces that already exist' do
    Space.stub(:find_by_url).with('https://www.cobot.me/api/spaces/co-up') {stub(:space).as_null_object}

    Space.should_not_receive(:create)

    get :create, provider: 'cobot'
  end

  it 'sets the user id in the session' do
    User.stub(:find_by_email) {stub(:user, id: 1).as_null_object}

    get :create, provider: 'cobot'

    session[:user_id].should == 1
  end

  it 'redirects to spaces' do
    get :create, provider: 'cobot'

    response.should redirect_to(spaces_path)
  end
end
