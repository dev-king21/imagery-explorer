class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.references :tour, foreign_key: true
      t.string :file_name
      t.datetime :taken_date_time
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.integer :elevation_meters
      t.float :heading
      t.string :country_code
      t.text :street_view_url
      t.text :street_view_thumbnail_url
      t.string :connection
      t.float :connection_distance_km
      t.string :tourer_photo_id

      t.timestamps
    end

    add_index :photos, :tourer_photo_id
  end
end
