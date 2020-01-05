require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  let!(:review) {FactoryBot.create :review}
  let!(:comment_1) {FactoryBot.create(:comment, commentable: review)}
  let!(:comment_2) {FactoryBot.create(:comment, commentable: comment_1)}
  let! :comment_param do
    {
      content: Faker::Lorem.paragraph,
      commentable_type: "Review",
      commentable_id: review.id,
    }
  end

  describe "GET #new: " do
    login_user
    before {get :new}
    it {should respond_with :ok}
    it {should render_template :new}
  end

  describe "POST #create: " do
    login_user
    context "post a comment" do
      before {post :create, params: {comment: comment_param, user_id: subject.current_user.id, review_id: review.id}}
      it {should redirect_back fallback_location: review.tour_detail}
      it {should set_flash.now[:success]}
      it "create a new comment for that review" do
        comment = Comment.last
        expect(assigns(:comment)).to eq Comment.find_by(commentable_id: review.id, user_id: subject.current_user.id)
      end
    end

    context "reply a comment" do
      before do
        comment_param[:commentable_type] = "Comment"
        comment_param[:commentable_id] = comment_1.id
        post :create, params: {comment: comment_param, user_id: subject.current_user.id, comment_id: comment_1.id
      end
      it {should redirect_back fallback_location: review.tour_detail}
      it {should set_flash.now[:success]}
      it "reply with a new comment for that comment" do
        comment = Comment.last
        expect(assigns(:comment)).to eq Comment.find_by(commentable_id: comment_1.id, user_id: subject.current_user.id)
      end
    end

    context "with invalid attributes" do
      before do
        comment_param[:content] = ""
      end
      it {should redirect_back fallback_location: review.tour_detail}
      it {should set_flash.now[:danger]}
    end
  end

  describe "DELETE #destroy: " do
    context "current user delete his/her comment" do
      
    end

    context "current user tryna delete other's commnet" do
      
    end
  end
end