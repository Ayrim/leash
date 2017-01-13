class MessagingController < ApplicationController
  before_action :require_login

	def index
		if (params.has_key?(:notification))
			@show_user = User.find(params[:notification])
			#collect messages to/from this user
			update_message_array()
			#set is_read-flag to true
			set_messages_as_read()
		else
			@messages = Message.order(created_at: :desc).where("id = -1").paginate(:page => params[:page], :per_page => 10)
		end
	end

	def update_message_array
		@messages = Message.order(created_at: :desc).where("(from_user_id = ? AND to_user_id = ?) OR (from_user_id = ? AND to_user_id = ?)", current_user.id, @show_user.id, @show_user.id, current_user.id).paginate(:page => params[:page], :per_page => 10)
	end

	def update_unreadMessages
		if !current_user.nil?
			respond_to do |format|
				format.js { render 'update_unreadMessages.js.erb' }
				format.html { redirect_back_or_to(overview_path)  }
			end
		end
	end

	def show
		if !(params.has_key?(:id))
			if !@show_user
				@show_user = current_user
			end
		else
	      	@show_user = User.find(params[:id])
		end

		if @show_user
			#collect messages to/from this user
			update_message_array()
			#set is_read-flag to true
			set_messages_as_read()

			respond_to do |format|
				format.html {render template: "messaging/showMessages"}
				format.js
			end
		end
	end

	def set_messages_as_read
		@messages.each do |message|
			if !message.is_read and message.from_user_id != current_user.id
				message.is_read = true;
				message.save;
			end
		end
	end

	def create_message
		message = Message.new(message_params)
		message.from_user_id = current_user.id

		if @show_user.nil?
			if message.to_user_id.nil?
				if (params.has_key?(:notification))
	      			@show_user = User.find(params[:notification])
				end
			else
		      	@show_user = User.find(message.to_user_id)
			end
		end


		message.is_read = false
		if(current_user.id != @show_user.id)
			puts "about to save the message.."
			if(message.save)
				#collect messages to/from this user
				update_message_array()

				respond_to do |format|
		     		format.html
		    		format.js { render 'show.js.erb' }
		    	end
			else
				render :index
			end
		else
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
