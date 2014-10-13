class RemoveMembers < ActiveRecord::Migration
  def up
    add_column :resources, :member_cobot_id, :string
    add_column :resources, :member_name, :string
    execute 'update resources set member_name = (select name from members where id = resources.member_id)'
    execute 'update resources set member_cobot_id = (select cobot_member_id from members where id = resources.member_id)'
    drop_table :members
  end
end
