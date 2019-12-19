require "rails_helper"

RSpec.describe TourDetail, type: :model do
  let!(:tour) {FactoryBot.create :tour}
  subject {tour}
  
  let!(:tour_detail) {FactoryBot.create :tour_detail, tour: tour}
  subject {tour_detail}

  #Test TourDetail model validations
  context ".validate :" do
    before {tour_detail.save}

    it "is valid with valid attributes" do
      expect(tour_detail).to be_valid
    end

    it "is not valid without a start time" do
      tour_detail.start_time = ""
      expect(tour_detail).to_not be_valid
    end

    it "is not valid without a end time" do
      tour_detail.end_time = ""
      expect(tour_detail).to_not be_valid
    end

    it "is not valid without a price" do
      tour_detail.price = ""
      expect(tour_detail).to_not be_valid
    end

    it "is not valid without a people number" do
      tour_detail.people_number = ""
      expect(tour_detail).to_not be_valid
    end

    it "is not valid with start time later than end time" do
      tour_detail.start_time = "2019-12-20"
      tour_detail.end_time = "2019-12-18"
      expect(tour_detail).to_not be_valid
    end
  end

  context ".associations :" do
    it "has many reviews" do
      assc = TourDetail.reflect_on_association :reviews
      expect(assc.macro).to eq :has_many
    end

    it "has many bookings" do
      assc = TourDetail.reflect_on_association :bookings
      expect(assc.macro).to eq :has_many
    end

    it "has many pictures" do
      assc = TourDetail.reflect_on_association :pictures
      expect(assc.macro).to eq :has_many
    end

    it "belongs to a tour" do
      tour = Tour.new
      tour_detail = TourDetail.new
      tour.tour_details << tour_detail
      expect(tour_detail.tour).to be tour
    end
  end

  #Test Tour model body methods
  describe "#soft_delete" do
    before do
      tour_detail.soft_delete
    end

    it "set deleted_at field as deletion time" do
      expect(tour_detail.deleted_at.class).to be(ActiveSupport::TimeWithZone)
    end
  end

  describe "#recover" do
    before do
      tour_detail.soft_delete
      tour_detail.recover
    end

    it "set deleted_at field as nil" do
      expect(tour_detail.deleted_at).to be_nil
    end
  end

  describe "#search" do
    before do
      @tour_details = TourDetail.search(tour_detail.tour.name)
    end

    it "return the record with the name like the search term" do
      expect(@tour_details).to exist
    end
  end
end
