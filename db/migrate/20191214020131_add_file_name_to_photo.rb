class AddFileNameToPhoto < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :filename, :string
  end
end
