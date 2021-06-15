class RemoveTableViewPoints < ActiveRecord::Migration[5.2]
  def change
    drop_table :view_points
  end
end
