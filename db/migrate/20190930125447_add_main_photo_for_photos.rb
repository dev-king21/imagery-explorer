class AddMainPhotoForPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :main_photo, :boolean, default: false, null: false
  end
end
