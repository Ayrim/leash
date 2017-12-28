class Address < ActiveRecord::Base
  	belongs_to :user
  	belongs_to :city
  	belongs_to :country

  	accepts_nested_attributes_for :city
  	accepts_nested_attributes_for :country

    geocoded_by :street_address
    after_validation :geocode

    #after_validation :geocode, if: ->(obj){ (obj.city.present? and obj.city_changed?) or (obj.country.present? and obj.country_changed?) or (obj.street.present? and obj.street_changed?) }

    before_save :geocode
    before_create :geocode

  	def as_json(options={})
  		super(:only => [:id,:number,:numberAddition, :street, :latitude, :longitude, :distance],
        	:include => {
          		:city => {:only => [:id, :name, :postalcode]},
          		:country => {:only => [:id, :name, :ISO]}
        	}
  		)
	end

  def full_address
    "#{street}, #{number}, #{city.name}, #{country.name}"
  end

  def street_address
    "#{street}, #{city.name}, #{country.name}"
  end

end
