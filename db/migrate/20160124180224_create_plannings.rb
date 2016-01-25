class CreatePlannings < ActiveRecord::Migration
  def change
    create_table :plannings do |t|
      t.date :startDate
      t.date :endDate
      t.string :schedule
      t.references :animal, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
