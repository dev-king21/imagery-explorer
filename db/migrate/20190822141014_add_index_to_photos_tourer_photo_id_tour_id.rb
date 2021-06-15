class AddIndexToPhotosTourerPhotoIdTourId < ActiveRecord::Migration[5.2]
  def change
    add_index :photos, [:tourer_photo_id, :tour_id], unique: true
  end
end
