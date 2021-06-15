class RenameColumnTourBookId < ActiveRecord::Migration[5.2]
  def change
    rename_column :booked_tours, :tour_book_id, :tourbook_id
  end
end
