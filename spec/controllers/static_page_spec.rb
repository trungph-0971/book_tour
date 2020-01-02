require "rails_helper"

RSpec.describe StaticPagesController, type: :controller do
  describe "GET #home: " do
    before {get :home}
    it {should respond_with :ok}
    it {should render_template :home}
  end

  describe "GET #help: " do
    before {get :help}
    it {should respond_with :ok}
    it {should render_template :help}
  end

  describe "GET #about: " do
    before {get :about}
    it {should respond_with :ok}
    it {should render_template :about}
  end

  describe "GET #contact: " do
    before {get :contact}
    it {should respond_with :ok}
    it {should render_template :contact}
  end
end