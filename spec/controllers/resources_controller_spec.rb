require 'spec_helper'

describe ResourcesController, 'permissions' do
  it 'renders 403 if user is not space admin' do
    user = stub(:user)
    log_in user
    space = stub(:space)
    space.stub(:admin?).with(user) {false}
    Space.stub(:find_by_name!) {space}

    post :create, space_id: '1', category_id: '2'

    response.status.should == 403
  end
end
