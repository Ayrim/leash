module ApplicationHelper

	def current_language()
		I18n.locale;
	end
	
	def current_url(new_params)
	  url_for :params => params.merge(new_params)
	end
end
