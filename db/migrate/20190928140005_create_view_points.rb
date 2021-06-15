class CreateViewPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :view_points do |t|
      t.references :user
      t.references :photo

      t.timestamps
    end
  end
end
