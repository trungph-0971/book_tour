class BookingsController < ApplicationController
  respond_to :html, :json

  def index; end

  def show
    @booking = Booking.find_by id: params[:id]
  end

  def new
    @booking = Booking.new
    @tour_detail = params[:tour_detail]
    respond_modal_with @booking, @tour_detail
  end

  def create
    @tour_detail = TourDetail.find_by id: params[:booking][:tour_detail_id]
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

  def update; end

  private

  def booking_params
    params.require(:booking).permit(:tour_detail_id, :price, :people_number)
  end
end
