class ReindexSlugInTours < ActiveRecord::Migration[5.2]
  def change
    remove_index :tours, :slug
    add_index :tours, [:slug, :user_id], :unique => true
  end
end
