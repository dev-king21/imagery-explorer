class AddTourBooksCountToTours < ActiveRecord::Migration[5.2]
  def self.up
    add_column :tours, :booked_tours_count, :integer, null: false, default: 0
    # BookedTour.counter_culture_fix_counts
  end

  def self.down
    remove_column :tours, :tour_books_count
  end
end
