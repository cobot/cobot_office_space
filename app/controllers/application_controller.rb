class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  before_filter :authenticate
  after_action :remove_x_frame_options

  private

  def remove_x_frame_options
    response.headers.except! 'X-Frame-Options'
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def authenticate
    redirect_to '/auth/cobot' unless current_user
  end

  def check_permission(space)
    if space.admin?(current_user)
      yield if block_given?
    else
      render file: 'public/403.html', status: 403, layout: false
    end
  end
end
