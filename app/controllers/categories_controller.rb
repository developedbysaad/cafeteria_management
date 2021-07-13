class CategoriesController < ApplicationController
  before_action :ensure_owner_logged_in, only: [:index, :edit]

  def index
    categories = Category.all
    render "index", locals: { categories: categories }
  end

  def create
    name = params[:name]
    category = Category.new(name: name)
    if category.valid?
      category.save
      flash[:notice] = "#{category.name} category added successfully"
    else
      flash[:error] = category.errors.full_messages.join(", ")
    end
    redirect_to categories_path
  end

  def edit
    id = params[:id]
    category = Category.find(id)
    render "category_edit", locals: { category: category }
  end

  def update
    id = params[:id]
    category = Category.find(id)
    category.name = params[:name]
    if category.valid?
      category.save
      flash[:notice] = "Update Successful"
      redirect_to categories_path
    else
      flash[:error] = category.errors.full_messages.join(", ")
      redirect_to edit_category_path
    end
  end

  def destroy
    id = params[:id]
    category = Category.find(id)
    Order.deleteCurrentCategoryCartItems(category)
    category.destroy
    redirect_to categories_path
  end
end
