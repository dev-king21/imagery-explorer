class AddOpentrailviewToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :opentrailview, :hstore
  end
end
