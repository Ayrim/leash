module UsersHelper
	def nice_date_form(the_date)
		if(the_date)
	   		return the_date.strftime('%d %B, %Y')
	   	else
	   		return '';
	   	end
	end

	def user_avatar()
		if(!current_user)
			return "assets/avatar_2x.png";
		elsif(!current_user.profile_picture)
			return "assets/avatar_2x.png";
		elsif(current_user.profile_picture == "")
			return "assets/avatar_2x.png";
		else
			return current_user.profile_picture;
		end
	end

	def load_user_avatar(show_user)
		if(!show_user)
			return "../assets/avatar_2x.png";
		elsif(!show_user.profile_picture)
			return "../assets/avatar_2x.png";
		elsif(show_user.profile_picture == "")
			return "../assets/avatar_2x.png";
		else
			return show_user.profile_picture;
		end
	end

	def user_banner()
		if(!current_user)
			return "assets/user-profile-bg.jpg";
		elsif(!current_user.banner_picture)
			return "assets/user-profile-bg.jpg";
		elsif(current_user.banner_picture == "")
			return "assets/user-profile-bg.jpg";
		else
			return current_user.banner_picture;
		end
	end

	def load_user_banner(show_user)
		if(!show_user)
			return "../assets/user-profile-bg.jpg";
		elsif(!show_user.banner_picture)
			return "../assets/user-profile-bg.jpg";
		elsif(show_user.banner_picture == "")
			return "../assets/user-profile-bg.jpg";
		else
			return show_user.banner_picture;
		end
	end

	def calculateAge(birthday)
		now = Time.now.utc.to_date
  		return now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
	end

	def number_to_euro(amount)
		number_to_currency(amount,:unit=>'€').gsub(' ','&nbsp;').gsub('.',',')
	end

	def translate_preference(preference)
		if preference == "No preferences"
			return I18n.t('views.user.nopreference');
		elsif preference == "Small dogs"
			return I18n.t('views.user.smallpreference');
		elsif preference == "Large dogs"
			return I18n.t('views.user.largepreference');
		else
			return I18n.t('views.user.nopreference');
		end
	end
end

