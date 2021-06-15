class AddTrasportTypeToTours < ActiveRecord::Migration[5.2]
  def change
    add_column :tours, :transport_type, :integer
  end
end
