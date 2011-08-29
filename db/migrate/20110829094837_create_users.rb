class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :login, :email, :oauth_token, :admin_of
    end

    add_index :users, :login
  end

  def down
    drop_table :users
  end
end
