class SessionsController < ApplicationController
  skip_before_filter :authenticate, only: [:new, :create, :failure]

  def new
    redirect_to spaces_path if current_user
  end

  def create
    auth = request.env['omniauth.auth']
    user = create_or_update_user(auth)
    session[:user_id] = user.id
    auth['extra']['raw_info']['admin_of'].each do |hash|
      space = create_or_update_space(hash['space_link'], auth['info']['email'])
    end
    redirect_to session[:return_to] || spaces_path
  end

  def failure
    flash[:failure] = "There was a problem: #{params[:message]}"
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'You have signed out.'
    redirect_to root_path
  end

  private

  def create_or_update_space(url, email)
    if space = Space.find_by_url(url)
      space.update_attribute :admins, (space.admins || []) | [email]
    else
      space = Space.create url: url, admins: [email]
    end
    space
  end

  def create_or_update_user(auth)
    unless @user
      if @user = User.find_by_email(auth['info']['email'])
        @user.update_attributes user_attributes(auth)
      else
        @user = User.create user_attributes(auth)
      end
    end
    @user
  end

  def user_attributes(auth)
    {
      email: auth['info']['email'],
      oauth_token: auth['credentials']['token'],
      admin_of: auth['extra']['raw_info']['admin_of'].map {|hash| hash['space_link'] }
    }
  end

  def cobot_client
    @cobot_client ||= CobotClient::ApiClient.new(current_user.oauth_token)
  end
end
