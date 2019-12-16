class Booking < ApplicationRecord
  belongs_to :tour_detail
  belongs_to :user
  validates :people_number, presence: true
  before_save :cal_price
  enum status: {pending: 1, confirmed: 2, cancelled: 3}
  scope :not_deleted, ->{where("deleted_at IS NULL")}
  scope :deleted, ->{where("deleted_at IS NOT NULL")}

  def soft_delete
    update deleted_at: Time.zone.now
  end

  def recover
    update deleted_at: nil
  end

  private
  def cal_price
    @tour_detail = TourDetail.find_by id: tour_detail_id
    self.price = @tour_detail.price * people_number
  end
end
