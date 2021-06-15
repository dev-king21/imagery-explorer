class RenameColumnTourBooksCount < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :tour_books_count, :tourbooks_count
    rename_column :tours, :tour_books_count, :tourbooks_count
  end
end
