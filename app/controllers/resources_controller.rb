class ResourcesController < ApplicationController
  inherit_resources
  before_filter :load_space
  belongs_to :category

  def update
    super {
      space_category_path(@space, @category)
    }
  end

  private

  def load_space
    @space = Space.find_by_name! params[:space_id]
  end
end