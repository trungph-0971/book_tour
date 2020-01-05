require "rails_helper"

RSpec.describe LikesController, type: :controller do
  let!(:tour_detail) {FactoryBot.create :tour_detail}
  let!(:review) {FactoryBot.create :review, tour_detail: tour_detail}

  describe "POST #create: " do
    login_user
    before {post :create, params: {tour_detail: tour_detail, review_id: review.id, user_id: subject.current_user.id}}
    context "user has not like that review yet" do
      it {should redirect_to(tour_detail_path(tour_detail.id))}
      it "create a new like on that review" do
        like = Like.last
        expect(Like.find_by(review_id: review.id, user_id: subject.current_user.id)).to eq like
      end
    end

    context "user has liked that review" do
      it {should redirect_to(tour_detail_path(tour_detail.id))}
      it {should set_flash.now[:notice]}
    end
  end
end