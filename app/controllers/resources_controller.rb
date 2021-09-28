class ResourcesController < ApplicationController
  before_action :load_space, :load_category
  layout 'embed'

  def show
    @resource = @category.resources.find params[:id]
  end

  def update
    @resource = @category.resources.find params[:id]
    @resource.attributes = resource_params
    if @resource.save
      redirect_to space_category_path(@space, @category)
    else
      render 'edit'
    end
  end

  def new
    @resource = @category.resources.build
  end

  def create
    @resource = @category.resources.create resource_params
    if @resource.valid?
      redirect_to space_category_path(@space, @category)
    else
      render 'new'
    end
  end

  def destroy
    resource = @category.resources.find params[:id]
    resource.destroy
    redirect_to space_category_path(@space, @category)
  end

  private

  def resource_params
    params[:resource].permit(:member_cobot_id, :name)
  end

  def load_space
    @space = Space.find_by_name! params[:space_id]
    check_permission @space
  end

  def load_category
    @category = @space.categories.find params[:category_id]
  end
end
