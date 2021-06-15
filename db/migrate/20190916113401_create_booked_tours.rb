class CreateBookedTours < ActiveRecord::Migration[5.2]
  def change
    create_table :booked_tours do |t|
      t.references :tour, foreign_key: true
      t.references :tour_book, foreign_key: true

      t.timestamps
    end
  end
end
