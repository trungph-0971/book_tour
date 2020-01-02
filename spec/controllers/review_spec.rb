require "rails_helper"

RSpec.describe ReviewsController, type: :controller do
  let!(:user) {FactoryBot.create :user}
  let!(:tour_detail) {FactoryBot.create :tour_detail}
  let!(:review_clone) {FactoryBot.create :review, user: user, tour_detail: tour_detail}
  let! :review_param do
    {
      rating: Faker::Number.between(from: 1, to: 10),
      content: Faker::Lorem.paragraph,
      pictures_attributes: {link: Faker::LoremPixel.image},
      user_id: user.id,
      tour_detail_id: tour_detail.id
    } 
  end

  describe "GET #index: " do
    context "user is admin" do
      login_admin
      before {get :index}
      it {should respond_with :ok}
      it {should render_template :index}
      it "should see all the reviews" do
        expect(assigns(:reviews)).to eq Review.all.to_a
      end
    end

    context "user is not admin" do
      login_user
      before {get :index}
      it {should respond_with :ok}
      it {should render_template :index}
      it "should see all the reviews belongs to that user" do
        expect(assigns(:reviews)).to eq Review.where(user_id: subject.current_user.id).to_a
      end
    end
  end

  describe "GET #new: " do
    login_user
    before {get :new, params: {user: subject.current_user, tour_detail: tour_detail}}
    it {should respond_with :ok}
    it {should render_template :new}
  end

  describe "POST #create: " do
    login_user
    context "create with valid attributes" do
      before do
        get :new, params: {user: subject.current_user, tour_detail: tour_detail}
        post :create, params: {review: review_param, tour_detail: tour_detail}
      end
      it {should redirect_to tour_detail}
      it {should set_flash.now[:success]}
    end

    context "create with valid attributes" do
      before do
        review_param[:rating] = ""
        review_param[:content] = ""
        get :new, params: {user: subject.current_user, tour_detail: tour_detail}
        post :create, params: {review: review_param, tour_detail: tour_detail}
      end
      it {should redirect_to tour_detail}
      it {should set_flash.now[:danger]}
    end
  end

  describe "DELETE #destroy: " do
    login_user
    before do
      get :new, params: {user: subject.current_user, tour_detail: tour_detail}
      post :create, params: {review: review_param, tour_detail: tour_detail}
      delete :destroy, params: {id: Review.last.id}
    end
    it {should redirect_to tour_detail}
    it {should set_flash.now[:success]}
  end
end
