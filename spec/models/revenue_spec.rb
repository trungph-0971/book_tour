require "rails_helper"

RSpec.describe Revenue, type: :model do
  let!(:tour_detail) {FactoryBot.create :tour_detail}
  subject {tour_detail}

  let!(:revenue) {FactoryBot.create :revenue, tour_detail: tour_detail}
  subject {revenue}

  context ".validate :" do
    before {revenue.save}

    it "valid with valid attributes" do
      expect(revenue).to be_valid
    end

    it "not valid without a revenue" do
      revenue.revenue = ""
      expect(revenue).to_not be_valid
    end
  end

  context ".associations :" do
    it "belongs to tour detail" do
      tour_detail = TourDetail.new
      revenue = Revenue.new
      tour_detail.revenue = revenue
      expect(revenue.tour_detail).to be tour_detail
    end
  end
end
