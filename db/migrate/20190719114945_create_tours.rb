class CreateTours < ActiveRecord::Migration[5.2]
  def change
    create_table :tours do |t|
      t.string :name
      t.text :description
      t.references :country, foreign_key: true
      t.references :user, foreign_key: true
      t.string :google_link

      t.timestamps
    end
  end
end
