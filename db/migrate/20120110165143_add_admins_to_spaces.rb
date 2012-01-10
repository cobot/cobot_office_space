class AddAdminsToSpaces < ActiveRecord::Migration
  def change
    add_column :spaces, :admins, :text
  end
end
