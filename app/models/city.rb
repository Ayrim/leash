class City < ActiveRecord::Base
	has_many :addresses

	def as_json(options={})
  		super(:only => [:id, :name, :postalcode])
    end
end
