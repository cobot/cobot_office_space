class SpacesController < ApplicationController
  def index
    redirect_to space_path(current_user.admin_of_space_names.first)
  end

  def show
    @space = Space.find_by_name!(params[:id])
  end
end