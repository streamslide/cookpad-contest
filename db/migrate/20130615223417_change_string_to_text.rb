class ChangeStringToText < ActiveRecord::Migration
  def up
    change_column :images, :caption, :text
    change_column :images, :src, :text
  end

  def down
    change_column :images, :caption, :string
    change_column :images, :src, :string
  end
end
