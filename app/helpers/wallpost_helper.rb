module WallpostHelper
	def collectWallpostPicture(pictureId)
		return Picture.find_by(:id => pictureId).url;
	end
end
