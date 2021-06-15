class AddCodeToCountries < ActiveRecord::Migration[5.2]
  def change
    add_column :countries, :code, :string
  end
end
