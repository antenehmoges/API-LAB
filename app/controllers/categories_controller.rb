class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :update, :destroy]

  def index
    categories = Category.order(:name)
    render json: categories
  end

 
  def show
    render json: category_with_count(@category)
  end

  def create
    category = Category.new(category_params)
    if category.save
      render json: category, status: :created
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def destroy
    equipment_count = @category.equipment.count
    if equipment_count > 0
      render json: { error: "Cannot delete category. #{equipment_count} equipment items still belong to it." },
             status: :conflict
    else
      @category.destroy
      head :no_content
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Category not found" }, status: :not_found
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def category_with_count(category)
    category.as_json.merge(equipment_count: category.equipment.count)
  end
end
