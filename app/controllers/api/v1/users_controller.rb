module Api
  module V1
    class UsersController < AuthenticationController
      before_action :require_login, except: [:index, :get_user]
      
      # API - START
      # /api/users
    	def index(api = true)
        if(authorization_required(api))
          if(api)
            render json: User.all, status: :ok
          else
            return User.all;
          end
        end
    	end

      # /api/users/:id
      def get_user(api = true)    
        # check if the page is being loaded for the current user or for a different user
        if (params.has_key?(:id))
          if(params[:id] != 'update_unreadmessages')
            user = User.find(params[:id])
          end
        elsif(params.has_key?(:uid))
          user = User.find_by(:id => params[:uid])
        else
          user = current_user
        end

        if(api)
          render json: user, status: :ok
        else
          if !user.nil?
            return user
          end
        end
      end

      # API - END


    end
  end
end