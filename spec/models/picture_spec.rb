require "rails_helper"

RSpec.describe Picture, type: :model do
  let!(:tour_detail) {FactoryBot.create :tour_detail}
  subject {tour_detail}

  let!(:review) {FactoryBot.create :review}
  subject {review}
  
  let!(:picture) {FactoryBot.create :picture,
                 pictureable_type: Review, pictureable_id: review.id}
  subject {picture}

  describe "validations" do
    it { should validate_presence_of(:link)}
  end

  context ".associations :" do
    it {should belong_to(:pictureable)}
  end
end
