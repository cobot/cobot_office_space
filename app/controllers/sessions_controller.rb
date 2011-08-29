class SessionsController < ApplicationController
  skip_before_filter :authenticate, only: [:new, :create, :failure]

  def new
  end

  def create
    auth = request.env['omniauth.auth']
    user = create_or_update_user(auth)
    auth['extra']['user_hash']['admin_of'].each do |hash|
      Space.create url: hash['space_link'] unless Space.find_by_url(hash['space_link'])
    end
    session[:user_id] = user.id
    redirect_to spaces_path
  end

  def failure
    flash[:failure] = "Sorry, something went wrong. Please try again."
    redirect_to root_path
  end

  private

  def create_or_update_user(auth)
    unless @user
      if @user = User.find_by_login(auth['user_info']['name'])
        @user.update_attributes email: auth['user_info']['email'],
          admin_of: auth['extra']['user_hash']['admin_of'].map{|hash| hash['space_link']}
      else
        @user = User.create login: auth['user_info']['name'],
          email: auth['user_info']['email'],
          oauth_token: auth['credentials']['token'],
          admin_of: auth['extra']['user_hash']['admin_of'].map{|hash| hash['space_link']}
      end
    end
    @user
  end
end