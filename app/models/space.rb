class Space < ActiveRecord::Base
  before_create :set_name
  has_many :categories

  def to_param
    name
  end

  private

  def set_name
    self.name = url.split('/').last
  end
end