class Picture < ActiveRecord::Base
	belongs_to :photoalbum
	belongs_to :visibility
	
  	accepts_nested_attributes_for :visibility
end
