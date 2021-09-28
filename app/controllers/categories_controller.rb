class CategoriesController < ApplicationController
  before_action :load_space, :check_permission_filter
  layout 'embed'

  def new
    @category = @space.categories.build
  end

  def create
    @category = @space.categories.create category_params
    if @category.valid?
      @category.no_of_resources.to_i.times do |i|
        @category.resources.create name: "#{@category.name} #{'%.2d' % (i+1)}"
      end
      redirect_to space_category_path(@space, @category)
    end
  end

  def show
    @category = @space.categories.find params[:id]
  end

  def destroy
    category = @space.categories.find params[:id]
    category.destroy
    redirect_to space_path(@space)
  end

  private

  def category_params
    params[:category].permit(:name, :no_of_resources)
  end

  def check_permission_filter
    check_permission @space
  end

  def load_space
    @space = Space.find_by_name! params[:space_id]
  end
end
