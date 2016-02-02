class AccountActivationsController < ApplicationController
  	def edit
    	user = User.find_by(email: params[:email])
    	if user && !user.activated? && user.authenticated?(:activation, params[:id])
      		user.activate

      		session[:user_id] = user.id
      		current_user = user

      		flash[:notice] = "Your account has now been activated!"
      		redirect_to users_path
    	else
      		flash[:danger] = "Invalid activation link"
      		redirect_to root_url
    	end
  	end
end
