class RenameTableTourBooksToTourbooks < ActiveRecord::Migration[5.2]
  def change
    rename_table :tour_books, :tourbooks
  end
end
