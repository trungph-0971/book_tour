require "rails_helper"

RSpec.describe Identity, type: :model do
  let!(:user) {FactoryBot.create :user}
  subject {user}

  let!(:identity) {FactoryBot.create :identity, user: user}
  subject {identity}

  context ".validate :" do
    before {identity.save}

    it "is valid with valid attributes" do
      expect(identity).to be_valid
    end

    it "is not valid without a provider" do
      identity.provider = ""
      expect(identity).to_not be_valid
    end

    it "is not valid without a uid" do
        identity.uid = ""
        expect(identity).to_not be_valid
    end
  end

  context ".associations :" do
    it "belongs to user" do
      user = User.new
      identity = Identity.new
      user.identities << identity
      expect(identity.user).to be user
    end
  end
end
