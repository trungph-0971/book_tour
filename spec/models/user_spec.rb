require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) {FactoryGirl.create :user}
  subject {user}

  #Test User model validations
  context ".validate :" do
    before {user.save}

    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is not valid without a name" do
      user.name = ""
      expect(user).to_not be_valid
    end

    it "is valid with a name has 50 or less letters" do
      expect(user).to be_valid
    end

    it "is not valid with a name has more than 50 letters" do
      user.name = "a"*100
      expect(user).to_not be_valid
    end

    it "is not valid without an email" do
      user.email = ""
      expect(user).to_not be_valid
    end

    it "is not valid without a valid email" do
      user.email = "skrt£sun-asterisk.com"
      expect(user).to_not be_valid
    end

    it "is not valid with duplicate email" do
      clone = user.dup
      clone.email = user.email
      clone.save
      expect(clone.errors.full_messages).to include("Email has already been taken")
    end

    it "is not valid without a password" do
      user.password = nil
      expect(user).to_not be_valid
    end

    it "is valid with a phone number has more than 11 digits" do
      user.phone_number = "9"*11
      expect(user).to be_valid
    end

    it "is not valid with a phone number has more than 11 digits" do
      user.phone_number = "9"*12
      expect(user).to_not be_valid
    end
  end

  #Test User model associations
  context ".associations :" do
    it "has many bookings" do
      assc = User.reflect_on_association :bookings
      expect(assc.macro).to eq :has_many
    end

    it "has many reviews" do
      assc = User.reflect_on_association :reviews
      expect(assc.macro).to eq :has_many
    end

    it "has many identities" do
      assc = User.reflect_on_association :identities
      expect(assc.macro).to eq :has_many
    end

    it "has many likes" do
      assc = User.reflect_on_association :likes
      expect(assc.macro).to eq :has_many
    end

    it "has many comments" do
      assc = User.reflect_on_association :comments
      expect(assc.macro).to eq :has_many
    end
  end

  #Test User model body methods
  describe "#downcase_email" do
    before do
      user.email = "TRUNGPHAN@outlook.com"
      user.save
    end
    it "return email downcase before saving to database" do
      expect(user.email).to eq "trungphan@outlook.com"
    end
  end

  describe "#create activation digest" do
    context "when client create an account" do
      it "return activation token" do
        expect(user.activation_token.class).to be(String)
      end

      it "return activation digest" do
        expect(user.activation_digest.class).to be(String)
      end
    end
  end

  describe "#remember" do
    context "when remember is called" do
      before do
        user.remember
      end

      it "return a remember token" do
        expect(user.remember_token.class).to be(String)
      end

      it "return a remember digest" do
        expect(user.remember_digest.class).to be(String)
      end
    end
  end

  describe "#forget" do
    context "when user log out" do
      before do
        user.forget
      end

      it "set remember_digest as nil" do
        expect(user.remember_digest).to be_nil
      end
    end
  end

  describe "#activate" do
    context "when user activate their account" do
      before do
        user.activate
      end

      it "set activated as true" do
        expect(user.activated).to be_truthy
      end

      it "set activated_at is current time at the activated moment" do
        expect(user.activated_at.class).to be(ActiveSupport::TimeWithZone)
      end
    end
  end

end
