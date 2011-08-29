class CreateMembers < ActiveRecord::Migration
  def up
    create_table :members do |t|
      t.belongs_to :space
      t.string :name, :cobot_member_id
    end
    add_index :members, :space_id
  end

  def down
    drop_table :members
  end
end
