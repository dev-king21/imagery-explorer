class RemovePhotoTourerPhotoIdIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :photos, column: [:tourer_photo_id, :tour_id], unique: true
    remove_index :photos, column: :tourer_photo_id
  end
end
