class User < ActiveRecord::Base
  	authenticates_with_sorcery!
  	validates_confirmation_of :password, message: "should match the initial password.", if: :password
  	validates_presence_of :password, :password_confirmation, length: { minimum: 4 }
  	validates_uniqueness_of :email

	validates :terms_of_service, :acceptance => true

  	attr_accessor :password, :password_confirmation

	has_one :address
	has_many :animals
end
