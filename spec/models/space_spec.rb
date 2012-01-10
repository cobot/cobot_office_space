require 'spec_helper'

describe Space, 'callbacks' do
  it 'sets the name on create' do
    space = Space.new(url: 'https://www.cobot.me/api/spaces/co-up')
    space.run_callbacks :create

    space.name.should == 'co-up'
  end
end

describe Space, '#to_param' do
  it 'returns the name' do
    Space.new(name: 'co-up').to_param.should == 'co-up'
  end
end

describe Space, 'admin?' do
  it 'returns true if the user is in the admin list' do
    Space.new(admins: ['joe@doe.com']).should be_admin(stub(:user, email: 'joe@doe.com'))
  end

  it 'returns false if the user is not in the admin list' do
    Space.new(admins: ['joe@doe.com']).should_not be_admin(stub(:user, email: 'jane@doe.com'))
  end

  it 'returns false if the space has no admins' do
    Space.new.should_not be_admin(stub(:user, email: 'jane@doe.com'))
  end
end
