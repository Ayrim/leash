class HomeController < ApplicationController
	def index
		@hideHome = true;
	end

	def overview
		@hideHome = true;

		# get the 10 most recent wallposts which contain a picture
		# userIdQuery = "user_id != " + current_user.id.to_s
		# posts = Wallpost.order(created_at: :desc).where(userIdQuery).where("picture is not NULL").limit(10)
		posts = Wallpost.order(created_at: :desc).where("picture is not NULL").limit(10)
		# take 3 random wallposts from these 10
		@PicturePosts = posts.shuffle.take(3)
	end
end
