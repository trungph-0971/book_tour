require "rails_helper"

RSpec.describe Review, type: :model do
  let!(:user) {FactoryBot.create :user}
  subject {user}

  let!(:tour_detail) {FactoryBot.create :tour_detail}
  subject {tour_detail}

  let!(:review) {FactoryBot.create :review, user: user, 
                                            tour_detail: tour_detail}
  subject {review}

  #Test Review model validations
  context ".validate :" do
    before {review.save}

    it "is valid with valid attributes" do
      expect(review).to be_valid
    end

    it "is not valid without rating" do
      review.rating = ""
      expect(review).to_not be_valid
    end

    it "is not valid with rating point greater than 10" do
      review.rating = "11"
      expect(review).to_not be_valid
    end

    it "is not valid with rating point less than 1" do
      review.rating = "0"
      expect(review).to_not be_valid
    end

    it "is not valid without content" do
      review.content = ""
      expect(review).to_not be_valid
    end
  end

  context ".associations :" do
    it "belongs to a user" do
      user = User.new
      review = Review.new
      user.reviews << review
      expect(review.user).to be user
    end

    it "belongs to a tour detail" do
      tour_detail = TourDetail.new
      review = Review.new
      tour_detail.reviews << review
      expect(review.tour_detail).to be tour_detail
    end

    it "has many likes" do
      assc = Review.reflect_on_association :likes
      expect(assc.macro).to eq :has_many
    end

    it "has many comments" do
      assc = Review.reflect_on_association :comments
      expect(assc.macro).to eq :has_many
    end

    it "has many pictures" do
      assc = Review.reflect_on_association :pictures
      expect(assc.macro).to eq :has_many
    end
  end
end
