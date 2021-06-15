class AddTermsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :terms, :boolean
  end
end
