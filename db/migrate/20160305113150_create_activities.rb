class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :flock
      t.references :user, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date
      t.integer :location
      t.integer :payment
      t.boolean :on_wall

      t.timestamps null: false
    end
  end
end
