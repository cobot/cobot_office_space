class Resource < ApplicationRecord
  belongs_to :category

  before_save :set_member_name

  def space
    category.space
  end

  private

  def set_member_name
    if member_cobot_id?
      self.member_name = space.members
        .find {|m| m.id == member_cobot_id }.name
    else
      self.member_name = nil
    end
  end
end
