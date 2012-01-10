class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  before_filter :authenticate

  private

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def authenticate
    unless current_user
      redirect_to root_path, notice: "Please sign in"
    end
  end

  def check_permission(space)
    if space.admin?(current_user)
      yield if block_given?
    else
      render file: 'public/403.html', status: 403, layout: false
    end
  end

end
