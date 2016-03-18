class HomeController < ApplicationController
	def index
		@hideHome = true;
	end

	def overview
		@hideHome = true;
	end
end
