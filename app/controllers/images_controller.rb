class ImagesController < ApplicationController
  before_action :set_user, only: [:index, :show, :LoadPhotoAlbums]

    def set_user		
    	# check if the page is being loaded for the current user or for a different user
		if(params.has_key?(:uid))
			@show_user = User.find_by(:id => params[:uid])
		else
			@show_user = current_user
		end
    end

	def index
		@albumphotos = Array.new()

		if @show_user.nil?
			@photoalbums = Array.new()
			@showModal = true;
			flash.now.alert = "Something went wrong when attempting to retrieve the user images."
			render :index
		else
			# If the page is loaded for a different user, check if the user is a connection
			# if not - do not load the page
			if(@show_user.id != current_user.id)
				puts current_user.connections.to_json
				#if current_user.connections.where(:user_1_id => @show_user.id)
				#end
				if Connection.where('(user_1_id = ? and user_2_id = ?) or (user_1_id = ? and user_2_id = ?)', current_user.id, @show_user.id, @show_user.id, current_user.id).count > 0
					LoadPhotoAlbums()
				else
					@photoalbums = Array.new()
					@showModal = true;
					flash.now.alert = "You are not allowed to view the images of people you have no connection with."
					render :index
				end
			else
				LoadPhotoAlbums()
			end
		end
	end

	def show
		set_user()
		albumid = params[:id]
		@albumphotos = Picture.where('(photoalbum_id = ?)', albumid).order(created_at: :desc)
		puts '-=-=-=-=-=-=-=-=-=-=-'
		puts @albumphotos
		puts '-=-=-=-=-=-=-=-=-=-=-'

		LoadPhotoAlbums()

		respond_to do |format|
			format.js { render 'images/create_upload_picture_album.js.erb' }
		end
	end

	def create_photoalbum
		@albumphotos = Array.new()
		album = Photoalbum.new(photoalbum_params)
		if Photoalbum.where(:name => album.name, :user_id => current_user.id).count > 0

			LoadPhotoAlbums()

			@showModal = true;
			flash.now.alert = "An album with that name already exists. Please, choose a different name."
			respond_to do |format|
				format.js { render 'images/show_alert.js.erb' }
			end
		else

			if album.save
				#save succeeded

				LoadPhotoAlbums()
			 	
			 	respond_to do |format|
			 		format.js { render 'images/create_upload_picture_album.js.erb' }
			 	end
			else
				#save failed
				@showModal = true;
				flash.now.alert = "Something went wrong creating the album. Please, try again later."
				respond_to do |format|
					format.js { render 'images/show_alert.js.erb' }
				end
			end
		end
	end

	def LoadPhotoAlbums
		if(params.has_key?(:uid))
			@photoalbums = Photoalbum.where('(user_id = ? and name = ?)', @show_user.id, "No Album") + Photoalbum.where('(user_id = ? and name != ?)', @show_user.id, "No Album").order(name: :asc)
		else
			@photoalbums = Photoalbum.where('(user_id = ? and name = ?)', current_user.id, "No Album") + Photoalbum.where('(user_id = ? and name != ?)', current_user.id, "No Album").order(name: :asc)
		end
	end

	private

		def photoalbum_params
			params.require(:photoalbum).permit(:name, :user_id)
		end
end
