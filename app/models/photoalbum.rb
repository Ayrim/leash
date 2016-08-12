class Photoalbum < ActiveRecord::Base
  belongs_to :user
  has_many :picture
  belongs_to :visibility
  
  accepts_nested_attributes_for :visibility
end
