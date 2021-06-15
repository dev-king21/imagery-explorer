class AddTourBooksCountToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :tour_books_count, :integer, :default => 0

    User.reset_column_information
    User.all.each do |u|
      User.update_counters u.id, :tour_books_count => u.tour_books.length
    end
  end
  
  def down
    remove_column :users, :tour_books_count
  end
end
