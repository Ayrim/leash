class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.boolean :monday_morning
      t.boolean :monday_midday
      t.boolean :monday_evening
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
