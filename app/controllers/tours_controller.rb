class ToursController < ApplicationController
  before_action :admin_user
  before_action :load_tour, except: %i(index new create)

  def index
    @tours = Tour.includes(:category).all.paginate(page: params[:page])
  end

  def show
    @category = Category.find_by id: @tour.category_id
  end

  def new
    @tour = Tour.new
  end

  def create
    @tour = Tour.new tour_params
    if @tour.save
      flash[:success] = t(".add_success")
      redirect_to @tour
    else
      flash[:danger] = t(".add_failed")
      render :new
    end
  end

  def destroy
    if @tour.destroy
      flash[:success] = t(".delete_success")
    else
      flash[:danger] = t(".delete_failed")
    end
    redirect_to tours_path
  end

  def edit; end

  def update
    if @tour.update tour_params
      flash[:success] = t(".update_success")
      redirect_to @tour
    else
      flash[:danger] = t(".update_failed")
      render :edit
    end
  end

  private

  def tour_params
    params.require(:tour).permit(:name, :description, :category_id)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to root_path unless current_user.role == "admin"
  end

  def load_tour
    @tour = Tour.find_by id: params[:id]
    return if @tour

    flash[:danger] = t("tours.nonexist")
    redirect_to root_path
  end
end