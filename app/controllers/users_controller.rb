class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: [ :new, :create]
  #before_create :check_valid_email
  
	def index
		#@users = User.all


	end

	def show
    if (params.has_key?(:id))
      $show_user = User.find(params[:id])
    else
      $show_user = current_user;
    end

    settings();
  end

  def settings
    @dontSetBodyHeight = true;
    w = WallpostController.new
    w.request = @_request
    w.index

    #render :controller => 'wallpost/index'

    #puts current_user.to_json

    # get the 10 most recent wallposts which contain a picture
    # userIdQuery = "user_id != " + current_user.id.to_s
    # posts = Wallpost.order(created_at: :desc).where(userIdQuery).where("picture is not NULL").limit(10)
    #posts = Wallpost.order(created_at: :desc).where("picture is not NULL").limit(10)
    # take 3 random wallposts from these 10
    #@PicturePosts = posts.shuffle.take(6)

    if (params.has_key?(:id))
      show_user = User.find(params[:id])
    else
      show_user = current_user;
    end
    if current_user.id == show_user.id
      @Pictures = Picture.joins(:photoalbum).where('user_id = ?', show_user.id).order(created_at: :desc).limit(6)
    elsif (current_user.connections.include?(show_user))
      @Pictures = Picture.joins(:photoalbum).where('(user_id = ? AND (photoalbums.visibility_id = ? OR photoalbums.visibility_id = ?)) AND (pictures.visibility_id = ? OR pictures.visibility_id = ?)', show_user.id, '2', '1', '2', '1').order(created_at: :desc).limit(6)
    else
      @Pictures = Picture.joins(:photoalbum).where('(user_id = ? AND (photoalbums.visibility_id = ? = ?)) AND (pictures.visibility_id = ?)', show_user.id, '1', '1').order(created_at: :desc).limit(6)
    end
        
  end

	def new
		@hideNav = true;
		@showFooterSilhouette = true;
		@user = User.new
    @isRegistration = true
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
    @dontSetBodyHeight = true;
  end

	def create
		@hideNav = true;
		@showFooterSilhouette = true;
		@user = User.new(user_params)
    @isRegistration = true
		begin
			ActiveRecord::Base.transaction do
				respond_to do |format|
					if @user.save
            @globalAlbum = Photoalbum.new(:user_id => @user.id, :name => "No Album")
            @globalAlbum.save
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
    @dontSetBodyHeight = true;
    @preferences = Preference.all
    @experiences = Experience.all
  end

  def update_profile
    @dontSetBodyHeight = true;
    @preferences = Preference.all
    @experiences = Experience.all

  #puts params
  # TO DO:
  # Save pictures to Azure Blob Storage or Amazon S3
  # Save the link towards the uploaded picture for this user.
    puts "COPYING PICTURE"
    save_banner_picture_path = ""
    save_profile_picture_path = ""
    if(params[:user][:profile_picture])
      # Blob Container exists => move on!
      fileExtension = File.extname(params[:user][:profile_picture].original_filename)

      fileName = current_user.id.to_s + '_' + SecureRandom.uuid + fileExtension
      blobs = Azure::Blob::BlobService.new
      content = File.open(params[:user][:profile_picture].tempfile.path, 'rb') { |file| file.read }
      blob = blobs.create_block_blob("images", fileName, content)

      #Blob has been uploaded
      save_profile_picture_path = 'https://' + Azure.config.storage_account_name + '.blob.core.windows.net/images/' + fileName
    end

    if(params[:user][:banner_picture])
      # Blob Container exists => move on!
      fileExtension = File.extname(params[:user][:banner_picture].original_filename)

      fileName = current_user.id.to_s + '_' + SecureRandom.uuid + fileExtension
      blobs = Azure::Blob::BlobService.new
      content = File.open(params[:user][:banner_picture].tempfile.path, 'rb') { |file| file.read }
      blob = blobs.create_block_blob("images", fileName, content)

      #Blob has been uploaded
      save_banner_picture_path = 'https://' + Azure.config.storage_account_name + '.blob.core.windows.net/images/' + fileName
    end
    puts "END COPYING PICTURE"


    respond_to do |format|
      if ([(current_user.update_attribute(:banner_picture, save_banner_picture_path) if params[:user][:banner_picture])] && [(current_user.update_attribute(:profile_picture, save_profile_picture_path) if params[:user][:profile_picture])] && (current_user.update_attribute(:firstname, params[:user][:firstname]) if params[:user][:firstname]) && (current_user.update_attribute(:lastname, params[:user][:lastname]) if params[:user][:lastname]) && (current_user.update_attribute(:email, params[:user][:email]) if params[:user][:email]) && (current_user.update_attribute(:birthdate, params[:user][:birthdate]) if params[:user][:birthdate]) && (current_user.update_attribute(:description, params[:user][:description]) if params[:user][:description]))
        format.html { redirect_to edit_settings_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :editSettings }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_walker_profile
    @dontSetBodyHeight = true;
    @preferences = Preference.all
    @experiences = Experience.all

    if(!current_user.availability)
      current_user.availability = Availability.new(:monday_morning => ConvertToBooleanValue(params[:user][:availability_attributes][:monday_morning]),
                                        :monday_midday => ConvertToBooleanValue(params[:user][:availability_attributes][:monday_midday]),
                                        :monday_evening => ConvertToBooleanValue(params[:user][:availability_attributes][:monday_evening]),
                                        :tuesday_morning => ConvertToBooleanValue(params[:user][:availability_attributes][:tuesday_morning]),
                                        :tuesday_midday => ConvertToBooleanValue(params[:user][:availability_attributes][:tuesday_midday]),
                                        :tuesday_evening => ConvertToBooleanValue(params[:user][:availability_attributes][:tuesday_evening]),
                                        :wednesday_morning => ConvertToBooleanValue(params[:user][:availability_attributes][:wednesday_morning]),
                                        :wednesday_midday => ConvertToBooleanValue(params[:user][:availability_attributes][:wednesday_midday]),
                                        :wednesday_evening => ConvertToBooleanValue(params[:user][:availability_attributes][:wednesday_evening]),
                                        :thursday_morning => ConvertToBooleanValue(params[:user][:availability_attributes][:thursday_morning]),
                                        :thursday_midday => ConvertToBooleanValue(params[:user][:availability_attributes][:thursday_midday]),
                                        :thursday_evening => ConvertToBooleanValue(params[:user][:availability_attributes][:thursday_evening]),
                                        :friday_morning => ConvertToBooleanValue(params[:user][:availability_attributes][:friday_morning]),
                                        :friday_midday => ConvertToBooleanValue(params[:user][:availability_attributes][:friday_midday]),
                                        :friday_evening => ConvertToBooleanValue(params[:user][:availability_attributes][:friday_evening]),
                                        :saturday_morning => ConvertToBooleanValue(params[:user][:availability_attributes][:saturday_morning]),
                                        :saturday_midday => ConvertToBooleanValue(params[:user][:availability_attributes][:saturday_midday]),
                                        :saturday_evening => ConvertToBooleanValue(params[:user][:availability_attributes][:saturday_evening]),
                                        :sunday_morning => ConvertToBooleanValue(params[:user][:availability_attributes][:sunday_morning]),
                                        :sunday_midday => ConvertToBooleanValue(params[:user][:availability_attributes][:sunday_midday]),
                                        :sunday_evening => ConvertToBooleanValue(params[:user][:availability_attributes][:sunday_evening]));
    end

    respond_to do |format|
      if ((current_user.update_attribute(:number_of_walks, params[:user][:number_of_walks]) if params[:user][:number_of_walks]) && (current_user.update_attribute(:walking_region, params[:user][:walking_region]) if params[:user][:walking_region]) && (current_user.update_attribute(:skills, params[:user][:skills]) if params[:user][:skills]) && (current_user.update_attribute(:professional, ConvertToBooleanValue(params[:user][:professional])))  && (current_user.availability.update_attribute(:monday_morning, ConvertToBooleanValue(params[:user][:availability_attributes][:monday_morning]))) && (current_user.availability.update_attribute(:monday_midday, ConvertToBooleanValue(params[:user][:availability_attributes][:monday_midday]))) && (current_user.availability.update_attribute(:monday_evening, ConvertToBooleanValue(params[:user][:availability_attributes][:monday_evening]))) && (current_user.availability.update_attribute(:tuesday_morning, ConvertToBooleanValue(params[:user][:availability_attributes][:tuesday_morning]))) && (current_user.availability.update_attribute(:tuesday_midday, ConvertToBooleanValue(params[:user][:availability_attributes][:tuesday_midday]))) && (current_user.availability.update_attribute(:tuesday_evening, ConvertToBooleanValue(params[:user][:availability_attributes][:tuesday_evening]))) && (current_user.availability.update_attribute(:wednesday_morning, ConvertToBooleanValue(params[:user][:availability_attributes][:wednesday_morning]))) && (current_user.availability.update_attribute(:wednesday_midday, ConvertToBooleanValue(params[:user][:availability_attributes][:wednesday_midday]))) && (current_user.availability.update_attribute(:wednesday_evening, ConvertToBooleanValue(params[:user][:availability_attributes][:wednesday_evening]))) && (current_user.availability.update_attribute(:thursday_morning, ConvertToBooleanValue(params[:user][:availability_attributes][:thursday_morning]))) && (current_user.availability.update_attribute(:thursday_midday, ConvertToBooleanValue(params[:user][:availability_attributes][:thursday_midday]))) && (current_user.availability.update_attribute(:thursday_evening, ConvertToBooleanValue(params[:user][:availability_attributes][:thursday_evening]))) && (current_user.availability.update_attribute(:friday_morning, ConvertToBooleanValue(params[:user][:availability_attributes][:friday_morning]))) && (current_user.availability.update_attribute(:friday_midday, ConvertToBooleanValue(params[:user][:availability_attributes][:friday_midday]))) && (current_user.availability.update_attribute(:friday_evening, ConvertToBooleanValue(params[:user][:availability_attributes][:friday_evening]))) && (current_user.availability.update_attribute(:saturday_morning, ConvertToBooleanValue(params[:user][:availability_attributes][:saturday_morning]))) && (current_user.availability.update_attribute(:saturday_midday, ConvertToBooleanValue(params[:user][:availability_attributes][:saturday_midday]))) && (current_user.availability.update_attribute(:saturday_evening, ConvertToBooleanValue(params[:user][:availability_attributes][:saturday_evening]))) && (current_user.availability.update_attribute(:sunday_morning, ConvertToBooleanValue(params[:user][:availability_attributes][:sunday_morning]))) && (current_user.availability.update_attribute(:sunday_midday, ConvertToBooleanValue(params[:user][:availability_attributes][:sunday_midday]))) && (current_user.availability.update_attribute(:sunday_evening, ConvertToBooleanValue(params[:user][:availability_attributes][:sunday_evening]))) && (current_user.update_attribute(:preference, Preference.find(params[:user][:preference].to_i)) if params[:user][:preference]) && (current_user.update_attribute(:is_walker, ConvertToBooleanValue(params[:user][:is_walker])))  && (current_user.update_attribute(:experience, Experience.find(params[:user][:experience].to_i)) if params[:user][:experience]))
        format.html { redirect_to edit_settings_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :editSettings }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end

  end

  def update_contactinfo
    @dontSetBodyHeight = true;
    @preferences = Preference.all
    @experiences = Experience.all
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
    @dontSetBodyHeight = true;
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
        if (params.has_key?(:id))
          @user = User.find(params[:id])
        else
          @user = current_user;
        end
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

    def ConvertToBooleanValue(incomingValue)
      if incomingValue
        return true;
      else
        return false;
      end
    end
end
