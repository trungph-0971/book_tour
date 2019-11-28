class Booking < ApplicationRecord
  belongs_to :tour_detail
  belongs_to :user
  enum status: {pending: 1, confirmed: 2}
end
