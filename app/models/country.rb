class Country < ActiveRecord::Base
	has_many :addresses

	def as_json(options={})
  		super(:only => [:id, :name, :ISO])
    end
end
