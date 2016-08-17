module HomeHelper
	def collectPictureUserName(pictureId)
		ownerId = Picture.joins(:photoalbum).where('pictures.id = ?', pictureId).pluck(:user_id)
		user = User.find_by(:id => ownerId)
		return user.firstname + ' ' + user.lastname
	end

	def collectPictureUserAddress(pictureId)
		ownerId = Picture.joins(:photoalbum).where('pictures.id = ?', pictureId).pluck(:user_id)
		user = User.find_by(:id => ownerId)
		return user.address
	end
end
