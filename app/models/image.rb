class Image < ActiveRecord::Base
  attr_accessible :caption, :comment_count, :created_timestamp, :height, :like_count, :src, :user_id, :width
  belongs_to :user

  def self.store_images user_id, images
  end
end
