class RemoveColumn < ActiveRecord::Migration
  def change
  	remove_column :users, :experience
  end
end
