class ConnectionsController < ApplicationController
    def index
      show()
        respond_to do |format|
          format.html { redirect_to :controller => "connections" , :action => "show" }
        end
    end

  	def show
      if(params.has_key?(:id))
        if(params[:id] != 'update_unreadmessages')
  		    set_user()
  		    set_connections()
        end
      end
  	end

  	def destroy
  		set_user()

  		if(params.has_key?(:id))
			if(params[:id] != 'update_unreadmessages')
  				@delete_connection = Connection.where('(user_1_id = ? AND user_2_id = ?) OR (user_1_id = ? AND user_2_id = ?)', current_user.id, @show_user.id, @show_user.id, current_user.id).first

  				#TODO: remove this connection

  				#if @delete_connection.destroy
  				#	@connections = @show_user.connections

  				#	respond_to do |format|
				#     	format.html { redirect_to :controller => "connections" , :action => "show" }
				#	 	format.js { render 'connections/show_connections_list.js.erb' }
				#    end
  				#else
				#	@showModal = true;
				#	flash.now.alert = "Something went wrong when attempting to remove this connection. Please, try again later."
				#	render action: :new
  				#end
  			end
  		else
			@showModal = true;
			flash.now.alert = "Something went wrong when attempting to remove this connection. Please, try again later."
			render action: :new
  		end

  	end

  	def accept_invitation
  		set_user()

  		if(params.has_key?(:id))
  			if(params[:id] != 'update_unreadmessages')
  				update_connection = Connection.where('(user_1_id = ? AND user_2_id = ?) OR (user_1_id = ? AND user_2_id = ?)', current_user.id, params[:id], params[:id], current_user.id).first
  				if(!update_connection.nil?)
            if (update_connection.update_attributes(:is_pending => false))

              set_connections()

              #TO DO: send mail-notification to notify other contact that invitation has been accepted.

              respond_to do |format|
                format.html { redirect_to :controller => "connections" , :action => "show" }
                format.js { render 'connections/show_update_connections.js.erb' }
              end
  				  end
  		  	else
  					@showModal = true;
  					flash.now.alert = "Something went wrong when attempting to accept the invitation. Please, try again later."
  					render action: :new
  				end
  			end
  		else
  			@showModal = true;
  			flash.now.alert = "Something went wrong when attempting to accept the invitation. Please, try again later."
  			render action: :new
		  end
  	end

    def set_user		
    	# check if the page is being loaded for the current user or for a different user
  		if(params.has_key?(:uid))
  			@show_user = User.find_by(:id => params[:uid])
  		else
  			@show_user = current_user
  		end
    end

    def set_connections
      @connections = Array.new()
      @pending_connections = Array.new()
      @pending_outgoing_connections = Array.new()
      @pending_incoming_connections = Array.new()
      if !@show_user.nil?
        @connections = @show_user.connections
        @pending_connections = @show_user.pending_connections
        @pending_incoming_connections = @show_user.pending_incoming_connections
        @pending_outgoing_connections = @show_user.pending_outgoing_connections
      end
    end

end
