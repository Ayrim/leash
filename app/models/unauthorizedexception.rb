class Unauthorizedexception
	attr_accessor :message, :code
      
	def initialize(attributes = {})
	    self.message ||= "Access Denied"
	    self.code ||= "401"
  end
end
