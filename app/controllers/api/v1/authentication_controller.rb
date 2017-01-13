module Api
	module V1
		class AuthenticationController < ApplicationController

			private
				def authorization_required(api = true)
			        if(api)

			        	###
			         	# To do: validate if caller is logged in.
			         	# 1. Check if there is a authentication-header present
			         	if !request.headers["Auth-Token"]
			         		# 1.A if not - return unauthorized
				        	unauthorizedResponse()
			         	else
			         		# 1.B if it is - check if the token is still valid
			         		access_token = request.headers["Auth-Token"]

			         		apiKey = ApiKey.where("access_token = ? and expires_at > (now() at time zone 'utc')", access_token).order(created_at: :asc).first

			         		if !apiKey.nil?
			         			return true
			         		else
			         			if(ApiKey.where("access_token = ?", access_token).first.nil?)
			         				unauthorizedResponse()
			         			else
			         				unauthorizedResponse("Session expired")
			         			end
			         		end
			         	end
			         	###
			        else
			    		return true
			        end
			    end	

			    def unauthorizedResponse(message = "Access Denied")
			        @unauthorized = Unauthorizedexception.new
			        @unauthorized.message = message
			        @unauthorized.code = "401"
			        render json: @unauthorized, status: :unauthorized
			        return false;
			    end
		end
	end
end