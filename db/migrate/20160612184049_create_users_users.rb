class CreateUsersUsers < ActiveRecord::Migration
  def change
    create_table :connections, :id => false  do |t|
        t.references :user
        t.references :user
    end
    add_index :connections, [:user_id, :user_id]
  end
end
