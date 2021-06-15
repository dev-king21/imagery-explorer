class RemoveCountriesFromTours < ActiveRecord::Migration[5.2]
  def change
    drop_table :tour_countries
  end
end
