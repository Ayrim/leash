class User < ActiveRecord::Base
  	authenticates_with_sorcery!
  	validates_confirmation_of :password, message: "Should match confirmation.", if: :password
  	validates_uniqueness_of :email

  	attr_accessor :password, :password_confirmation

	has_one :address
	has_many :animals
end
