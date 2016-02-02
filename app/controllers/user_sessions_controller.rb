class UserSessionsController < ApplicationController
	def new
	end

	def create
    	user = User.find_by(email: params[:email])

	    if user
	      	if user.activated?
				if(login(params[:email], params[:password], params[:remember]))
					redirect_back_or_to(users_path, notice: 'Logged in successfully.')
				else
					flash.now.alert = "Login failed."
					render action: :new
				end
			else
				flash.now.alert = "Account has not been activated yet."
				render action: :new
			end
		else
			flash.now.alert = "It seems that this email address is not in use."
			render action: :new
		end
	end

	def destroy
		logout
		redirect_to(:users, notice: 'Logged out!')
	end
end
