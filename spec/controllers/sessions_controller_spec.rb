require 'spec_helper'

describe SessionsController, '#create' do
  before(:each) do
      User.stub(:find_by_login)
      User.stub(:create) {stub.as_null_object}
      Space.stub(:create)
      Space.stub(:find_by_url)
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

  it 'does not create spaces that already exist' do
    Space.stub(:find_by_url).with('https://www.cobot.me/api/spaces/co-up') {stub(:space)}

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