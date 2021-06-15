class AddTourerConnectionPhotoToPhoto < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :tourer_connection_photo, :string
  end
end
