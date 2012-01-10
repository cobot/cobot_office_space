require 'spec_helper'

describe CategoriesController, 'create' do
  let(:user) {stub(:user)}
  before(:each) do
    log_in user
  end

  it 'creates the requested no. of resources' do
    space = stub(:space, class: Space, to_param: 'co-up', admin?: true)
    category = stub(:category, name: 'Small Office', no_of_resources: '2',
      resources: stub(:resources), save: true, errors: {}, class: Category,
      to_param: '1')
    space.stub_chain(:categories, :build) {category}
    Space.stub(:find_by_name!) {space}

    category.resources.should_receive(:create).with(name: 'Small Office 01')
    category.resources.should_receive(:create).with(name: 'Small Office 02')

    post :create, space_id: 'co-up'
  end

  it 'renders 403 if the user is not admin of the space' do
    space = stub(:space)
    Space.stub(:find_by_name!) {space}
    space.stub(:admin?).with(user) {false}

    post :create, space_id: 'co-up'

    response.status.should == 403
  end
end
