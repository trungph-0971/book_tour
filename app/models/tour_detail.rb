class TourDetail < ApplicationRecord
  belongs_to :tour
  has_many :reviews, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_one :revenue, dependent: :destroy
  has_one :picture, as: :pictureable, dependent: :destroy,
            inverse_of: :pictureable
end
