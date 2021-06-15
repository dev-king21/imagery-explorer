class AddFavoriteCaching < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :favoritor_score, :text
    add_column :users, :favoritor_total, :text

    add_column :photos, :favoritable_score, :text
    add_column :photos, :favoritable_total, :text
  end
end