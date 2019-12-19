module BookingsHelper
  def load_bookings_name
    Tour.includes(tour_details: :bookings)
  end
end
