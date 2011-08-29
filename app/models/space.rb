class Space < ActiveRecord::Base
  before_create :set_name

  def to_param
    name
  end

  private

  def set_name
    self.name = url.split('/').last
  end
end