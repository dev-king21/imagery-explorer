class AddTourerVersionToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :tourer_version, :string
  end
end
