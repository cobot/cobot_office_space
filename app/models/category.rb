class Category < ApplicationRecord
  belongs_to :space
  has_many :resources, dependent: :destroy

  attr_accessor :no_of_resources
end
