class Picture < ActiveRecord::Base
	belongs_to :photo_album
	belongs_to :visibility

  	accepts_nested_attributes_for :visibility
end
