class CreatePhotoCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :photo_countries do |t|
      t.references :photo, foreign_key: true
      t.references :country, foreign_key: true

      t.timestamps
    end
  end
end
