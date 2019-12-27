require "rails_helper"

RSpec.describe "users/edit.html.erb", type: :view do
  let(:user) {FactoryBot.create :user}

  context "render form" do
    before do
      assign(:user, User.new)
      render
    end

    it "will render edit user information fields" do
      expect(rendered).to have_field("user[name]")
      expect(rendered).to have_field("user[email]")
      expect(rendered).to have_field("user[phone_number]")
      expect(rendered).to have_field("user[password]")
      expect(rendered).to have_field("user[password_confirmation]")
    end
  end

  context "when update failed" do
    before do
      user[:name] = ""
      user.save
      assign(:user, user)
    end

    it "return error message" do
      render
      expect(rendered).to have_content("Name can't be blank")
    end
  end
end