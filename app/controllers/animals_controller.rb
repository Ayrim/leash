class AnimalsController < ApplicationController
	def new
		@animal = Animal.new
	end

	def create
		@animal = Animal.new(animal_params)
		@animal.save
		redirect_to @animal
	end

	def show
		@animal = Animal.find(params[:id])
	end

	private
		def animal_params
			params.require(:animal).permit(:name, :breed, :birthdate)
		end
end
