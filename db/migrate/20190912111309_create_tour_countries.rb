class CreateTourCountries < ActiveRecord::Migration[5.2]
  def up
    create_table :tour_countries do |t|
      t.references :tour, foreign_key: true
      t.references :country, foreign_key: true

      t.timestamps
    end

    # Tour.find_each do |tour|
    #   TourCountry.create(tour_id: tour.id, country_id: tour.country_id)
    # end
  end

  def down
    drop_table :tour_countries
  end
end
