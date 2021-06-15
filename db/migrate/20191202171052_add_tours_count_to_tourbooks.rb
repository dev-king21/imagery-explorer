class AddToursCountToTourbooks < ActiveRecord::Migration[5.2]
  def change
    add_column :tourbooks, :tours_count, :integer, null: false, default: 0
  end
end
