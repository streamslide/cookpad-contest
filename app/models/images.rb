class Images < ActiveRecord::Base
  attr_accessible :caption, :comment_count, :created_timestamp, :height, :like_count, :src, :user_id, :width
  belongs_to :user
end
