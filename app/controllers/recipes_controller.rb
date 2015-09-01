class RecipesController < ApplicationController
	before_action :set_recipe, only: [:edit, :update, :show, :like]
  before_action :logged_in_user, except: [:show, :index, :like]
  before_action :require_user_like, only: [:like]
  before_action :require_same_user, only: [:edit, :update]
  before_action :admin_user,   only: :destroy

	def index
   @recipes = Recipe.paginate(page: params[:page], per_page: 4)
	end

	def show
    
    end

	def new
    @recipe = Recipe.new
    end
  
   def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    
    if @recipe.save
      flash[:success] = "Your recipe was created succesfully!"
      redirect_to recipes_path
    else
      render :new
    end
  end
  
  def edit
    
  end
  
  def update
    if @recipe.update(recipe_params)
      flash[:success] = "Your recipe was updated succesfully!"
      redirect_to recipe_path(@recipe)
    else
      render :edit
    end
  end

   def destroy
    Recipe.find(params[:id]).destroy
    flash[:success] = "Recipe Deleted"
    redirect_to recipes_path
  end

  def like
    like = Like.create(like: params[:like], user: current_user, recipe: @recipe)
    if like.valid?
      flash[:success] = "Your selection was succesful"
      redirect_to :back
    else
      flash[:danger] = "You can only like/dislike a recipe once"
      redirect_to :back
    end
  end

  private
    def recipe_params
      params.require(:recipe).permit(:name, :summary, :description, :picture, diet_ids: [], ingredient_ids: [])
    end

    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

     # Confirms an admin user. 
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

     def require_same_user
      if current_user != @recipe.user and !current_user.admin?
        flash[:danger] = "You can only edit your own recipes"
        redirect_to recipes_path
      end
    end

    def require_user_like
      if !logged_in?
        flash[:danger] = "You must be logged in to perform that action"
        redirect_to :back
      end
    end
    
end