class AddViewPointsCountToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :view_points_count, :integer, null: false, default: 0
  end
end
