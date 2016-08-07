class PictureController < ApplicationController
	

	def set_user		
    	# check if the page is being loaded for the current user or for a different user
		if(params.has_key?(:uid))
			@show_user = User.find_by(:id => params[:uid])
		else
			@show_user = current_user
		end
    end

	def index
	end

	def show
		if(params.has_key?(:id))
			if(params[:id] != 'update_unreadmessages')
				begin
					#define the owner of this picture
					ownerId = Picture.joins(:photoalbum).where('pictures.id = ?', params[:id]).pluck(:user_id)
					@owner = User.find_by(:id => ownerId)


					#define if the current user is allowed to view this picture
					if current_user.id == @owner.id
						@show_picture = Picture.find_by(:id => params[:id])
					elsif (current_user.connections.include?(@owner))
						@show_picture = Picture.where('id = ? AND (visibility_id = ? OR visibility_id = ?)', params[:id], '2', '1').first
					else
						#not a connection
						#check visibility-level of the picture if access is granted
						@show_picture = Picture.where('id = ? AND (visibility_id = ?)', params[:id], '1').first
					end
				rescue PG::InvalidTextRepresentation
					@showModal = true;
					flash.now.alert = "Something went while retrieving the image. Please, try again later."
					render action: :new
			  	end
		  	end
		end
	end

	def create
		set_user()
		@picture = Picture.new(picture_params)
		if (params[:picture].has_key?(:photoalbum))
			@picture.photoalbum_id = params[:picture][:photoalbum]
		end

		if(params[:picture][:picture])
		  	# Container exists => move on!
		  	fileExtension = File.extname(params[:picture][:picture].original_filename)

		  	fileName = current_user.id.to_s + '_' + SecureRandom.uuid + fileExtension
			blobs = Azure::Blob::BlobService.new
			content = File.open(params[:picture][:picture].tempfile.path, 'rb') { |file| file.read }
			blob = blobs.create_block_blob("images", fileName, content)

			#Blob has been uploaded
			save_picture_path = 'https://' + Azure.config.storage_account_name + '.blob.core.windows.net/images/' + fileName
			
			@picture.url = save_picture_path

			if(@picture.save)
				#Save succeeded
				LoadPhotoAlbums()
				LoadPhotosWithoutAlbum()

				if (params[:picture].has_key?(:existingAlbum))
					respond_to do |format|
						format.js { render 'images/show_upload_new_photo.js.erb' }
					end
				else
					respond_to do |format|
						format.js { render 'images/create_upload_picture_album.js.erb' }
					end
				end
			else
				#Save failed
				@showModal = true;
				flash.now.alert = "Something went wrong uploaading the album. Please, try again later."
				respond_to do |format|
					format.js { render 'images/show_alert.js.erb' }
				end
			end
		end	
	end


	def edit
		if (params.has_key?(:id))
			@edit_picture = Picture.find_by(:id => params[:id])
			@current_album = Photoalbum.find_by(:id => @edit_picture.photoalbum_id)
		end

				LoadPhotoAlbums()
		LoadPhotoAlbums()

		respond_to do |format|
		 	format.js { render 'images/edit_show_form_picture.js.erb' }
		end
	end

	def edit_picture
		puts '-=-=-=-=-=-=-=-=-=-'
		puts params
		puts '-=-=-=-=-=-=-=-=-=-'

		set_user()
		if (params[:picture].has_key?(:id))
			@edit_picture = Picture.find_by(:id => params[:picture][:id])
			orig_album_id = @edit_picture.try(:photoalbum_id)
		    respond_to do |format|
		    	# TODO: update tags as well.
		      if ([(@edit_picture.update_attribute(:comment, params[:picture][:comment]) if params[:picture][:comment])] && [(@edit_picture.update_attribute(:photoalbum_id, params[:picture][:photoalbum]) if params[:picture][:photoalbum])] && [(@edit_picture.update_attribute(:visibility_id, params[:picture][:visibility_id]) if params[:picture][:visibility_id])] )

				LoadPhotosByAlbum(orig_album_id)

				format.js { render 'images/show_updated_picture.js.erb' }
		      else
		        format.html { render :edit }
		        format.json { render json: @user.errors, status: :unprocessable_entity }
		      end
		    end
	    end
	end

	def destroy
		set_user()
		picToRemove = Picture.find_by(:id =>params[:id])
	
	    if picToRemove.destroy
			LoadPhotosByAlbum(picToRemove.photoalbum_id)

		    respond_to do |format|
		      	format.html { redirect_to :controller => "images" , :action => "index" }
			 	format.js { render 'images/create_upload_picture_album.js.erb' }
		    end
		else
			#save failed
			@showModal = true;
			flash.now.alert = "Failed to remove the picture, try again later."
			respond_to do |format|
				format.js { render 'images/show_alert.js.erb' }
			end
		end
	end

	def LoadPhotoAlbums
		@photoalbums = Photoalbum.where('(user_id = ? and name = ?)', current_user.id, "No Album") + Photoalbum.where('(user_id = ? and name != ?)', current_user.id, "No Album").order(name: :asc)
	end

	def LoadPhotosWithoutAlbum
		if (params[:picture].has_key?(:existingAlbum))
			albumid = params[:picture][:existingAlbum]
			@current_album = Photoalbum.find_by(:id => albumid)
		else
			albumid = Photoalbum.where('(user_id = ? and name = ?)', current_user.id, "No Album").pluck(:id)
		end
		@photoswithoutalbum = Picture.where('(photoalbum_id = ?)', albumid).order(created_at: :desc)
	end

	def LoadPhotosByAlbum(albumid)
		if(!albumid.nil?)
			update_album = Photoalbum.find_by(:id => albumid)
			if update_album.name == 'No Album'
				@photoswithoutalbum = Picture.where('(photoalbum_id = ?)', albumid).order(created_at: :desc)
			else
				@photoswithoutalbum = Picture.where('(photoalbum_id = ?)', albumid).order(created_at: :desc)
			end
		else
			@photoswithoutalbum = Photoalbum.where('(user_id = ? and name = ?)', current_user.id, "No Album") + Photoalbum.where('(user_id = ? and name != ?)', current_user.id, "No Album").order(name: :asc)
		end
	end

	private

		def picture_params
			params.require(:picture).permit(:user_id, :comment, :visibility_id, photoalbum: :string)
		end
end
