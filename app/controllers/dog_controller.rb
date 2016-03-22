class DogController < ApplicationController
  def index
    @dog = Dog.all
  end

  def new
  end

  def show
    @dog = Dog.find(params[:id])
  end

  def create
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
end
