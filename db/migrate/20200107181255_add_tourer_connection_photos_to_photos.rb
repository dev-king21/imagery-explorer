class AddTourerConnectionPhotosToPhotos < ActiveRecord::Migration[5.2]
  def change
    if column_exists? :photos, :tourer_connection_photo
      remove_column :photos, :tourer_connection_photo
    end

    unless column_exists? :photos, :tourer_connection_photos
      add_column :photos, :tourer_connection_photos, :text, array: true, default: []
      add_index :photos, :tourer_connection_photos, using: 'gin'
    end
  end
end
