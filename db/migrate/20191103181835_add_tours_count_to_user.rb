class AddToursCountToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :tours_count, :integer, :default => 0

    User.reset_column_information
    User.all.each do |u|
      User.update_counters u.id, :tours_count => u.tours.length
    end
  end
  
  def down
    remove_column :users, :tours_count
  end
end
