class AddPlusCodeCameraInfoToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :plus_code, :string
    add_column :photos, :camera_made, :boolean
    add_column :photos, :camera_model, :string
  end
end
