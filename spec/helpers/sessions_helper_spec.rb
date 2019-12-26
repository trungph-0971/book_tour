require "rails_helper"

RSpec.describe SessionsHelper, type: :helper do
  let(:user) {FactoryBot.create :user}

  describe " #log_in" do
    before {log_in user}
    it "return user id of session as logged in user's id" do
      expect(session[:user_id]).to eq user.id
    end
  end

  describe " #remember" do
    before {remember user}
    it "assign user id in cookie as user's id" do
      expect(cookies.signed[:user_id]).to eq user.id
    end

    it "assign rememeber token in cookie as user's remember token" do
      expect(cookies[:remember_token]).to eq user.remember_token
    end
  end

  describe " #forget" do
    before {forget user}
    it "delete user id in cookie" do
      expect(cookies[:user_id]).to be_nil
    end

    it "delete remember token in cookie" do
      expect(cookies[:remember_token]).to be_nil
    end
  end

  describe " #log_out" do
    before {log_in user}
    context "user log out" do
      before{log_out}
      it "delete user_id of session" do
        expect(session[:user_id]).to be_nil
      end
    end
  end

  describe " #current_user?" do
    before {log_in user}
    it "returns true if the given user is the current user" do
      expect(helper.current_user?(user)).to be_truthy
    end
  end

  describe " #current_user" do
    before {helper.remember user}
    it "returns the right user when session is nil" do
      expect(helper.current_user).to eq user
    end

    it "returns nil when remember digest is wrong" do
      user.update_attribute :remember_digest, User.digest(User.new_token)
      expect(helper.current_user).to be_nil
    end
  end

  describe " #logged_in?" do
    before {log_in user}

    it "return true if the user is logged in" do
      expect(helper.logged_in?).to be_truthy
    end
    context "user is not logged in" do
      before {log_out}
      it "return false if the user is not logged in" do
        expect(helper.logged_in?).to be_falsey
      end
    end
  end
end