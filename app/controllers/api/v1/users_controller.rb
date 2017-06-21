module Api
  module V1
    class UsersController < AuthenticationController
      before_action :require_login, except: [:index, :get_user]
      
      # [GET] /api/users
    	def index(api = true)
        if(authorization_required(api))
          if(api)
            render json: User.all, status: :ok
          else
            return User.all;
          end
        end
    	end

      # [GET] /api/users/:id
      def get_user(api = true)    
        # check if the page is being loaded for the current user or for a different user
        begin
          if(authorization_required(api))
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
              if(!user.nil?)
                render json: user, status: :ok
              else
                render json: nil, status: :not_found
              end
            else
              if !user.nil?
                return user
              end
            end
          end
        rescue ActiveRecord::RecordNotFound
          if(api)
            render json: nil, status: :not_found
          else
            return nil
          end
        end
      end

      #[GET] /api/users/nearby/:id
      def LoadNearbyUsers(radius = 10, api = true)
        current_user_id = 0;
        if(!current_user.nil?)
          current_user_id = current_user.id;
        else (params.has_key?(:id))
          if(params[:id])
            current_user_id = params[:id]
          end
        end
        addresses = Address.near(current_user.address.full_address, radius, order: 'distance').where('user_id != ?', current_user_id)

        if !addresses.nil?
          @nearbyUsers = User.includes(:address).references(:address).merge(addresses)
        end

        if(api)
          render json: addresses;
        else
          return addresses;
        end
      end

      #[POST] /api/user/update
      def update_user(userparams = nil, api = true)
        save_banner_picture_path = ""
        save_profile_picture_path = ""
        if(userparams[:user][:profile_picture])
          # Upload image to Azure Blob Storage
          save_profile_picture_path = uploadImageToAzure(userparams[:user][:profile_picture])
        end

        if(userparams[:user][:banner_picture])
          # Upload image to Azure Blob Storage
          save_banner_picture_path = uploadImageToAzure(userparams[:user][:banner_picture])
        end


        if ([(current_user.update_attribute(:banner_picture, save_banner_picture_path) if userparams[:user][:banner_picture])] && [(current_user.update_attribute(:profile_picture, save_profile_picture_path) if userparams[:user][:profile_picture])] && (current_user.update_attribute(:firstname, userparams[:user][:firstname]) if userparams[:user][:firstname]) && (current_user.update_attribute(:lastname, userparams[:user][:lastname]) if userparams[:user][:lastname]) && (current_user.update_attribute(:email, userparams[:user][:email]) if userparams[:user][:email]) && (current_user.update_attribute(:birthdate, userparams[:user][:birthdate]) if userparams[:user][:birthdate]) && (current_user.update_attribute(:description, userparams[:user][:description]) if userparams[:user][:description]))
          if(api)
            render json: current_user, status: :ok
          else
            return true;
          end
        else
          if(api)
            render json: current_user.errors, status: :unprocessable_entity
          else
            return false;
          end
        end
      end

      #[POST] /api/user/update_walker
      def update_walker(userparams = nil, api = true)
        current_user_id = 0;
        if(!current_user.nil?)
          current_user_id = current_user.id;
        else (params.has_key?(:id))
          if(params[:id])
            current_user_id = params[:id]
          end
        end

        current_user = User.find(current_user_id);

        if(!current_user.availability)
          current_user.availability = Availability.new(:monday_morning => ConvertToBooleanValue(userparams[:user][:availability_attributes][:monday_morning]),
                                            :monday_midday => ConvertToBooleanValue(userparams[:user][:availability_attributes][:monday_midday]),
                                            :monday_evening => ConvertToBooleanValue(userparams[:user][:availability_attributes][:monday_evening]),
                                            :tuesday_morning => ConvertToBooleanValue(userparams[:user][:availability_attributes][:tuesday_morning]),
                                            :tuesday_midday => ConvertToBooleanValue(userparams[:user][:availability_attributes][:tuesday_midday]),
                                            :tuesday_evening => ConvertToBooleanValue(userparams[:user][:availability_attributes][:tuesday_evening]),
                                            :wednesday_morning => ConvertToBooleanValue(userparams[:user][:availability_attributes][:wednesday_morning]),
                                            :wednesday_midday => ConvertToBooleanValue(userparams[:user][:availability_attributes][:wednesday_midday]),
                                            :wednesday_evening => ConvertToBooleanValue(userparams[:user][:availability_attributes][:wednesday_evening]),
                                            :thursday_morning => ConvertToBooleanValue(userparams[:user][:availability_attributes][:thursday_morning]),
                                            :thursday_midday => ConvertToBooleanValue(userparams[:user][:availability_attributes][:thursday_midday]),
                                            :thursday_evening => ConvertToBooleanValue(userparams[:user][:availability_attributes][:thursday_evening]),
                                            :friday_morning => ConvertToBooleanValue(userparams[:user][:availability_attributes][:friday_morning]),
                                            :friday_midday => ConvertToBooleanValue(userparams[:user][:availability_attributes][:friday_midday]),
                                            :friday_evening => ConvertToBooleanValue(userparams[:user][:availability_attributes][:friday_evening]),
                                            :saturday_morning => ConvertToBooleanValue(userparams[:user][:availability_attributes][:saturday_morning]),
                                            :saturday_midday => ConvertToBooleanValue(userparams[:user][:availability_attributes][:saturday_midday]),
                                            :saturday_evening => ConvertToBooleanValue(userparams[:user][:availability_attributes][:saturday_evening]),
                                            :sunday_morning => ConvertToBooleanValue(userparams[:user][:availability_attributes][:sunday_morning]),
                                            :sunday_midday => ConvertToBooleanValue(userparams[:user][:availability_attributes][:sunday_midday]),
                                            :sunday_evening => ConvertToBooleanValue(userparams[:user][:availability_attributes][:sunday_evening]));
        end

        if ((current_user.update_attribute(:number_of_walks, userparams[:user][:number_of_walks]) if userparams[:user][:number_of_walks]) && (current_user.update_attribute(:walking_region, userparams[:user][:walking_region]) if userparams[:user][:walking_region]) && (current_user.update_attribute(:skills, userparams[:user][:skills]) if userparams[:user][:skills]) && (current_user.update_attribute(:professional, ConvertToBooleanValue(userparams[:user][:professional])))  && (current_user.availability.update_attribute(:monday_morning, ConvertToBooleanValue(userparams[:user][:availability_attributes][:monday_morning]))) && (current_user.availability.update_attribute(:monday_midday, ConvertToBooleanValue(userparams[:user][:availability_attributes][:monday_midday]))) && (current_user.availability.update_attribute(:monday_evening, ConvertToBooleanValue(userparams[:user][:availability_attributes][:monday_evening]))) && (current_user.availability.update_attribute(:tuesday_morning, ConvertToBooleanValue(userparams[:user][:availability_attributes][:tuesday_morning]))) && (current_user.availability.update_attribute(:tuesday_midday, ConvertToBooleanValue(userparams[:user][:availability_attributes][:tuesday_midday]))) && (current_user.availability.update_attribute(:tuesday_evening, ConvertToBooleanValue(userparams[:user][:availability_attributes][:tuesday_evening]))) && (current_user.availability.update_attribute(:wednesday_morning, ConvertToBooleanValue(userparams[:user][:availability_attributes][:wednesday_morning]))) && (current_user.availability.update_attribute(:wednesday_midday, ConvertToBooleanValue(userparams[:user][:availability_attributes][:wednesday_midday]))) && (current_user.availability.update_attribute(:wednesday_evening, ConvertToBooleanValue(userparams[:user][:availability_attributes][:wednesday_evening]))) && (current_user.availability.update_attribute(:thursday_morning, ConvertToBooleanValue(userparams[:user][:availability_attributes][:thursday_morning]))) && (current_user.availability.update_attribute(:thursday_midday, ConvertToBooleanValue(userparams[:user][:availability_attributes][:thursday_midday]))) && (current_user.availability.update_attribute(:thursday_evening, ConvertToBooleanValue(userparams[:user][:availability_attributes][:thursday_evening]))) && (current_user.availability.update_attribute(:friday_morning, ConvertToBooleanValue(userparams[:user][:availability_attributes][:friday_morning]))) && (current_user.availability.update_attribute(:friday_midday, ConvertToBooleanValue(userparams[:user][:availability_attributes][:friday_midday]))) && (current_user.availability.update_attribute(:friday_evening, ConvertToBooleanValue(userparams[:user][:availability_attributes][:friday_evening]))) && (current_user.availability.update_attribute(:saturday_morning, ConvertToBooleanValue(userparams[:user][:availability_attributes][:saturday_morning]))) && (current_user.availability.update_attribute(:saturday_midday, ConvertToBooleanValue(userparams[:user][:availability_attributes][:saturday_midday]))) && (current_user.availability.update_attribute(:saturday_evening, ConvertToBooleanValue(userparams[:user][:availability_attributes][:saturday_evening]))) && (current_user.availability.update_attribute(:sunday_morning, ConvertToBooleanValue(userparams[:user][:availability_attributes][:sunday_morning]))) && (current_user.availability.update_attribute(:sunday_midday, ConvertToBooleanValue(userparams[:user][:availability_attributes][:sunday_midday]))) && (current_user.availability.update_attribute(:sunday_evening, ConvertToBooleanValue(userparams[:user][:availability_attributes][:sunday_evening]))) && (current_user.update_attribute(:preference, Preference.find(userparams[:user][:preference].to_i)) if userparams[:user][:preference]) && (current_user.update_attribute(:is_walker, ConvertToBooleanValue(userparams[:user][:is_walker])))  && (current_user.update_attribute(:experience, Experience.find(userparams[:user][:experience].to_i)) if userparams[:user][:experience]))
          if(api)
            render json: current_user, status: :ok
          else
            return true;
          end
        else
          if(api)
            render json: current_user.errors, status: :unprocessable_entity
          else
            return false;
          end
        end
        
      end

    # Overall methods

      def uploadImageToAzure(param)
        fileExtension = File.extname(param.original_filename)

        fileName = current_user.id.to_s.to_s.rjust(3, "0") + '/' + SecureRandom.uuid + fileExtension
        blobs = Azure::Blob::BlobService.new
        content = File.open(param.tempfile.path, 'rb') { |file| file.read }
        blob = blobs.create_block_blob("images", fileName, content)

        #Blob has been uploaded
        return 'https://' + Azure.config.storage_account_name + '.blob.core.windows.net/images/' + fileName
      end
    end
  end
end