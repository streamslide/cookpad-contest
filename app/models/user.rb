class User < ActiveRecord::Base
  attr_accessible :access_token, :fb_user_id, :share_key
  has_many :images

  before_create :set_share_key

  def self.create_from_access_token access_token
    api = Koala::Facebook::GraphAPI.new(access_token)
    data = api.get_object('me')
    fb_user_id = data['id']

    user = User.find_by_fb_user_id(fb_user_id)
    if user
      User.find_by_fb_user_id(fb_user_id).update_attributes(:access_token => access_token)
    else
      user = User.create(:fb_user_id => fb_user_id, :access_token => access_token)
    end
    user
  end

  private
  def set_share_key
    self.share_key = UUIDTools::UUID.timestamp_create().to_s
  end

end
