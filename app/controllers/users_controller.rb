class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  #before_action :require_login, except: [:new]
	#before_create :check_valid_username

	def index
		@users = User.all
	end

	def show
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
  	
  	def edit
  	end

	def create
		#if(check_valid_email)
			@user = User.new(user_params)

		    respond_to do |format|
		      if @user.save
		        format.html { redirect_to users_path, notice: 'User was successfully created.' }
		      else
		        format.html { render :new }
		        format.json { render json: @user.errors, status: :unprocessable_entity }
		      end
		    end
		#else
			#@user = User.new
			#@user.errors = "This emailaddress is already in use."
			#return redirect_to :action => 'new'
			#redirect_to new_user_path
			#render :nothing => true, :status => 409
		#	@user = User.new
		#    respond_to do |format|
		#		format.html { render :new, notice: "This emailaddress is already in use." }
        #		format.json { render json: @user.errors, status: :unprocessable_entity }
        #	end
		#end
	end

	private 
    	def set_user
      		@user = User.find(params[:id])
    	end

		def user_params
			params.require(:user).permit(:firstname, :lastname, :email, :password, :language, :nationality, :phone, :birthdate)
		end
end
