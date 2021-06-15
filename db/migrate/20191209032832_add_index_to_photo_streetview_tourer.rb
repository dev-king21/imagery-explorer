class AddIndexToPhotoStreetviewTourer < ActiveRecord::Migration[5.2]
  def change
    add_index :photos, :streetview, using: :gin
    add_index :photos, :tourer, using: :gin
  end
end
