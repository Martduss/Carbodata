class RecipesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :require_owner!, only: [:edit, :update, :destroy]

  def index
    if params[:query].present?
      @recipes = current_user.recipes.search_by_name_description_difficulty_indice_gly(params[:query])
    else
      @recipes = current_user.recipes
    end
    @recipe = Recipe.new
    # Group recipes by GI level
    @low_gi_recipes = current_user.recipes.where('indice_gly < ?', 55).order(created_at: :desc)
    @medium_gi_recipes = current_user.recipes.where('indice_gly >= ? AND indice_gly <= ?', 55, 70).order(created_at: :desc)
    @high_gi_recipes = current_user.recipes.where('indice_gly > ?', 70).order(created_at: :desc)
    # For the SuperCarbo chat option
    @chat_item = ChatItem.new
    @items = current_user.items
  end

  def show
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    
    if @recipe.save!
      redirect_to recipes_path, notice: "The recipe has been created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to recipes_path, notice: "Recipe has been updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @recipe.destroy
      redirect_to recipes_path, status: :see_other, notice: "Recipe has been deleted"
    else
      redirect_to recipe_path(@recipe), alert: "Impossible to delete the recipe"
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, :steps, :difficulty, :indice_gly, :ratio_glucide, :photo, :visibility)
  end

  def set_recipe
    @recipe = Recipe.accessible_by(current_user).find(params[:id])
  end

  def require_owner!
    redirect_to recipes_path, alert: "You are not authorized to modify this recipe." unless @recipe.user == current_user
  end
end
