class Space < ActiveRecord::Base
  before_create :set_name
  has_many :categories, dependent: :destroy
  has_many :resources, through: :categories, order: 'name'
  serialize :admins

  def to_param
    name
  end

  def admin?(user)
    (admins || []).include?(user.email)
  end

  def members
    cobot_client(User.where(email: admins).first.oauth_token)
      .get(subdomain, '/memberships', attributes: 'id,name')
      .map {|atts| Member.new(atts) }
  end

  private

  def subdomain
    name
  end

  def cobot_client(access_token)
    CobotClient::ApiClient.new access_token
  end

  def set_name
    self.name = url.split('/').last
  end
end
