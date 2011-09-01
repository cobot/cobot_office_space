class CategoriesController < ApplicationController
  inherit_resources
  belongs_to :space, :finder => :find_by_name!

  def create
    super do |success, failure|
      success.html do
        @category.no_of_resources.to_i.times do |i|
          @category.resources.create name: "#{@category.name} #{'%.2d' % (i+1)}"
        end
        redirect_to [@space, @category]
      end
    end
  end

  def destroy
    super do
      space_path(@space)
    end  
  end
end