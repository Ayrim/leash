class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: [ :new, :create]
  #before_create :check_valid_email

	def index
		@users = User.all
	end

	def show
  end

  def settings
  end

	def new
		@hideNav = true;
		@showFooterSilhouette = true;
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
		@hideNav = true;
		@showFooterSilhouette = true;
		@user = User.new(user_params)

		begin
			ActiveRecord::Base.transaction do
				respond_to do |format|
					if @user.save
						@user.send_activation_email
				        format.html { redirect_to login_path(:anchor => "activation"), alert: 'Please check your email to activate your account.' }
				    else
				        format.html { render :new }
				        format.json { render json: @user.errors, status: :unprocessable_entity }
				    end
			  	end
		  	end
		rescue Net::OpenTimeout
			@showModal = true;
			flash.now.alert = "Something went wrong during registration. Please, try again later."
			render action: :new
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

  def editSettings
  end

  def update_profile
    respond_to do |format|
      if ((current_user.update_attribute(:firstname, params[:user][:firstname]) if params[:user][:firstname]) && (current_user.update_attribute(:lastname, params[:user][:lastname]) if params[:user][:lastname]) && (current_user.update_attribute(:email, params[:user][:email]) if params[:user][:email]) && (current_user.update_attribute(:birthdate, params[:user][:birthdate]) if params[:user][:birthdate]) && (current_user.update_attribute(:description, params[:user][:description]) if params[:user][:description])&& (current_user.update_attribute(:number_of_walks, params[:user][:number_of_walks]) if params[:user][:number_of_walks]) && (current_user.update_attribute(:walking_region, params[:user][:walking_region]) if params[:user][:walking_region]) && (current_user.update_attribute(:skills, params[:user][:skills]) if params[:user][:skills]))
        format.html { redirect_to edit_settings_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :editSettings }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end


  def update_contactinfo
    respond_to do |format|
      if(!current_user.address)
        @city = City.find_by(name: params[:user][:address_attributes][:city_attributes][:name]);
        @country = Country.find_by(name: params[:user][:address_attributes][:country_attributes][:name]);
        current_user.address = Address.new(:street => params[:user][:address_attributes][:street], 
                                            :number => params[:user][:address_attributes][:number],
                                            :numberAddition => params[:user][:address_attributes][:numberAddition],
                                            :city => @city,
                                            :country => @country
                                            );
        current_user.update_attribute(:phone, params[:user][:phone]);
        format.html { render :editSettings }
      else
        @city = City.find_by(name: params[:user][:address_attributes][:city_attributes][:name]);
        if(!@city)
          @city = City.new(:name => params[:user][:address_attributes][:city_attributes][:name],
                            :postalcode => params[:user][:address_attributes][:city_attributes][:postalcode]);
          @city.save
        end
        @country = Country.find_by(name: params[:user][:address_attributes][:country_attributes][:name]);
        if(!@country)
          @country = Country.new(:name => params[:user][:address_attributes][:country_attributes][:name]);
          @country.save
        end

        if ((current_user.update_attribute(:phone, params[:user][:phone]) if params[:user][:phone]) && (current_user.address.update_attribute(:street, params[:user][:address_attributes][:street]) if params[:user][:address_attributes][:street]) && (current_user.address.update_attribute(:number, params[:user][:address_attributes][:number]) if params[:user][:address_attributes][:number]) && (current_user.address.update_attribute(:numberAddition, params[:user][:address_attributes][:numberAddition]) if params[:user][:address_attributes][:numberAddition]) && (current_user.address.update_attribute(:city, @city) if @city) && (current_user.address.update_attribute(:country, @country) if @country))
          format.html { redirect_to edit_settings_path, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: current_user }
        else
          format.html { render :editSettings }
          format.json { render json: current_user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update_password
    #respond_to do |format|
      puts params[:current_password]
      puts params[:user][:password]
      puts params[:user][:password_confirmation]
      if(login(current_user.email, params[:current_password]))
        if(current_user.update_attributes(user_password_params))
          @showModal = true;
          flash.now.notice = "Password was successfully updated."
          render action: :editSettings
        else
          @showSecurityAlert = true;
          flash.alert = current_user.errors.full_messages[0]
          redirect_to edit_settings_path(:anchor => "Security")
        end
      else
        #format.html { redirect_to edit_settings_path(:anchor => "Security"), notice: "The current password is incorrect." }
        @showSecurityAlert = true;
        flash.alert = "The current password specified is incorrect."
        redirect_to edit_settings_path(:anchor => "Security")
        #render action: :editSettings, anchor: "Security"
                #format.html { redirect_to edit_settings_path(:anchor => "Security") }
                #format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    #end
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
			params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation, :language, :nationality, :phone, :birthdate, :terms_of_service)
		end

    def user_password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

		def user_profile_params
			params.require(:user).permit(:firstname, :lastname, :email, :language, :nationality, :birthdate)
		end

    def user_contactInfo_params
      params.require(:user).permit(:phone, address_attributes: [:street, :number, :numberAddition, city: [:postalCode, :name], country:[:ISO, :name]])
    end
end
