require 'spec_helper'

describe CategoriesController, 'create', type: :controller do
  let(:user) { double(:user) }
  before(:each) do
    log_in user
  end

  it 'creates the requested no. of resources' do
    space = double(:space, class: Space, to_param: 'co-up', admin?: true).as_null_object
    category = double(:category, name: 'Small Office', no_of_resources: '2',
      resources: double(:resources), valid?: true, to_param: '1').as_null_object
    allow(space).to receive_message_chain(:categories, :create) { category }
    allow(Space).to receive(:find_by_name!) { space }

    expect(category.resources).to receive(:create).with(name: 'Small Office 01')
    expect(category.resources).to receive(:create).with(name: 'Small Office 02')

    post :create, space_id: 'co-up', category: {no_of_resources: 2}
  end

  it 'renders 403 if the user is not admin of the space' do
    space = double(:space, admin?: false)
    allow(Space).to receive(:find_by_name!) { space }

    post :create, space_id: 'co-up'

    expect(response.status).to eq(403)
  end
end
