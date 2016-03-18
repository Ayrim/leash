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
			return "http://ssl.gstatic.com/accounts/ui/avatar_2x.png";
		elsif(!current_user.profile_picture)
			return "http://ssl.gstatic.com/accounts/ui/avatar_2x.png";
		elsif(current_user.profile_picture == "")
			return "http://ssl.gstatic.com/accounts/ui/avatar_2x.png";
		else
			return current_user.profile_picture;
		end
	end
end

