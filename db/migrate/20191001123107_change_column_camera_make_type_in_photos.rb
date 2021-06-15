class ChangeColumnCameraMakeTypeInPhotos < ActiveRecord::Migration[5.2]
  def up
    change_column :photos, :camera_make, :string
  end

  def down
    change_column :photos, :camera_make, :boolean
  end
end
