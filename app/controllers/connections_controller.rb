class ConnectionsController < ApplicationController
  before_action :require_login

    def index
        respond_to do |format|
            format.html { redirect_to :controller => "connections" , :action => "show" }
        end
    end

  	def show
        if(params.has_key?(:uid))
        	set_user()
        else
          @show_user = current_user
        end
        set_connections()
  	end

  	def destroy
    		set_user()

    		if(params.has_key?(:id))
    			  if(params[:id] != 'update_unreadmessages')
                @connId = params[:id]
      			   	@delete_connection = Connection.where('(user_1_id = ? AND user_2_id = ?) OR (user_1_id = ? AND user_2_id = ?)', current_user.id, params[:id], params[:id], current_user.id).first

        				if @delete_connection.destroy
          					@connections = @show_user.connections

                    set_connections()
          					respond_to do |format|
        				    	  format.html { redirect_to :controller => "connections" , :action => "show" }
        				  	 	  format.js { render 'connections/show_update_connections.js.erb' }
        				    end
        				else
        				    @showModal = true;
        				    flash.now.alert = "Something went wrong when attempting to remove this connection. Please, try again later."
                    render 'connections/show_update_connections.js.erb'
        				end
      			end
    		else
      			@showModal = true;
      			flash.now.alert = "Something went wrong when attempting to remove this connection. Please, try again later."
            render 'connections/show_update_connections.js.erb'
    		end
  	end

  	def accept_invitation
    		set_user()

    		if(params.has_key?(:id))
      			if(params[:id] != 'update_unreadmessages')
                @connId = params[:id]
          			update_connection = Connection.where('(user_1_id = ? AND user_2_id = ?) OR (user_1_id = ? AND user_2_id = ?)', current_user.id, params[:id], params[:id], current_user.id).first
          			begin
                    ActiveRecord::Base.transaction do
                      	if(!update_connection.nil?)
                            if (update_connection.update_attributes(:is_pending => false))

                                set_connections()

                                userConnection = User.find_by(:id => params[:id])
                                if(!userConnection.nil?)
                                    # send a mail to indicate that the invitation has been accepted.
                                    userConnection.send_accept_invitation_mail(current_user)

                                    respond_to do |format|
                                        format.html { redirect_to :controller => "connections" , :action => "show" }
                                        format.js { render 'connections/show_update_connections.js.erb' }
                                    end
                                end
                  				  end
                		  	else
                  					@showModal = true;
                  					flash.now.alert = "Something went wrong when attempting to accept the invitation. Please, try again later."
                            render 'connections/show_acceptance_alert.js.erb'
                				end
                    end
                rescue Net::OpenTimeout
                  @showModal = true;
                  flash.now.alert = "Something went wrong when attempting to accept the invitation. Please, try again later."
                  render 'connections/show_acceptance_alert.js.erb'
                end
      			end
    		else
      			@showModal = true;
      			flash.now.alert = "Something went wrong when attempting to accept the invitation. Please, try again later."
            render 'connections/show_acceptance_alert.js.erb'
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
            if current_user.id == @show_user.id
                @pending_connections = @show_user.pending_connections
                @pending_incoming_connections = @show_user.pending_incoming_connections
                @pending_outgoing_connections = @show_user.pending_outgoing_connections
            end
        end
    end
end