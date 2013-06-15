class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :user_id
      t.string :src
      t.integer :like_count
      t.integer :comment_count
      t.integer :created_timestamp
      t.string :caption
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
