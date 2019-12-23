require "rails_helper"
require "./app/helpers/sessions_helper"

RSpec.configure do |c|
  c.include SessionsHelper
end

RSpec.describe UsersController, type: :controller do
  let!(:user) {FactoryBot.create :user}
  let! :user_param do
    {
      name: Faker::Name.name,
      email: "user@suntour.com",
      password: "johndoe123",
      password_confirmation: "johndoe123",
    }
  end

  let!(:admin) {FactoryBot.create :admin}
  let! :admin_param do
    {
      name: "admin",
      email: "admin@suntour.com",
      password: "admin123",
      password_confirmation: "admin123",
    }
  end

  describe "GET #index: " do

    context "user is admin" do
      before do
        log_in admin
        get :index
      end
      it {should respond_with :ok}
      it {should render_template :index}
    end

    context "user is not admin" do
      before do
        log_in user
        get :index
      end
      it {should redirect_to(root_path)}
    end
  end

  describe "GET #show: " do
    context "when user is existed" do
      before {get :show, params: {id: user.id}}
      it {should respond_with :ok}
      it {should render_template :show}
    end

    context "when user is not existed" do
      before {get :show, params: {id: 0}}
      it {should set_flash[:danger]}
      it {should redirect_to(root_path)}
    end
  end

  describe "GET #new: " do
    it "renders the :new template" do
      get :new
      should respond_with :ok
      should render_template :new
    end
  end

  describe "GET #edit: " do
    context "when logged in" do
      before do
        log_in user
        get :edit, params: {id: user.id}
      end

      it {should render_template :edit}
    end

    context "when not logged in" do
      before do
        user.id -= 1
        get :edit, params: {id: user.id}
      end

      it {should redirect_to(login_path)}
    end

    context "when it is not the correct user" do
      before do
        log_in user
        user.id -= 1
        get :edit, params: {id: user.id}
      end
      it {should set_flash[:danger]}
      it {should redirect_to(root_path)}
    end
  end

  describe "POST #create: " do
    context "with valid attributes" do
      before {post :create, params: {user: user_param}}

      it {should set_flash[:info]}
      it {should redirect_to(root_path)}
    end

    context "with invalid attributes" do
      before do
        user_param[:name] = ""
        user_param[:email] = "skrt$gmail.com"
        user_param[:password] = "john"
        user_param[:password_confirmation] = "johndoe"
        post :create, params: {user: user_param}
      end

      it {should set_flash[:danger]}
      it {should render_template :new}
    end
  end

  describe "PUT update: " do
    context "when update is successful" do
      before do
        log_in user
        user_param[:name] = "John Doe"
        user_param[:email] = "johndoe@gmail.com"
        user_param[:password] = "password"
        user_param[:password_confirmation] = "password"
        patch :update, params: {id: user.id, user: user_param}
      end

      it {should set_flash[:success]}
      it {should redirect_to user}
    end

    context "when update is failed" do
      before do
        log_in user
        user_param[:name] = ""
        user_param[:email] = "johndoe@gmailcom"
        user_param[:password] = "password"
        user_param[:password_confirmation] = "password1"
        patch :update, params: {id: user.id, user: user_param}
      end

      it {should set_flash[:danger]}
      it "return some error messages" do
        expect(assigns(:user).errors.full_messages.count).to be >= 3
      end
      it {should render_template :edit}
    end
  end

  describe "DELETE #destroy: " do
    context "user is admin" do
      before do
        log_in admin
        delete :destroy, params: {id: user.id}
      end

      it {redirect_to users_path}
      it {should set_flash[:success]}
    end

    context "user is not admin" do
      before do
        log_in user
        delete :destroy, params: {id: user.id}
      end
      it {should redirect_to(root_path)}
      it {should set_flash[:danger]}
    end
  end
end
