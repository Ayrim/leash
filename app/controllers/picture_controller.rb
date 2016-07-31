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
	end

	def create
		set_user()
		@picture = Picture.new(picture_params)
		if (params[:picture].has_key?(:photoalbum))
			@picture.photoalbum_id = params[:picture][:photoalbum]
		end

		directory = "app/assets/images/pictures/" + current_user.id.to_s
		
		#Check if the directory exists and create it if it doesn't.
		Dir.mkdir(directory) unless File.exists?(directory)	
	    
	    save_directory = "assets/pictures/" + current_user.id.to_s
	    picture_path = ""
	    save_picture_path = ""
		if(params[:picture][:picture])
      		picture_name = params[:picture][:picture].original_filename.gsub('[', '_').gsub(']', '_').gsub(' ', '_')
     		picture_path = File.join(Rails.root, directory, picture_name)
      		save_picture_path = File.join(save_directory, picture_name)
      		File.open(picture_path, "wb") { |f| f.write(params[:picture][:picture].read) }

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

		respond_to do |format|
		 	format.js { render 'images/edit_show_form_picture.js.erb' }
		end
	end

	def edit_picture
		set_user()
		if (params[:picture].has_key?(:id))
			@edit_picture = Picture.find_by(:id => params[:picture][:id])

		    respond_to do |format|
		    	# TODO: update tags as well.
		      if [(@edit_picture.update_attribute(:comment, params[:picture][:comment]) if params[:picture][:comment])] 
				
				LoadPhotosByAlbum(@edit_picture.photoalbum_id)

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
			albumid = params[:picture][:photoalbum]
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
			params.require(:picture).permit(:user_id, :comment, photoalbum: :string)
		end
end
