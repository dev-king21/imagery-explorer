class AddIndexToToursNameUserId < ActiveRecord::Migration[5.2]
  def change
    add_index :tours, [:user_id, :name], unique: true
  end
end
