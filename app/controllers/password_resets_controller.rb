class PasswordResetsController < ApplicationController
	before_action :get_user, 		only: [:edit, :update]
	before_action :valid_user, 		only: [:edit, :update]
	before_action :check_expiration, only: [:edit, :update]

  def new
    @hideNav = true;
    @showFooterSilhouette = true;
  end

  def create
    @hideNav = true;
    @showFooterSilhouette = true;

    begin
      ActiveRecord::Base.transaction do
      	@user = User.find_by(email: params[:password_reset][:email].downcase)
      	if @user
      		@user.create_reset_digest
      		@user.send_password_reset_email
      		#flash[:alert] = "An email with your password has been sent."
      		redirect_to login_path(:anchor => "password")
      	else
          @showModal = true;
      		flash.now[:alert] = "The provided email address doesn't seem to be in use."
      		render 'new'
      	end
      end
    rescue Net::OpenTimeout
      @showModal = true;
      flash.now.alert = "Something went wrong while resetting your password. Please, try again later."
      render action: :new
    end
  end

  def edit
    @hideNav = true;
  end

  def update
  	if params[:user][:password].empty?
    	@user.errors.add(:password, "can't be empty");
      	render 'edit'
    elsif @user.update_attributes(user_params)
      	#session[:user_id] = @user.id
      	#current_user = @user

      	flash[:notice] = "Password has been reset."
      	redirect_to login_path(:anchor => "passwordreset")
    else
      	render 'edit'
    end
  end

  private
  	def user_params
  		params.require(:user).permit(:password, :password_confirmation)
  	end

  	# Before filters

  	def get_user
  		@user = User.find_by(email: params[:email])
  	end

  	# Confirms a valid user
  	def valid_user
  		unless(@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
  			redirect_to overview_path
  		end
  	end

	# Checks expiration of reset token.
    def check_expiration
      	if @user.password_reset_expired?
          @showModal = true;
          flash.now.alert = "Password reset has expired."
        	redirect_to new_password_reset_url
      	end
    end

end
