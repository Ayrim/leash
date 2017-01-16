module Api
  	module V1
		class AddressController < AuthenticationController
			
		  	# [GET] /api/city
		  	def get_addresses(api = true)
		  		if(authorization_required(api))
		  			if(api)
		  				render json: Address.includes(:city).includes(:country).all, status: :ok
		  			else
		  				return Address.includes(:city).includes(:country).all
		  			end
		  		end
		  	end

			# [GET] /api/adress/:id
			def get_address(api = true)
				begin
          			if(authorization_required(api))
          				if (params.has_key?(:id))
			              	if(params[:id] != 'update_unreadmessages')
			                	address = Address.includes(:city).includes(:country).where(:id => params[:id])
			                end
			            end

			            if(api)
			            	if(!address.nil?)
			                	render json: address, status: :ok
			              	else
			                	render json: nil, status: :not_found
			              	end
			            else
			              	if !address.nil?
			                	return address
			              	end
			            end
					end
		        rescue ActiveRecord::RecordNotFound
			        if(api)
			            render json: nil, status: :not_found
			        else
			            return nil
			        end
		        end
			end

			# [POST] /api/address
			def create_address(addressParams = nil, api = true)
				if(authorization_required(api))
			  		if(api)
			  			addressParams = params
			  		end

					address = Address.new(:street => addressParams[:street], 
			                                            :number => addressParams[:number],
			                                            :numberAddition => addressParams[:numberAddition],
			                                            :city => addressParams[:city],
			                                            :country => addressParams[:country]
			                                            );
					
				    if(api)
				    	if(!address.nil?)
							render json: address, status: :created
						else
							render json: nil, status: :internal_server_error
						end
				    else
						return address
					end
				end
			end

		  	# [GET] /api/city
		  	def get_cities(api = true)
		  		if(authorization_required(api))
		  			if(api)
		  				render json: City.all, status: :ok
		  			else
		  				return City.all
		  			end
		  		end
		  	end

			# [GET] /api/city/:id
			def get_city(api = true)
				begin
          			if(authorization_required(api))
          				if (params.has_key?(:id))
			              	if(params[:id] != 'update_unreadmessages')
			                	city = City.where(:id => params[:id])
			                end
			            end

			            if(api)
			            	if(!city.nil?)
			                	render json: city, status: :ok
			              	else
			                	render json: nil, status: :not_found
			              	end
			            else
			              	if !city.nil?
			                	return city
			              	end
			            end
					end
		        rescue ActiveRecord::RecordNotFound
			        if(api)
			            render json: nil, status: :not_found
			        else
			            return nil
			        end
		        end
			end

			# [POST] /api/city
			def create_city(cityParams = nil, api = true)
				if(authorization_required(api))
			  		if(api)
			  			cityParams = params
			  		end

				    city = City.find_by(name: cityParams[:name]);
				    if(!city)
				      	city = City.new(:name => cityParams[:name],
				                      	:postalcode => cityParams[:postalcode]);
				      	city.save
				    end

				    if(api)
				    	if(!city.nil?)
							render json: city, status: :created
						else
							render json: nil, status: :internal_server_error
						end
				    else
						return city
					end
				end
		  	end

		  	# [GET] /api/country
		  	def get_countries(api = true)
		  		if(authorization_required(api))
		  			if(api)
		  				render json: Country.all, status: :ok
		  			else
		  				return Country.all
		  			end
		  		end
		  	end

			# [GET] /api/country/:id
			def get_country(api = true)
				begin
          			if(authorization_required(api))
          				if (params.has_key?(:id))
			              	if(params[:id] != 'update_unreadmessages')
			                	country = Country.where(:id => params[:id])
			                end
			            end

			            if(api)
			            	if(!country.nil?)
			                	render json: country, status: :ok
			              	else
			                	render json: nil, status: :not_found
			              	end
			            else
			              	if !country.nil?
			                	return country
			              	end
			            end
					end
		        rescue ActiveRecord::RecordNotFound
			        if(api)
			            render json: nil, status: :not_found
			        else
			            return nil
			        end
		        end
			end

			# [POST] /api/country
		  	def create_country(countryParams = nil, api = true)
          		if(authorization_required(api))
			  		if(api)
			  			countryParams = params
			  		end

			  		country = Country.find_by(name: countryParams[:name]);
				    if(!country)
				      	country = Country.new(:name => countryParams[:name]);
				      	country.save
				    end

				    if(api)
				    	if(!country.nil?)
							render json: country, status: :created
						else
							render json: nil, status: :internal_server_error
						end
				    else
						return country
					end
				end
		  	end
		end
	end
end