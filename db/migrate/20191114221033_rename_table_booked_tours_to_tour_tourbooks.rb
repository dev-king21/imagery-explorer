class RenameTableBookedToursToTourTourbooks < ActiveRecord::Migration[5.2]
  def change
    rename_table :booked_tours, :tour_tourbooks
  end
end
