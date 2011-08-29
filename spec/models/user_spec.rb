require 'spec_helper'

describe User, 'admin_of_space_names' do
  it 'returns the names of the spaces in admin_of' do
    user = User.new(admin_of: ['https://www.cobot.me/api/spaces/co-up'])
    user.admin_of_space_names.should == ['co-up']
  end
end