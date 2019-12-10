class CategoriesController < ApplicationController
  before_action :load_category, except: %i(index new create)
  before_action :admin_user, except: %i(index)

  def index
    @categories = Category.all.paginate(page: params[:page])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new cat_params
    if @category.save
      flash[:success] = t(".add_success")
      redirect_to categories_path
    else
      render :new
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t(".delete_success")
    else
      flash[:danger] = t(".delete_failed")
    end
    redirect_to categories_path
  end

  def edit; end

  def update
    if @category.update cat_params
      flash[:success] = t(".update_success")
      redirect_to @category
    else
      flash[:danger] = t(".update_failed")
      render :edit
    end
  end

  private

  def cat_params
    params.require(:category).permit(:name)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to root_path unless current_user.role == "admin"
  end

  def load_category
    @category = Category.find_by id: params[:id]
    return if @category

    flash[:danger] = t("categories.nonexist")
    redirect_to root_path
  end
end
