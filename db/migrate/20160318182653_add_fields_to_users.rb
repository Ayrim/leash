class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :description, :string
    add_column :users, :profile_picture, :string
    add_column :users, :banner_picture, :string
    add_column :users, :number_of_walks, :int
    add_column :users, :walking_region, :string
    add_column :users, :skills, :string
  end
end
