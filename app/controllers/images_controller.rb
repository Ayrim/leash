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
			@photoswithoutalbum = Array.new()
			@showModal = true;
			flash.now.alert = "Something went wrong when attempting to retrieve the user images."
			render :index
		else
			# If the page is loaded for a different user, check if the user is a connection
			# if not - do not load the page
			if(@show_user.id != current_user.id)
				if Connection.where('(user_1_id = ? and user_2_id = ?) or (user_1_id = ? and user_2_id = ?)', current_user.id, @show_user.id, @show_user.id, current_user.id).count > 0
					LoadPhotoAlbums()
					LoadPhotosWithoutAlbum()
				else
					@photoalbums = Array.new()
					@photoswithoutalbum = Array.new()
					@showModal = true;
					flash.now.alert = "You are not allowed to view the images of people you have no connection with."
					render :index
				end
			else
				LoadPhotoAlbums()
				LoadPhotosWithoutAlbum()
			end
		end
	end

	def show
		set_user()
				
		begin
			@hideCreateAlbum = true
			LoadPhotoAlbums()
			if(params.has_key?(:id))
				if(params[:id] != 'update_unreadmessages')
					albumid = params[:id]
					@current_album = Photoalbum.find_by(:id => albumid)
					@photoswithoutalbum = Picture.where('(photoalbum_id = ?)', albumid).order(created_at: :desc)
					
					#LoadPhotoAlbums()
					#LoadPhotosWithoutAlbum()

					respond_to do |format|
						format.html
						format.js { render 'images/show_picturesInAlbum.js.erb' }
					end
				end
			end
		rescue PG::InvalidTextRepresentation
			@showModal = true;
			flash.now.alert = "Something went while retrieving the image. Please, try again later."
			render action: :new
	  	end
	end

	def create_photoalbum
		#puts '-=-=-=-=-=-=-=-'
		#puts params.to_json
		#puts '-=-=-=-=-=-=-=-'

		#TODO tags

		set_user()
		@albumphotos = Array.new()
		album = Photoalbum.new(photoalbum_params)
		if Photoalbum.where(:name => album.name, :user_id => current_user.id).count > 0

			LoadPhotoAlbums()
			LoadPhotosWithoutAlbum()

			@showModal = true;
			flash.now.alert = "An album with that name already exists. Please, choose a different name."
			respond_to do |format|
				format.js { render 'images/show_alert.js.erb' }
			end
		else

			if album.save
				#save succeeded

				LoadPhotoAlbums()
				LoadPhotosWithoutAlbum()
			 	
			 	respond_to do |format|
			 		#format.js { render 'images/create_upload_picture_album.js.erb' }
			 		format.js { render 'images/show_updated_albums.js.erb' }
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

	def edit
		if (params.has_key?(:id))
			@edit_album = Photoalbum.where("user_id = ? AND id = ?", current_user.id, params[:id]).first
		end

		respond_to do |format|
		   	format.html { redirect_to :controller => "images" , :action => "index" }
		 	format.js { render 'images/edit_show_form_album.js.erb' }
		end

	end

	def edit_photoalbum
		set_user()
		if (params[:photoalbum].has_key?(:id))
			@edit_album = Photoalbum.where("user_id = ? AND id = ?", current_user.id, params[:photoalbum][:id]).first

			# Update the pictures in this album to match the visibility_id
			@pictures_in_edit_album = Picture.joins(:photoalbum).where("user_id = ? AND photoalbums.id = ?", current_user.id, params[:photoalbum][:id]).first
				
		    respond_to do |format|
		      if (@edit_album.update(photoalbum_params) and (@pictures_in_edit_album.update_attribute(:visibility_id, params[:photoalbum][:visibility_id]) if params[:photoalbum][:visibility_id]))
					LoadPhotoAlbums()

		      		format.js { render 'images/show_updated_albums.js.erb' }
		      else
		        format.html { render :edit }
		        format.json { render json: @user.errors, status: :unprocessable_entity }
		      end
		    end
	    end
	end

	def destroy
		albumToRemove = Photoalbum.where("user_id = ? AND id = ?", current_user.id, params[:id]).first
		
		#TODO: remove the pictures from this album before removing the actual album

	    if albumToRemove.destroy

			LoadPhotoAlbums()
			#LoadPhotosWithoutAlbum()

		    respond_to do |format|
		      	format.html { redirect_to :controller => "images" , :action => "index" }
			 	format.js { render 'images/create_upload_picture_album.js.erb' }
		    end
		else
			#save failed
			@showModal = true;
			flash.now.alert = "Failed to remove the photo-album, try again later."
			respond_to do |format|
				format.js { render 'images/show_alert.js.erb' }
			end
		end
	end

	def LoadPhotoAlbums
		if(params.has_key?(:uid))
			if current_user.id == @show_user.id
				@photoalbums = Photoalbum.where('(user_id = ? and name = ?)', @show_user.id, "No Album") + Photoalbum.where('(user_id = ? and name != ?)', @show_user.id, "No Album").order(name: :asc)
			elsif (current_user.connections.include?(@show_user))
				@photoalbums = Photoalbum.where('(user_id = ? and name = ?)', @show_user.id, "No Album") + Photoalbum.where('(user_id = ? and name != ?)  AND (visibility_id = ? OR visibility_id = ?)', @show_user.id, "No Album", '2', '1').order(name: :asc)
			else
				@photoalbums = Photoalbum.where('(user_id = ? and name = ?)', @show_user.id, "No Album") + Photoalbum.where('(user_id = ? and name != ?)  AND (visibility_id = ?)', @show_user.id, "No Album", '1').order(name: :asc)
			end
		else
			@photoalbums = Photoalbum.where('(user_id = ? and name = ?)', current_user.id, "No Album") + Photoalbum.where('(user_id = ? and name != ?)', current_user.id, "No Album").order(name: :asc)
		end
	end

	def LoadPhotosWithoutAlbum
		if(params.has_key?(:uid))
			if current_user.id == @show_user.id
	    		@photoswithoutalbum = Picture.joins(:photoalbum).where('(photoalbums.user_id = ? and photoalbums.name = ?)', @show_user.id, "No Album", ).order(created_at: :desc)
			elsif (current_user.connections.include?(@show_user))
				@photoswithoutalbum = Picture.joins(:photoalbum).where('(photoalbums.user_id = ? and photoalbums.name = ?) AND (pictures.visibility_id = ? OR pictures.visibility_id = ?)', @show_user.id, "No Album", '2', '1').order(created_at: :desc)
			else 
	      		@photoswithoutalbum = Picture.joins(:photoalbum).where('(photoalbums.user_id = ? and photoalbums.name = ?) AND (pictures.visibility_id = ?)', @show_user.id, "No Album", '1').order(created_at: :desc)
			end
		else
			albumid = Photoalbum.where('(user_id = ? and name = ?)', current_user.id, "No Album").pluck(:id)
			@photoswithoutalbum = Picture.where('(photoalbum_id = ?)', albumid).order(created_at: :desc)
		end
	end

	private

		def photoalbum_params
			params.require(:photoalbum).permit(:name, :user_id, :description, :visibility_id)
		end
end
