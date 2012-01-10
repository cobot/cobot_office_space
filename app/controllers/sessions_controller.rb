class SessionsController < ApplicationController
  skip_before_filter :authenticate, only: [:new, :create, :failure]

  def new
  end

  def create
    auth = request.env['omniauth.auth']
    user = create_or_update_user(auth)
    session[:user_id] = user.id
    auth['extra']['user_hash']['admin_of'].each do |hash|
      space = create_space(hash['space_link'])
      create_members(space)
    end
    redirect_to spaces_path
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

  def create_space(url)
    unless space = Space.find_by_url(url)
      space = Space.create url: url
    end
    space
  end

  def create_members(space)
    cobot_get("https://#{space.name}.cobot.me/api/memberships").each do |member_hash|
      unless space.members.find_by_cobot_member_id(member_hash['id'])
        space.members.create name: member_hash['address']['name'],
          cobot_member_id: member_hash['id']
      end
    end
  end

  def cobot_get(url)
    JSON.parse(oauth_token.get(url).body)
  end

  def create_or_update_user(auth)
    unless @user
      if @user = User.find_by_email(auth['user_info']['email'])
        @user.update_attributes admin_of: auth['extra']['user_hash']['admin_of'].map{|hash| hash['space_link']}
      else
        @user = User.create email: auth['user_info']['email'],
          oauth_token: auth['credentials']['token'],
          admin_of: auth['extra']['user_hash']['admin_of'].map{|hash| hash['space_link']}
      end
    end
    @user
  end

  def oauth_token
    unless @access_token
      @access_token = OAuth2::AccessToken.new(oauth_client, current_user.oauth_token)
      @access_token.options[:header_format] = "OAuth %s"
    end
    @access_token
  end

  def oauth_client
    @client ||= OAuth2::Client.new(ENV['COBOT_CLIENT_ID'],
      ENV['COBOT_CLIENT_SECRET'],
      site: {
         url: 'https://www.cobot.me',
         ssl: {
           verify: false
         }
      }
    )
  end
end
