class Category < ActiveRecord::Base
  belongs_to :space
  has_many :resources

  attr_accessor :no_of_resources
end