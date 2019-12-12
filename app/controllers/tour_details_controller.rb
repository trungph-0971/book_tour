class TourDetailsController < ApplicationController
  before_action :admin_user, except: %i(index show)
  before_action :load_tour_detail, except: %i(index new create)

  def index
    @tour_details = TourDetail.search(params[:term])
                              .paginate(page: params[:page])
  end

  def new
    @tour_detail = TourDetail.new
  end

  def show
    @tour = Tour.find_by id: @tour_detail.tour_id
    @category = Category.find_by id: @tour.category_id
  end

  def create
    @tour_detail = TourDetail.new tour_detail_params
    @tour_detail.link = params[:tour_detail][:pictures_attributes][:link]
    if @tour_detail.save
      flash[:success] = t(".create_success")
      redirect_to @tour_detail
    else
      flash[:danger] = t(".create_failed")
      render :new
    end
  end

  def destroy
    if @tour_detail.destroy
      flash[:success] = t(".delete_success")
    else
      flash[:danger] = t(".delete_failed")
    end
    redirect_to tour_details_path
  end

  def edit; end

  def update
    @tour_detail.link = params[:tour_detail][:pictures_attributes][:link]
    if @tour_detail.update tour_detail_params
      flash[:success] = t(".update_success")
      redirect_to @tour_detail
    else
      flash[:danger] = t(".update_failed")
      render :edit
    end
  end

  private

  def tour_detail_params
    params.require(:tour_detail).permit :start_time, :end_time, :tour_id,
                                        :price, :people_number, :term
  end

  # Confirms an admin user.
  def admin_user
    redirect_to root_path unless current_user.role == "admin"
  end

  def load_tour_detail
    @tour_detail = TourDetail.find_by id: params[:id]
    return if @tour_detail

    flash[:danger] = t("tour_details.nonexist")
    redirect_to root_path
  end
end
