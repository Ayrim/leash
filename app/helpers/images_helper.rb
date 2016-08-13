module ImagesHelper
	def translate_photoalbum(albumname)
		if(albumname == "No Album")
			return I18n.t('views.images.noalbum');
		else
			return albumname;
		end
	end

	def CollectLastPictures(albumname, albumId)
		return Picture.where('(photoalbum_id = ?)', albumId).order(created_at: :desc).limit(3);
	end

	def GetAlbumName(albumId)
		return Photoalbum.find_by(:id => albumId).name;
	end

	def GetCurrentLanguageTagHeader(albumOrPicture)
		if (albumOrPicture == "Album")
			return I18n.t('views.images.addalbumtags');
		else 
			return I18n.t('views.images.addpicturetags');
		end
	end
end