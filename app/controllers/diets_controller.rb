class DietsController < ApplicationController
	before_action :logged_in_user, except: [:show]
  
  def show
    @diet = Diet.find(params[:id])
    @recipes = @diet.recipes.paginate(page: params[:page], per_page: 4)
  end
  
  def new
    @diet = Diet.new
  end
  
  def create
    @diet = Diet.new(diet_params)
    if @diet.save
      flash[:success] = "Diet created succesfully"
      redirect_to recipes_path
    else
      render 'new'
    end
  end
  
  private
  
  def diet_params
    params.require(:diet).permit(:name)
  end
  
end