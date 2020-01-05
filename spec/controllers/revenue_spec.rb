require "rails_helper"

RSpec.describe RevenuesController, type: :controller do
  let!(:tour_detail) {FactoryBot.create :tour_detail}
  let!(:revenue_clone) {FactoryBot.create :revenue, tour_detail: tour_detail}
  let! :tour_detail_param do
    {
      revenue: tour_detail.price
    }
  end

  describe "GET #index: " do
    context "user is admin" do
      login_admin
      before {get :index}
      it {should respond_with :ok}
      it {should render_template :index}
    end

    context "user is not admin" do
      login_user
      before {get :index}
      it {should set_flash[:warning]}
      it {should redirect_to(root_path)}
    end
  end

  describe "GET #show: " do
    context "user is admin" do
      login_admin
      before {get :show, params: {id: revenue_clone.id, tour_detail_id: tour_detail.id}}
      it {should respond_with :ok}
      it {should render_template :show}
      it "get the bookings in that tour detail" do
        bookings = Booking.where(tour_detail_id: tour_detail.id)
        expect(assigns(:bookings)).to eq bookings.to_a
      end
    end

    context "user is not admin" do
      login_user
      before {get :show, params: {id: revenue_clone.id, tour_detail_id: tour_detail.id}}
      it {should set_flash[:warning]}
      it {should redirect_to(root_path)}
    end
  end

  describe "DELETE #destroy: " do
    context "user is admin" do
      login_admin
      before {delete :destroy, params: {id: revenue_clone.id}}
      it {should set_flash[:success]}
      it {should redirect_to(revenues_path)}
      it "should delete the revenue" do
        expect(Revenue.find_by id: revenue_clone.id).to be_nil
      end
    end

    context "user is not admin" do
      login_user
      before {delete :destroy, params: {id: revenue_clone.id}}
      it {should set_flash[:warning]}
      it {should redirect_to(root_path)}
    end
  end

  describe "GET #revenue_detail: " do
    context "user is admin" do
      login_admin
      before {get :revenue_detail}
      it {should render_template :table}
      it "should get all the revenues" do
        expect(assigns(:revenues)).to eq Revenue.all.to_a
      end
    end

    context "user is not admin" do
      login_user
      before {get :revenue_detail}
      it {should set_flash[:warning]}
      it {should redirect_to(root_path)}
    end
  end
end