class Address < ActiveRecord::Base
  	belongs_to :user
  	belongs_to :city
  	belongs_to :country

  	accepts_nested_attributes_for :city
  	accepts_nested_attributes_for :country

  	def as_json(options={})
  		super(:only => [:id,:number,:numberAddition, :street],
        	:include => {
          		:city => {:only => [:id, :name, :postalcode]},
          		:country => {:only => [:id, :name, :ISO]}
        	}
  		)
	end
end
