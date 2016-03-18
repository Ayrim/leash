class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :city
  belongs_to :country

  accepts_nested_attributes_for :city
  accepts_nested_attributes_for :country
end
