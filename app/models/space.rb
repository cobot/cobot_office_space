class Space < ActiveRecord::Base
  before_create :set_name
  has_many :categories
  has_many :members, order: 'name'
  has_many :resources, through: :categories

  def to_param
    name
  end

  private

  def set_name
    self.name = url.split('/').last
  end
end