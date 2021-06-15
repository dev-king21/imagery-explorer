class ChangePhotoColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :photos, :file_name, :string
    remove_column :photos, :heading, :float
    remove_column :photos, :street_view_url, :text
    remove_column :photos, :street_view_thumbnail_url, :text
    remove_column :photos, :connection, :string
    remove_column :photos, :connection_distance_km, :float
    remove_column :photos, :plus_code, :string
    remove_column :photos, :main_photo, :bool
    remove_column :photos, :streetview_id, :string
    remove_column :photos, :taken_date_time, :datetime

    add_column :photos, :taken_at, :datetime
    add_column :photos, :address, :hstore
    add_column :photos, :google, :hstore
    add_column :photos, :streetview, :hstore
    add_column :photos, :tourer, :hstore
  end
end
