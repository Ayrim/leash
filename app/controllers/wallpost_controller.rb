class WallpostController < ApplicationController
  before_action :require_login


	def index
		$wallposts = Wallpost.order(created_at: :desc).where({:user_id => $show_user.id}).paginate(:page => params[:page], :per_page => 10)
	end

	def showNewPosts
		$wallposts = Wallpost.order(created_at: :desc).where({:user_id => current_user.id}).paginate(:page => params[:page], :per_page => 10)

	   	respond_to do |format|
    		format.html { redirect_to :controller => "users", :action => "settings" }
         	format.js
     	end
	end

	def show
    	#format.js { render :template => "create"}

		respond_to do |format|
			format.html { redirect_to :controller => "users", :action => "settings" }
    		format.js
    	end
	end

	def create

		@wallpost = Wallpost.new(wallpost_params)
		@wallpost.user_id = current_user.id

	    directory = "app/assets/images/wallposts"
	    save_directory = "assets/wallposts"
	    picture_path = ""
	    save_picture_path = ""
		if(params[:wallpost][:picture])
      		picture_name = params[:wallpost][:picture].original_filename.gsub('[', '_').gsub(']', '_')
     		picture_path = File.join(Rails.root, directory, picture_name)
      		save_picture_path = File.join(save_directory, picture_name)
      		File.open(picture_path, "wb") { |f| f.write(params[:wallpost][:picture].read) }

			@picture = Picture.create(:url => save_picture_path)

			@wallpost.picture = @picture.id
		end		
		CreateWallpost(@wallpost)
	end

	def CreateWallpost(wallpost)
		if(wallpost.save)
			$wallposts = Wallpost.order(created_at: :desc).where({:user_id => current_user.id}).paginate(:page => params[:page], :per_page => 10)
			respond_to do |format|
	     		format.html { redirect_to wallpost }
	    		format.js
	    	end
		else
			render :index
		end
	end

	def destroy
		@post = Wallpost.find(params[:id])
   		@post.destroy
   		params.delete :id
		$wallposts = Wallpost.order(created_at: :desc).where({:user_id => current_user.id}).paginate(:page => params[:page], :per_page => 10)
	   	respond_to do |format|
	     		format.html { redirect_to wallpost }
	    		format.js
	   	end
	end

	private

		def wallpost_params
			params.require(:wallpost).permit(:user_id, :message, :picture, :blog_id, :route, :tag)
		end
end
