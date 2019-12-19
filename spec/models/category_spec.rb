require "rails_helper"

RSpec.describe Category, type: :model do
  let(:category) {FactoryGirl.create :category}
  subject {category}

  #Test Category model validations
  context ".validate :" do
    before {category.save}

    it "is valid with valid attributes" do
      expect(category).to be_valid
    end

    it "is not valid without a name" do
      category.name = ""
      expect(category).to_not be_valid
    end

    it "is not valid with existed name" do
      clone = category.dup
      clone.name = category.name
      clone.save
      expect(clone.errors.full_messages).to include("Name has already been taken")
    end
  end

  #Test Category model associations
  context ".associations :" do
    it "has many tours" do
      assc = Category.reflect_on_association :tours
      expect(assc.macro).to eq :has_many
    end
  end
end
