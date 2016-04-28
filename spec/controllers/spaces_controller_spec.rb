require 'spec_helper'

describe SpacesController, 'index', type: :controller do
  it 'redirects to the first space' do
    log_in double(:user, admin_of_space_names: ['co-up'])

    get :index

    expect(response).to redirect_to(space_path('co-up'))
  end

  it 'renders index if user has no spaces' do
    log_in double(:user, admin_of_space_names: [])

    get :index

    expect(response).to render_template('index')
  end
end

describe SpacesController, 'show', type: :controller do
  let(:user) {double(:user)}

  before(:each) do
    log_in user
  end

  it 'loads the space' do
    expect(Space).to receive(:find_by_name!).with('co-up') {double(:space).as_null_object}

    get :show, id: 'co-up'
  end

  it 'renders 403 if the user is not an admin of the space' do
    space = double(:space)
    allow(Space).to receive(:find_by_name!) {space}
    allow(space).to receive(:admin?).with(user) {false}

    get :show, id: 'co-up'

    expect(response.status).to eq(403)
  end

  it 'assigns the space' do
    space = double(:space).as_null_object
    allow(Space).to receive(:find_by_name!) {space}

    get :show, id: 'co-up'

    expect(assigns(:space)).to eq(space)
  end
end
