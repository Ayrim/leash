class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: [ :new, :create]
  #before_create :check_valid_email

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
		puts "login started"
		@user = User.new(user_params)
		puts "login completed"
		respond_to do |format|
			if @user.save
		        format.html { redirect_to login_path, notice: 'User was successfully created.' }
		    else
		        format.html { render :new }
		        format.json { render json: @user.errors, status: :unprocessable_entity }
		    end
	  	end
	end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

	private 
    	def set_user
      		@user = User.find(params[:id])
    	end

		def user_params
			params.require(:user).permit(:firstname, :lastname, :email, :password, :language, :nationality, :phone, :birthdate)
		end
end
