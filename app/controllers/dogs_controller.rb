class DogsController < ApplicationController
  def index
    @dog = Dog.all
  end

  def show
    if(params[:id] != 'update_unreadmessages')
      @dog = Dog.find(params[:id])
    end
  end

  def create
    puts dog_params

    @animal = Animal.new(animal_params)

    if @animal.save
      @dog = Dog.new(:animal_id => @animal.id, :breed => params[:animal][:dog][:breed])
      if@dog.save
        redirect_to @dog
      else
        render 'new'
      end
    else
      render 'new'
    end
  end

  private
    def dog_params
      params.require(:animal).permit(dog_attributes: :breed)
    end
  private
    def animal_params
      params.require(:animal).permit(:name,:user_id, dog_attributes: :breed)
    end
end
