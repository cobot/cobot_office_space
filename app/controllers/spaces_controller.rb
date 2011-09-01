require 'csv'

class SpacesController < ApplicationController
  def index
    if space = current_user.admin_of_space_names.first
      redirect_to space_path(space)
    end
  end

  def show
    @space = Space.find_by_name!(params[:id])
    respond_to do |format|
      format.html
      format.csv do
        render text: space_csv(@space), content_type: 'text/csv'
      end 
    end
  end

  private

  def space_csv(space)
    CSV.generate(col_sep: '|') do |csv|
      csv << ['Resource', 'Category', 'Member']
      space.resources(include: :member).each do |r|
        csv << [r.name, r.category.name, r.member.try(:name)]
      end
    end
  end
end