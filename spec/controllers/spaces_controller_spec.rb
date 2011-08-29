require 'spec_helper'

describe SpacesController, 'index' do
  it 'redirects to the first space' do
    log_in stub(:user, admin_of_space_names: ['co-up'])
    
    get :index

    response.should redirect_to(space_path('co-up'))
  end
end

describe SpacesController, 'show' do
  before(:each) do
    log_in stub(:user)
  end

  it 'loads the space' do
    Space.should_receive(:find_by_name!).with('co-up')

    get :show, id: 'co-up'
  end

  it 'assigns the space' do
    space = stub(:space)
    Space.stub(:find_by_name!) {space}

    get :show, id: 'co-up'

    assigns(:space).should == space
  end
end