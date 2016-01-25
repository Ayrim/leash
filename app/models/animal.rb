class Animal < ActiveRecord::Base
  belongs_to :user
  has_many :plannings
end
