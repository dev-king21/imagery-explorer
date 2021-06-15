class CreateSubscription < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true
      t.integer :kind
    end
    add_index :subscriptions, [:kind, :user_id], unique: true
  end
end
