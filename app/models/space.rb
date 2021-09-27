class Space < ActiveRecord::Base
  before_create :set_name
  has_many :categories, dependent: :destroy
  has_many :resources, through: :categories
  serialize :admins

  def to_param
    name
  end

  def admin?(user)
    (admins || []).include?(user.email)
  end

  def members
    admin_users = User.where(email: admins)
    begin
      cobot_client(admin_users.to_a.shift.oauth_token)
        .get(subdomain, '/memberships', attributes: 'id,name')
        .map {|atts| Member.new(atts) }
    rescue RestClient::Forbidden, RestClient::Unauthorized => e
      if admin_users.empty?
        raise e
      else
        update_attribute(:admins, admin_users.map(&:email))
        retry
      end
    end
  end

  def subdomain
    name
  end

  private

  def cobot_client(access_token)
    CobotClient::ApiClient.new access_token
  end

  def set_name
    self.name = url.split('/').last
  end
end
