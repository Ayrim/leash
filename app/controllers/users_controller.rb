class UsersController < ApplicationController
	#before_create :check_valid_username

	def index
		@users = User.all
	end

	def new
		@user = User.new
	end

	def check_valid_email
		existing_user_mail = User.find_by(email: params[:user][:email])
		if(!existing_user_mail.nil?)
			flash.notice = "This emailadress is already in use."
			return false
		end
		return true
	end

	def create
		if(check_valid_email)
			@user = User.new(user_params)
			@user.save

			redirect_to root_path
		else
			#return redirect_to :action => 'new'
			redirect_to new_user_path
			#render :nothing => true, :status => 409
			
		end
	end

	def user_params
		params.require(:user).permit(:firstname, :lastname, :email, :password, :language, :nationality, :phone, :birthdate)
	end
end
