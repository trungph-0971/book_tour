module TourDetailsHelper
  def get_reviews tour_detail_id
    Review.includes(:user, :tour_detail)
          .where(tour_detail_id: tour_detail_id)
          .paginate(page: params[:page])
  end
end
