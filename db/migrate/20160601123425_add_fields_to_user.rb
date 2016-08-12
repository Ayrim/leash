class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_premium, :boolean, :default => false
    add_column :users, :experience, :string
    add_column :users, :pricing, :string
    add_column :users, :professional, :boolean, :default => false
  end
end
