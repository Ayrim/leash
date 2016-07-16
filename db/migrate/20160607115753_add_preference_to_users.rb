class AddPreferenceToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :preference, index: true, foreign_key: true
  end
end
