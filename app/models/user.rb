class User < ActiveRecord::Base
  serialize :admin_of

  def admin_of_space_names
    admin_of.map{|url| url.split('/').last}
  end
end