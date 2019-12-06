module BookingsHelper
  def get_bookings_name
    Tour.includes(tour_details: :bookings)
  end
end
