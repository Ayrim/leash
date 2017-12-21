class TagsController < ApplicationController


  def index
    @tags = Tag.all
  end

  def show
  end

  def create
    puts tag_params
    tag = Tag.new(tag_params)
    tag.created_by_id = current_user.id


    if tag.save
      render :show
    else
      render 'new'
    end
  end

  private
  def tag_params
    params.require(:tag).permit(:name, :user_id)
  end

end
