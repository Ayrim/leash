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
end

