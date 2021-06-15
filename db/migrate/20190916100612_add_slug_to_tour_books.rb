class AddSlugToTourBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :tour_books, :slug, :string
    add_index :tour_books, :slug, unique: true
  end
end
