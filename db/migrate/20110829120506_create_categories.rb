class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.belongs_to :space
      t.string :name
    end
  end

  def down
  end
end
