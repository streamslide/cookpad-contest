class Image < ActiveRecord::Base
  attr_accessible :caption, :comment_count, :created_timestamp, :height, :like_count, :src, :user_id, :width, :created_at
  belongs_to :user

  def self.store_images user_id, images
    user = User.find(user_id)
    images.each do |image|
      user.images.build(
        :caption => image[:caption], :comment_count => image[:comment_count],
        :like_count => image[:like_count], :created_timestamp => image[:created],
        :src => image[:src], :height => image[:height], :width => image[:width]
      )
    end
    user.save
  end
end
