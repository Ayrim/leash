class AddMoreFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_walker, :boolean
  end
end
