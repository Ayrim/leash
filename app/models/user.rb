class User < ActiveRecord::Base
  	authenticates_with_sorcery!
  	validates_confirmation_of :password, message: "should match the initial password.", if: :password
  	validates_presence_of :password, :password_confirmation, length: { minimum: 4 }
  	validates_uniqueness_of :email

	validates :terms_of_service, :acceptance => true

	before_save :downcase_email#, :addGeocoding
	before_create :create_activation_digest

  	attr_accessor :password, :password_confirmation, :activation_token, :reset_token

	has_one :address
	has_many :animals
	has_one :availability
	belongs_to :preference
	belongs_to :experience
	has_one :api_key

	has_many :user_1_connections, -> { where "user_relations.is_pending = false" }, :foreign_key => :user_1_id, :class_name => 'UserRelation'
	has_many :one_connections, :through => :user_1_connections, :source => :user_2
	has_many :user_2_connections, -> { where "user_relations.is_pending = false" }, :foreign_key => :user_2_id, :class_name => 'UserRelation'
	has_many :two_connections, :through => :user_2_connections, :source => :user_1

	has_many :user_1_pending_connections, -> { where "user_relations.is_pending = true" }, :foreign_key => :user_1_id, :class_name => 'UserRelation'
	has_many :one_pending_connections, :through => :user_1_pending_connections, :source => :user_2
	has_many :user_2_pending_connections, -> { where "user_relations.is_pending = true" }, :foreign_key => :user_2_id, :class_name => 'UserRelation'
	has_many :two_pending_connections, :through => :user_2_pending_connections, :source => :user_1


	has_many :photoalbum

  	accepts_nested_attributes_for :address
  	accepts_nested_attributes_for :availability
  	accepts_nested_attributes_for :preference
  	accepts_nested_attributes_for :experience

  	#def addGeocoding
  	#	puts '-------------------------------------'
  	#	puts 'called'
  	#	puts '-------------------------------------'
  	#	self.address.geocode
  	#end

  	def connections
  		(one_connections + two_connections).flatten.uniq.sort_by{|e| e[:updated_at]}.reverse
  	end

  	def pending_connections
  		(one_pending_connections + two_pending_connections).flatten.uniq.sort_by{|e| e[:created_at]}.reverse
  	end

  	def pending_outgoing_connections
  		(one_pending_connections).flatten.uniq
  	end
  	def pending_incoming_connections
  		(two_pending_connections).flatten.uniq
  	end

	# Returns the hash digest of the given string.
	def User.digest(string)
	    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
	                                                  BCrypt::Engine.cost
	    BCrypt::Password.create(string, cost: cost)
	end

  	# Returns a random token.
  	def User.new_token
    	SecureRandom.urlsafe_base64
  	end

  	# Returns true if the given token matches the digest.
  	def authenticated?(attribute, token)
    	digest = send("#{attribute}_digest")
    	return false if digest.nil?
    	BCrypt::Password.new(digest).is_password?(token)
  	end

	# Activates an account.
	def activate
	    update_attribute(:activated,    true)
	    update_attribute(:activated_at, Time.zone.now)
	end

	# Sends activation email.
	def send_activation_email
	    UserMailer.account_activation(self).deliver_now
	end

	# Sets the password reset attributes.
	def create_reset_digest
	    self.reset_token = User.new_token
	    update_attribute(:reset_digest,  User.digest(reset_token))
	    update_attribute(:reset_sent_at, Time.zone.now)
	end

	# Sends reset password email.
	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end
	
	# Returns true if a password reset has expired.
  	def password_reset_expired?
    	reset_sent_at < 2.hours.ago
  	end

	# Sends mail to indicate invite has been accepted
	def send_accept_invitation_mail(current_user)
		UserMailer.invitation_accepted(self, current_user).deliver_now
	end

	def send_invitation_mail(current_user)
		UserMailer.invitation_sent(self, current_user).deliver_now
	end

	def send_rejection_mail(current_user)
		UserMailer.invitation_rejected(self, current_user).deliver_now
	end

  	# Overwrite as_json method to define the fields to be returned in JSON
  	def as_json(options={})
  		super(:only => [:firstname,:lastname,:email, :language, :nationality, :birthdate, :phone, :description, :profile_picture, :banner_picture, :number_of_walks, :walking_region, :skills, :is_premium, :pricing, :professional, :is_walker],
        	:include => {
          		:preference => {:only => [:name]},
          		:experience => {:only => [:value]},
          		:address => {:only => [:street, :number, :numberAddition, :latitude, :longitude, :distance],
          			:include => {
          					:city => {:only => [:name]},
          					:country => {:only => [:name]},
          				}
          			}
        	}
  		)
	end

	private
    	# Converts email to all lower-case.
		def downcase_email
			self.email = email.downcase
		end

		# Creates and assigns the activation token and digest.
		def create_activation_digest
			self.activation_token = User.new_token
			self.activation_digest = User.digest(activation_token)
		end


end
