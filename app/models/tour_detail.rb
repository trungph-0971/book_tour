class TourDetail < ApplicationRecord
  belongs_to :tour
  has_many :reviews, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_one :revenue, dependent: :destroy
  has_one :picture, as: :pictureable, dependent: :destroy,
            inverse_of: :pictureable
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :price, presence: true
  validates :people_number, presence: true
  validate :end_time_after_start_time?

  private

  def end_time_after_start_time?
    return unless end_time? && start_time?

    return unless end_time < start_time

    errors.add :end_time, "must be after start date"
  end
end
