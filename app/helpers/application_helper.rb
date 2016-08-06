module ApplicationHelper

	def current_language()
		I18n.locale;
	end
	
	def current_url(new_params)
	  url_for :params => params.merge(new_params)
	end

	def translate_visibility(visibility)
		if visibility == "Public"
			return I18n.t('public');
		elsif visibility == "Connections"
			return I18n.t('connections');
		elsif visibility == "Private"
			return I18n.t('private');
		else
			return I18n.t('public');
		end
	end
end
