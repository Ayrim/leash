class UserSessionsController < Api::V1::UserSessionsController
	before_action :require_login, except: [:new, :create]

	def new
		@hideNav = true;
		@showFooterSilhouette = true;

		if !current_user.nil?
			redirect_back_or_to(overview_path)
		end
	end

	def create
		@hideNav = true;
		@showFooterSilhouette = true;

		sign_in(false, params[:remember])
	end

	def destroy
		sign_out(false)
	end
end
