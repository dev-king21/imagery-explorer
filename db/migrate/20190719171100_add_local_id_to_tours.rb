class AddLocalIdToTours < ActiveRecord::Migration[5.2]
  def change
    add_column :tours, :local_id, :string
  end
end
