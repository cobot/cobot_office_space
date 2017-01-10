class Category < ActiveRecord::Base
  belongs_to :space
  has_many :resources, dependent: :destroy

  attr_accessor :no_of_resources
end
