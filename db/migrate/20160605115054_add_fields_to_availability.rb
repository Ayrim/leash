class AddFieldsToAvailability < ActiveRecord::Migration
  def change
    add_column :availabilities, :tuesday_morning, :boolean
    add_column :availabilities, :tuesday_midday, :boolean
    add_column :availabilities, :tuesday_evening, :boolean
    add_column :availabilities, :wednesday_morning, :boolean
    add_column :availabilities, :wednesday_midday, :boolean
    add_column :availabilities, :wednesday_evening, :boolean
    add_column :availabilities, :thursday_morning, :boolean
    add_column :availabilities, :thursday_midday, :boolean
    add_column :availabilities, :thursday_evening, :boolean
    add_column :availabilities, :friday_morning, :boolean
    add_column :availabilities, :friday_midday, :boolean
    add_column :availabilities, :friday_evening, :boolean
    add_column :availabilities, :saturday_morning, :boolean
    add_column :availabilities, :saturday_midday, :boolean
    add_column :availabilities, :saturday_evening, :boolean
    add_column :availabilities, :sunday_morning, :boolean
    add_column :availabilities, :sunday_midday, :boolean
    add_column :availabilities, :sunday_evening, :boolean
  end
end
