class Category < ActiveRecord::Base
  belongs_to :space
  has_many :resources, order: 'name', dependent: :destroy

  attr_accessor :no_of_resources
end