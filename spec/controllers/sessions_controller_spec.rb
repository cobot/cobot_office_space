require 'spec_helper'

describe SessionsController, '#new', type: :controller do
  it 'redirects to spaces if logged in already' do
    log_in

    get :new

    expect(response).to redirect_to(spaces_path)
  end
end

describe SessionsController, '#create', type: :controller do
  before(:each) do
    allow(User).to receive(:find_by_email)
    allow(User).to receive(:create) { double.as_null_object }
    allow(User).to receive(:find_by_id) { double(:user).as_null_object }
    allow(Space).to receive(:create) { double(name: 'co-up').as_null_object }
    allow(Space).to receive(:find_by_url)
    @access_token = double(:access_token, get: double(:response, body: '[]')).as_null_object
    allow(OAuth2::AccessToken).to receive(:new) { @access_token }
  end

  before(:each) do
    request.env['omniauth.auth'] = {
      "credentials"=>{"token"=>"12345"},
      'info' => {'email' => 'joe@doe.com'},
      "extra"=>{
        "raw_info"=>{
          "admin_of"=>[
            {"space_link"=>"https://www.cobot.me/api/spaces/co-up"}
          ]
        }
      }
    }
  end

  it 'tries to find the user' do
    expect(User).to receive(:find_by_email).with('joe@doe.com')

    get :create, provider: 'cobot'
  end

  it 'creates a user if none found' do
    allow(User).to receive(:find_by_login) {nil}

    expect(User).to receive(:create).with(email: 'joe@doe.com',
      oauth_token: '12345', admin_of: ['https://www.cobot.me/api/spaces/co-up'])

    get :create, provider: 'cobot'
  end

  it 'updates an existing user if one found' do
    user = double(:user).as_null_object
    allow(User).to receive(:find_by_email) {user}

    expect(user).to receive(:update_attributes).with(
      hash_including(admin_of: ['https://www.cobot.me/api/spaces/co-up'],
        oauth_token: '12345'))

    get :create, provider: 'cobot'
  end

  it "creates the spaces that don't exist" do
    allow(Space).to receive(:find_by_url).with('https://www.cobot.me/api/spaces/co-up') {nil}

    expect(Space).to receive(:create).with(url: 'https://www.cobot.me/api/spaces/co-up', admins: ['joe@doe.com'])

    get :create, provider: 'cobot'
  end

  it 'adds the user as admin to an existing space' do
    space = double(:space, admins: ['jane@doe.com']).as_null_object
    allow(Space).to receive(:find_by_url).with('https://www.cobot.me/api/spaces/co-up') {space}

    expect(space).to receive(:update_attribute).with(:admins, ['jane@doe.com', 'joe@doe.com'])

    get :create, provider: 'cobot'
  end

  it "adds the user to a space that hasn't set any admins" do
    space = double(:space, admins: nil).as_null_object
    allow(Space).to receive(:find_by_url).with('https://www.cobot.me/api/spaces/co-up') {space}

    expect(space).to receive(:update_attribute).with(:admins, ['joe@doe.com'])

    get :create, provider: 'cobot'
  end

  it 'does not add a user as admin twice' do
    space = double(:space, admins: ['joe@doe.com']).as_null_object
    allow(Space).to receive(:find_by_url).with('https://www.cobot.me/api/spaces/co-up') {space}

    expect(space).to receive(:update_attribute).with(:admins, ['joe@doe.com'])

    get :create, provider: 'cobot'
  end

  it 'does not create spaces that already exist' do
    allow(Space).to receive(:find_by_url).with('https://www.cobot.me/api/spaces/co-up') {double(:space).as_null_object}

    expect(Space).not_to receive(:create)

    get :create, provider: 'cobot'
  end

  it 'sets the user id in the session' do
    allow(User).to receive(:find_by_email) {double(:user, id: 1).as_null_object}

    get :create, provider: 'cobot'

    expect(session[:user_id]).to eq(1)
  end

  it 'redirects to spaces' do
    get :create, provider: 'cobot'

    expect(response).to redirect_to(spaces_path)
  end
end
