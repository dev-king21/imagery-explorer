class RenameBookedToursCountColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :tours, :booked_tours_count, :tour_books_count
  end
end
