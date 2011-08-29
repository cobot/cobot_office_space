class CreateResources < ActiveRecord::Migration
  def up
    create_table :resources do |t|
      t.belongs_to :category, :member
      t.string :name
    end
    add_index :resources, :category_id
    add_index :resources, :member_id
  end

  def down
    drop_table :resources
  end
end
