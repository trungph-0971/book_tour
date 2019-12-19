class Booking < ApplicationRecord
  belongs_to :tour_detail
  belongs_to :user
  validates :people_number, presence: true,
             numericality: {greater_than: 0}
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

  def paypal_values return_path
    {
      business: "trungphan1328@business.sun.com",
      cmd: "_xclick",
      upload: 1,
      return: "#{Rails.application.secrets.app_host}#{return_path}",
      notify_url: "#{Rails.application.secrets.app_host}/bookings/#{id}/hook",
      invoice: id,
      amount: tour_detail.price,
      currency_code: "GBP",
      item_name: tour_detail.tour.name,
      item_number: tour_detail.id,
      quantity: people_number
    }
  end

  def paypal_url return_path
    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" +
      paypal_values(return_path).to_query
  end

  private
  def cal_price
    @tour_detail = TourDetail.find_by id: tour_detail_id
    self.price = @tour_detail.price * people_number
  end
end
