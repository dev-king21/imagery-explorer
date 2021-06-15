class AddCountryIdToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :country_id, :integer
    remove_column :photos, :country_code, :string
  end
end
