class ToursController < ApplicationController
  before_action :load_tour, except: %i(index new create)

  def index
    @tour = Tour.includes(:category).all.paginate(page: params[:page])
  end

  def show; end

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
      flash[:success] = t(".delete.success")
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

  def load_tour
    @tour = Tour.find_by id: params[:id]
    return if @tour

    flash[:danger] = t(".nonexist")
    redirect_to root_path
  end
end
