class RenameColumnCameraMadePhotos < ActiveRecord::Migration[5.2]
  def change
    rename_column :photos, :camera_made, :camera_make
  end
end
