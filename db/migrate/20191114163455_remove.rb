class Remove < ActiveRecord::Migration[5.2]
  def change
    remove_column :tours, :country_id, :integer
  end
end
