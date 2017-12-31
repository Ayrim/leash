class UsersController < Api::V1::UsersController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: [ :new, :create]
  #before_create :check_valid_email
  
  # API
  # The methods available through the API are located in the base-class Api::V1::UsersController
  # This gives a better overview of the methods that will be available through the API
  # also provides a way of versioning the API 

  def index
    # show overview of users (both walkers and non-walkers)
    # allow user to filter on (non-)walkers
    # position of these people should be shown on a map (aprox. not exact)

    # start with 10 users
    # radius = 10km
    LoadNearbyUsers(10, false, current_user.id);
  end

  def refresh_users

    puts '----------------------------------------------------------------'
    puts params.to_json
    puts '----------------------------------------------------------------'

    if(params[:filterAddress].to_s == "otherAddress")
      # define long/lat by given address
      puts ' 1. ============================================'
      cityParams = params[:user][:address_attributes][:city_attributes]
      otherCity = City.new(:name => cityParams[:name].titleize,
                                :postalcode => cityParams[:postalcode])
      puts ' 2. ============================================'
      countryParams = params[:user][:address_attributes][:country_attributes]
      otherCountry = Country.new(:name => countryParams[:name].titleize);
      puts ' 3. ============================================'
      address_params = params[:user][:address_attributes]
      puts ' 4. ============================================'
      otherAddress = Address.new(:street => address_params[:street], 
                                  :number => address_params[:number],
                                  :city => otherCity,
                                  :country => otherCountry
                                )
      puts ' 5. ============================================'
      puts otherAddress.full_address
      puts ' 6. ============================================'

      LoadNearbyUsers(params[:user][:address].to_i, false, current_user.id, otherAddress);
    else
      # define radius based on home-location
      LoadNearbyUsers(params[:user][:address].to_i, false, current_user.id);
    end


    respond_to do |format|
      format.html { render :index }
      format.js { render 'users/index_refresh_users.js.erb' }
    end
  end

	def show
    if(params[:id] != 'update_unreadmessages')
      $show_user = get_user(false)
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

    if(params[:id] != 'update_unreadmessages')
      show_user = get_user(false)
    end

    if(show_user.nil?)
      show_user = $show_user
    end

    if !show_user.nil?
      if current_user.id == show_user.id
        @Pictures = Picture.joins(:photoalbum).where('user_id = ?', show_user.id).order(created_at: :desc).limit(6)
      elsif (current_user.connections.include?(show_user))
        @Pictures = Picture.joins(:visibility).joins(:photoalbum).joins(:photoalbum => :visibility).where('(user_id = ? AND (visibilities_photoalbums.value = ? OR visibilities_photoalbums.value = ?)) AND (visibilities.value = ? OR visibilities.value = ?)', show_user.id, 'Connections', 'Public', 'Connections', 'Public').order("pictures.created_at desc").limit(6)
        #@Pictures = Picture.joins(:visibility).joins(:photoalbum).where('(user_id = ? AND (visibilities.value = ? OR visibilities.value = ?))', show_user.id, 'Connections', 'Public').order("pictures.created_at desc").limit(6)
      else
        @Pictures = Picture.joins(:visibility).joins(:photoalbum).joins(:photoalbum => :visibility).where('(user_id = ? AND (visibilities_photoalbums.value = ?)) AND (visibilities.value = ?)', show_user.id, 'Public', 'Public').order("pictures.created_at desc").limit(6)
      end
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
		@user = sign_up(user_params, false);
    @isRegistration = true

		begin
			ActiveRecord::Base.transaction do
				respond_to do |format|
          if !@user.nil?
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

    respond_to do |format|
      if(update_user(params, false))
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

    respond_to do |format|
      if (update_walker(params, false))
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
      if(update_contactInfo(params, false))
        format.html { redirect_to edit_settings_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :editSettings }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_password
    @dontSetBodyHeight = true;
    #respond_to do |format|
      
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


  def send_invitation
    set_user()

    connection = UserRelation.new()
    connection.user_1_id = current_user.id;
    connection.user_2_id = @user.id;

    if(connection.save)

      # send a mail to the connection indicating that you would like to become a connection
      @user.send_invitation_mail(current_user)

      settings();
      @showModal = true;
      flash.now.alert = "An invitation has been sent."
      respond_to do |format|
        format.js { render 'users/show_add_connection_refresh.js.erb' }
      end
      
    else
      @showModal = true;
      flash.now.alert = "Something went wrong while sending the invitation. Please, try again later."
      render action: :new
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
        @user = get_user(false)
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
