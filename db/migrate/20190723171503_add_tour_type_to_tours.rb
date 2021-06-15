class AddTourTypeToTours < ActiveRecord::Migration[5.2]
  def change
    add_column :tours, :tour_type, :integer
  end
end
