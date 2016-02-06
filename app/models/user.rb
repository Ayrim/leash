class User < ActiveRecord::Base
  	authenticates_with_sorcery!
  	validates_confirmation_of :password, message: "should match the initial password.", if: :password
  	validates_presence_of :password, :password_confirmation, length: { minimum: 4 }
  	validates_uniqueness_of :email

	validates :terms_of_service, :acceptance => true

	before_save :downcase_email
	before_create :create_activation_digest

  	attr_accessor :password, :password_confirmation, :activation_token, :reset_token

	has_one :address
	has_many :animals

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
