class ResourcesController < ApplicationController
  inherit_resources
  before_filter :load_space


  belongs_to :category

  private

  def load_space
    @space = Space.find_by_name! params[:space_id]
  end
end