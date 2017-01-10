class ResourcesController < ApplicationController
  inherit_resources
  before_filter :load_space
  belongs_to :category
  layout 'embed'

  def update
    super { space_category_path(@space, @category) }
  end

  def create
    super { space_category_path(@space, @category) }
  end

  def destroy
    super { space_category_path(@space, @category) }
  end

  private

  def load_space
    @space = Space.find_by_name! params[:space_id]
    check_permission @space
  end
end
