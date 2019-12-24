require "rails_helper"

RSpec.describe Booking, type: :model do
  let!(:user) {FactoryBot.create :user}
  subject {user}

  let!(:tour_detail) {FactoryBot.create :tour_detail}
  subject {tour_detail}

  let!(:booking) {FactoryBot.create :booking, user: user, 
                                              tour_detail: tour_detail}
  subject {booking}

  #Test Booking model validations
  context ".validate :" do
    before {booking.save}

    it "is valid with valid attributes" do
      expect(booking).to be_valid
    end

    it "is not valid without people number" do
      booking.people_number = ""
      expect(booking).to_not be_valid
    end

    it "is not valid with people number equal 0" do
      booking.people_number = "0"
      expect(booking).to_not be_valid
    end
  end

  context ".associations :" do
    it "belongs to a tour detail" do
      tour_detail = TourDetail.new
      booking = Booking.new
      tour_detail.bookings << booking
      expect(booking.tour_detail).to be tour_detail
    end

    it "belongs to a user" do
      user = User.new
      booking = Booking.new
      user.bookings << booking
      expect(booking.user).to be user
    end
  end

  #Test Booking model body methods
  describe "#soft_delete" do
    before do
      booking.soft_delete
    end

    it "set deleted_at field as deletion time" do
      expect(booking.deleted_at.class).to be(ActiveSupport::TimeWithZone)
    end
  end

  describe "#recover" do
    before do
      booking.soft_delete
      booking.recover
    end

    it "set deleted_at field as nil" do
      expect(booking.deleted_at).to be_nil
    end
  end

  describe "#cal_price" do
    before do
      booking.save
    end

    it "set price of booking equal tour detail price multiply booking people number" do
      expect(booking.price).to be(tour_detail.price * booking.people_number)
    end
  end
end
