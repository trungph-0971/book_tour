require "rails_helper"

RSpec.describe Like, type: :model do
  context ".associations :" do
    it "belongs to a review" do
      review = Review.new
      like = Like.new
      review.likes << like
      expect(like.review).to be review
    end

    it "belongs to a user" do
        user = User.new
        like = Like.new
        user.likes << like
        expect(like.user).to be user
    end
  end
end
