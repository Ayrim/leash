class AddressController  < Api::V1::AddressController
	
	def create_address(addressParams)
		return super(addressParams, false)
	end

	def create_city(cityParams)
		return super(cityParams, false)
  	end

  	def create_country(countryParams)
		return super(countryParams, false)
  	end
end
