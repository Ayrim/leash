class CreateAvailabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :availabilities do |t|
      t.boolean :monday_morning
      t.boolean :monday_midday
      t.boolean :monday_evening

      t.boolean :tuesday_morning
      t.boolean :tuesday_midday
      t.boolean :tuesday_evening
      t.boolean :wednesday_morning
      t.boolean :wednesday_midday
      t.boolean :wednesday_evening
      t.boolean :thursday_morning
      t.boolean :thursday_midday
      t.boolean :thursday_evening
      t.boolean :friday_morning
      t.boolean :friday_midday
      t.boolean :friday_evening
      t.boolean :saturday_morning
      t.boolean :saturday_midday
      t.boolean :saturday_evening
      t.boolean :sunday_morning
      t.boolean :sunday_midday
      t.boolean :sunday_evening

      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
