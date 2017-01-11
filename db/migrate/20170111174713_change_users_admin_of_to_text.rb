class ChangeUsersAdminOfToText < ActiveRecord::Migration
  def change
    change_column :users, :admin_of, :text
  end
end
