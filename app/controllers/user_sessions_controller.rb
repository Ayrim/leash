class UserSessionsController < ApplicationController
	def new
		@hideNav = true;
		@showFooterSilhouette = true;
	end

	def create
		@hideNav = true;
		@showFooterSilhouette = true;
    	user = User.find_by(email: params[:email])

	    if user
	      	if user.activated?
				if(login(params[:email], params[:password], params[:remember]))
					if(!user.address)
						redirect_to edit_settings_path(:anchor => "complete_profile")
					else
						redirect_back_or_to(overview_path, notice: 'Logged in successfully.')
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

	def destroy
		logout
		redirect_to(:root, notice: 'Logged out!')
	end
end
