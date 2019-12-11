class BookingsController < ApplicationController
  before_action :admin_user, only: %i(edit update)
  before_action :load_tour_detail, only: %i(create reduce_quantity cal_revenue)
  before_action :load_booking, except: %i(index new create)
  after_action :reduce_quantity, :cal_revenue, only: :create
  after_action :increse_quantity, only: :destroy
  respond_to :html, :json

  def index
    @bookings = if current_user.role == "admin"
                  Booking.includes(:tour_detail).all
                         .paginate(page: params[:page])
                else
                  Booking.includes(:tour_detail).where(user_id: current_user.id)
                         .paginate(page: params[:page])
                end
  end

  def show
    @booking = Booking.find_by id: params[:id]
  end

  def new
    @booking = Booking.new
    @tour_detail = params[:tour_detail]
    respond_modal_with @booking, @tour_detail
  end

  def create
    @booking = @tour_detail.bookings.build booking_params
    @booking.user = current_user
    if @booking.save
      flash[:success] = t(".add_success")
      redirect_to @booking
    else
      flash[:danger] = t(".add_failed")
      render :new
    end
  end

  def edit; end

  def update
    if @booking.update booking_params
      flash[:success] = t(".update_success")
      redirect_to @booking
    else
      flash[:danger] = t(".update_failed")
      render :edit
    end
  end

  def destroy
    if current_user.role == "admin"
      if @booking.destroy
        flash[:success] = t(".delete_success")
      else
        flash[:danger] = t(".delete_failed")
      end
    else
      @booking.status = "cancelled"
      @booking.save
    end
    redirect_to bookings_path
  end

  private

  def booking_params
    params.require(:booking).permit(:tour_detail_id, :price, :people_number)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to root_path unless current_user.role == "admin"
  end

  def load_booking
    @booking = Booking.find_by id: params[:id]
    return if @booking

    flash[:danger] = t("bookings.nonexist")
    redirect_to root_path
  end

  def load_tour_detail
    @tour_detail = TourDetail.find_by id: params[:booking][:tour_detail_id]
  end

  def reduce_quantity
    @tour_detail.people_number =
      @tour_detail.people_number - @booking.people_number
    TourDetail.update @tour_detail.id,
                      people_number: @tour_detail.people_number
  end

  def increse_quantity
    people_number =
      @booking.tour_detail.people_number + @booking.people_number
    TourDetail.update @booking.tour_detail_id,
                      people_number: people_number
  end

  def cal_revenue
    if Revenue.exists?(tour_detail_id: @tour_detail.id)
      @revenue = Revenue.find_by tour_detail_id: @tour_detail.id
      @revenue.revenue = @revenue.revenue + @booking.price
      @revenue.save
    else
      Revenue.create revenue: @booking.price, tour_detail_id: @tour_detail.id
    end
  end
end
