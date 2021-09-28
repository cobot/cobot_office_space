require 'spec_helper'

describe ResourcesController, 'permissions', type: :controller do
  it 'renders 403 if user is not space admin' do
    user = double(:user)
    log_in user
    space = double(:space)
    allow(space).to receive(:admin?).with(user) {false}
    allow(Space).to receive(:find_by_name!) {space}

    post :create, params: { space_id: '1', category_id: '2' }

    expect(response.status).to eq(403)
  end
end
