class AddStreetViewIdToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :streetview_id, :string
  end
end
