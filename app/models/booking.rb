class Booking < ApplicationRecord
  belongs_to :tour_detail
  belongs_to :user
  validates :people_number, presence: true
  before_save :cal_price
  after_save :reduce_quantity, :cal_revenue
  enum status: {pending: 1, confirmed: 2, cancelled: 3}

  private
  def cal_price
    @tour_detail = TourDetail.find_by id: tour_detail_id
    self.price = @tour_detail.price * people_number
  end

  def reduce_quantity
    @tour_detail = TourDetail.find_by id: tour_detail_id
    @tour_detail.people_number = @tour_detail.people_number - people_number
    TourDetail.update @tour_detail.id,
                      people_number: @tour_detail.people_number
  end

  def cal_revenue
    @tour_detail = TourDetail.find_by id: tour_detail_id
    byebug
    if Revenue.exists?(tour_detail_id: @tour_detail.id)
      @revenue = Revenue.find_by tour_detail_id: @tour_detail.id
      @revenue.revenue = @revenue.revenue + price
      @revenue.save
    else
      Revenue.create revenue: price, tour_detail_id: @tour_detail.id
    end
  end
end
