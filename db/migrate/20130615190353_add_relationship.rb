class AddRelationship < ActiveRecord::Migration
  def up
    change_table :images do |t|
      t.references :users
    end
  end

  def down
  end
end
