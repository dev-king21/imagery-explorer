class AddTourerFieldsToTour < ActiveRecord::Migration[5.2]
  def up
    add_column :tours, :tourer_version, :string
    add_column :tours, :tourer_tour_id, :string
    remove_column :photos, :tourer_version, :string

    Tour.find_each do |tour|
      tour.update_column(:tourer_tour_id, tour.local_id)
    end

    remove_column :tours, :local_id, :string
    remove_column :tours, :google_link, :string
  end

  def down
    add_column :tours, :google_link, :string
    add_column :tours, :local_id, :string

    Tour.find_each do |tour|
      tour.update_column(:local_id, tour.tourer_tour_id)
    end

    add_column :photos, :tourer_version, :string
    remove_column :tours, :tourer_tour_id, :string
    remove_column :tours, :tourer_version, :string
  end
end
