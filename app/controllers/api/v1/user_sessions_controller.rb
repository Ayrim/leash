module Api
  	module V1
    	class UserSessionsController < AuthenticationController
      		before_action :require_login, except: [:sign_in]

      		# [POST] /api/signin
      		def sign_in(api = true, remember = false)
				user = User.find_by(email: params[:email])

			    if user
			      	if user.activated?
						if(login(params[:email], params[:password], remember))
							if api
								# token expires in 2 hours
								apiKey = ApiKey.where("user_id = ? and expires_at > (now() at time zone 'utc')", user.id).order(created_at: :asc).first
								if(!apiKey.nil?)
									apiKey.expires_at = DateTime.now + (2/24.0)
								else
									apiKey = ApiKey.new(:user_id => user.id, :access_token => SecureRandom.hex, :expires_at => DateTime.now + (2/24.0))
								end
								apiKey.save

								response.headers['Auth-Token'] = apiKey.access_token
								render json: user, status: :ok
							else
								if(!user.address)
									redirect_to edit_settings_path(:anchor => "complete_profile")
								else
									redirect_back_or_to(overview_path, notice: 'Logged in successfully.')
								end
							end
						else
							@showModal = true;
							flash.now.alert = "Login failed."
							render action: :new
						end
					else
						@showModal = true;
						flash.now.alert = "Account has not been activated yet."
						render action: :new
					end
				else
					@showModal = true;
					flash.now.alert = "It seems that this email address is not in use."
					render action: :new
				end
			end

      		# [GET] /api/signout
      		def sign_out(api = true)
				if api
					if request.headers['Auth-Token']
						accessToken = request.headers['Auth-Token']

						apiKey = ApiKey.where('access_token = ?', accessToken).destroy_all
						render json: "SignedOut", status: :ok
					end
				else
					logout
					redirect_to(:root, notice: 'Logged out!')
				end
			end
  		end
	end
end