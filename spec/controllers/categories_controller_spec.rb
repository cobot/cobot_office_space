require 'spec_helper'

describe CategoriesController, 'create' do
  before(:each) do
    log_in
  end

  it 'creates the requested no. of resources' do
    space = stub(:space, class: Space, to_param: 'co-up')
    category = stub(:category, name: 'Small Office', no_of_resources: '2',
      resources: stub(:resources), save: true, errors: {}, class: Category,
      to_param: '1')
    space.stub_chain(:categories, :build) {category}
    Space.stub(:find_by_name!) {space}

    category.resources.should_receive(:create).with(name: 'Small Office 01')
    category.resources.should_receive(:create).with(name: 'Small Office 02')

    post :create, space_id: 'co-up'
  end
end