require 'spec_helper'

describe SpacesController, 'index' do
  it 'redirects to the first space' do
    log_in stub(:user, admin_of_space_names: ['co-up'])

    get :index

    response.should redirect_to(space_path('co-up'))
  end

  it 'renders index if user has no spaces' do
    log_in stub(:user, admin_of_space_names: [])

    get :index

    response.should render_template('index')
  end
end

describe SpacesController, 'show' do
  let(:user) {stub(:user)}

  before(:each) do
    log_in user
  end

  it 'loads the space' do
    Space.should_receive(:find_by_name!).with('co-up') {stub(:space).as_null_object}

    get :show, id: 'co-up'
  end

  it 'renders 403 if the user is not an admin of the space' do
    space = stub(:space)
    Space.stub(:find_by_name!) {space}
    space.stub(:admin?).with(user) {false}

    get :show, id: 'co-up'

    response.status.should == 403
  end

  it 'assigns the space' do
    space = stub(:space).as_null_object
    Space.stub(:find_by_name!) {space}

    get :show, id: 'co-up'

    assigns(:space).should == space
  end
end
