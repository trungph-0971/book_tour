require "rails_helper"

RSpec.describe TourDetailsController, type: :controller do
  let!(:category) {FactoryBot.create :category}
  let!(:tour) {FactoryBot.create :tour, category: category}
  let!(:tour_detail_clone) {FactoryBot.create :tour_detail, tour: tour}
  let! :tour_detail_param do
    {
      start_time: Faker::Date.in_date_period(year: 2020, month: 2),
      end_time: Faker::Date.in_date_period(year: 2020, month: 3),
      price: Faker::Number.decimal(l_digits: 2),
      people_number: Faker::Number.number(digits: 2),
      pictures_attributes: {link: Faker::LoremPixel.image},
      tour_id: tour.id
    }
  end

  describe "GET #index: " do
    before {get :index}
    it {should respond_with :ok}
    it {should render_template :index}
  end

  describe "GET #new: " do
    context "user is admin" do
      login_admin
      before {get :new}
      it {should respond_with :ok}
      it {should render_template :new}
    end

    context "user is not admin" do
      login_user
      before {get :new}
      it {should set_flash[:warning]}
      it {should redirect_to(root_path)}
    end
  end

  describe "POST #create: " do
    login_admin
    context "with valid attributes" do
      before {post :create, params: {tour_detail: tour_detail_param}}
      it {should set_flash[:success]}
      it do
        tour_detail = TourDetail.last
        should redirect_to tour_detail
      end
    end

    context "with invalid attributes" do
      before do
        tour_detail_param[:start_time] = ""
        tour_detail_param[:end_time] = ""
        tour_detail_param[:price] = "five dollars"
        tour_detail_param[:people_number] = "five"
        post :create, params: {tour_detail: tour_detail_param}
      end
      it {should set_flash[:danger]}
      it {should render_template :new}
    end
  end

  describe "DELETE #destroy: " do
    context "user is admin" do
      login_admin
      before {delete :destroy, params: {id: tour_detail_clone.id}}
      it {should redirect_to tour_details_path}
      it {should set_flash[:success]}
      it "set deleted_at field as deletion time" do
        expect(TourDetail.find_by(id: tour_detail_clone.id).deleted_at.class).to be(ActiveSupport::TimeWithZone)
      end
    end

    context "user is not admin" do
      login_user
      before {delete :destroy, params: {id: tour_detail_clone.id}}
      it {should redirect_to root_path}
      it {should set_flash[:warning]}
    end
  end

  describe "DELETE #purge: " do
    context "user is admin" do
      login_admin
      before {delete :purge, params: {id: tour_detail_clone.id}}
      it {redirect_to tour_details_path}
      it {should set_flash[:success]}
      it "should delete the tour" do
        expect(TourDetail.find_by id: tour_detail_clone.id).to be_nil
      end
    end

    context "user is not admin" do
      login_user
      before {delete :purge, params: {id: tour_detail_clone.id}}
      it {redirect_to root_path}
      it {should set_flash[:warning]}
    end
  end

  describe "PUT #recover: " do
    context "user is admin" do
      login_admin
      before do
        delete :destroy, params: {id: tour_detail_clone.id}
        put :recover, params: {id: tour_detail_clone.id}
      end
      it {redirect_to tour_details_path}
      it {should set_flash[:success]}
      it "set deleted_at field as nil" do
        expect(TourDetail.find_by(id: tour_detail_clone.id).deleted_at).to be_nil
      end
    end

    context "user is not admin" do
      login_user
      before do
        delete :destroy, params: {id: tour_detail_clone.id}
        put :recover, params: {id: tour_detail_clone.id}
      end
      it {redirect_to root_path}
      it {should set_flash[:warning]}
    end
  end

  describe "GET #edit: " do
    context "user is admin" do
      login_admin
      before {get :edit, params: {id: tour_detail_clone.id}}

      it {should respond_with :ok}
      it {should render_template :edit}
    end

    context "user is not admin" do
      login_user
      before {get :edit, params: {id: tour_detail_clone.id}}
      it {should set_flash[:warning]}
      it {should redirect_to(root_path)}
    end
  end

  describe "PUT #update: " do
    context "user is admin and update with valid attributes" do
      login_admin
      before {put :update, params: {id: tour_detail_clone.id, tour_detail: tour_detail_param}}
      
      it {should set_flash[:success]}
      it {should redirect_to tour_detail_clone}
    end

    context "user is admin and update with invalid attributes" do
      login_admin
      before do
        tour_detail_param[:start_time] = ""
        tour_detail_param[:end_time] = ""
        tour_detail_param[:price] = "five dollars"
        tour_detail_param[:people_number] = "five"
        put :update, params: {id: tour_detail_clone.id, tour_detail: tour_detail_param}
      end
      it {should set_flash[:danger]}
      it {should render_template :edit}
    end

    context "user is not admin" do
      login_user
      before {put :update, params: {id: tour_detail_clone.id, tour_detail: tour_detail_param}}
      it {should set_flash[:warning]}
      it {should redirect_to root_path}
    end
  end
end