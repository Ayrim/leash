class HomeController < ApplicationController
  before_action :require_login, except: [ :index, :pricing, :about_us, :contact_us, :how_and_why]

	def index
		@hideHome = true;
    	@dontSetBodyHeight = true;
	end

	def overview
		@hideHome = true;
    	@dontSetBodyHeight = true;

		# get the 10 most recent wallposts which contain a picture
		# userIdQuery = "user_id != " + current_user.id.to_s
		# posts = Wallpost.order(created_at: :desc).where(userIdQuery).where("picture is not NULL").limit(10)
		posts = Wallpost.order(created_at: :desc).where("picture is not NULL").limit(10)
		# take 3 random wallposts from these 10
		@RandomPictures = Picture.joins(:visibility).joins(:photo_album).where('(visibilities.value = ?) AND photo_albums.user_id != ?', 'Public', current_user.id).order("pictures.created_at desc").limit(10).shuffle.take(3)

	end

	def pricing
	end

	def about_us
	end

	def contact_us
	end

	def how_and_why
	end
end
