class MessagingController < ApplicationController
	$show_user = nil
	def index
		@messages = Message.order(created_at: :desc).where("id = -1").paginate(:page => params[:page], :per_page => 10)
	end

	def show
		if !(params.has_key?(:id))
			if !@show_user
				@show_user = current_user
			end
		else
	      	@show_user = User.find(params[:id])
		end

		if (params.has_key?(:id))
	      	@show_user = User.find(params[:id])
	      	$show_user = @show_user
			#collect messages to/from this user
			@messages = Message.order(created_at: :desc).where("(from_user_id = ? AND to_user_id = ?) OR (from_user_id = ? AND to_user_id = ?)", current_user.id, @show_user.id, @show_user.id, current_user.id).paginate(:page => params[:page], :per_page => 10)

			#TO TEST
			@messages.each do |message|
				if !message.is_read and message.from_user_id != current_user.id
					message.is_read = true;
					message.save;
				end
			end

		   	respond_to do |format|
		   		format.html {render template: "messaging/showMessages"}
		    	format.js
		   	end
		end

	end

	def create_message
		message = Message.new(message_params)
		message.from_user_id = current_user.id

		if !@show_user
	      	@show_user = User.find(message.to_user_id)
		end

		message.is_read = false
		if(current_user.id != @show_user.id)
			puts "about to save the message.."
			if(message.save)
				@messages = Message.order(created_at: :desc).where("(from_user_id = ? AND to_user_id = ?) OR (from_user_id = ? AND to_user_id = ?)", current_user.id, @show_user.id, @show_user.id, current_user.id).paginate(:page => params[:page], :per_page => 10)
				respond_to do |format|
		     		format.html
		    		format.js { render 'show.js.erb' }
		    	end
			else
				render :index
			end
		else
			puts "not going to save the message.."
			flash.notice = "Something went wrong saving the message."
			respond_to do |format|
		    	format.html
		    	format.js { render 'show.js.erb' }
		    end
		end
	end


	private

		def message_params
			params.require(:message).permit(:content, :to_user_id)
		end
end
