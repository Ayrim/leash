class PictureController < ApplicationController
	def index
	end

	def show
	end

	def create
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

				puts '-=-=-=-=-=-=-=-=-'
				puts @photoswithoutalbum.to_json
				puts '-=-=-=-=-=-=-=-=-'

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

	private

		def picture_params
			params.require(:picture).permit(:user_id, photoalbum: :string)
		end
end
