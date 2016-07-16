class ImagesController < ApplicationController
	def index
	end

	def show
	end

	def create_photoalbum
	end

	private

		def photoalbum_params
			params.require(:photoalbum).permit(:name, :user_id)
		end
end
