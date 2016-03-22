class DogController < ApplicationController
  def index
    @dog = Dog.all
  end

  def new
  end

  def show

  end

  def create
    @animal = Animal.new(animal_params)
    @dog = Dog.new(dog_parameters)

    if @dog.save
      redirect_to @dog
    else
      render 'new'
    end
  end

  private
    def dog_params
      params.require(:dog).permit(:breed)
    end
  private
    def animal_params
      params.require(:animal).permit(:name)
    end
end
