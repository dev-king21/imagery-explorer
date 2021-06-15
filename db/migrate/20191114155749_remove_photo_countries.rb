class RemovePhotoCountries < ActiveRecord::Migration[5.2]
  def change
    drop_table :photo_countries
  end
end
