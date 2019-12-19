require "rails_helper"

RSpec.describe Tour, type: :model do
  let(:category) {FactoryGirl.create :category}
  subject {category}
  let(:tour) {FactoryGirl.create :tour, category: category}
  subject {tour}

  #Test Tour model validations
  context ".validate :" do
    before {tour.save}

    it "is valid with valid attributes" do
      expect(tour).to be_valid
    end

    it "is not valid without a name" do
      tour.name = ""
      expect(tour).to_not be_valid
    end

    it "is not valid with a duplicate name" do
      clone = tour.dup
      clone.name = tour.name
      clone.save
      expect(clone.errors.full_messages).to include("Name has already been taken")
    end

    it "is not valid without description" do
      tour.description = ""
      expect(tour).to_not be_valid
    end
  end

  #Test Tour model associations
  context ".associations :" do
    it "has many tour details" do
      assc = Tour.reflect_on_association :tour_details
      expect(assc.macro).to eq :has_many
    end

    it "belongs to a category" do
      tour = Tour.new
      category = Category.new
      category.tours << tour
      expect(tour.category).to be category
    end
  end

  #Test Tour model body methods
  describe "#soft_delete" do
    before do
      tour.soft_delete
    end

    it "set deleted_at field as deletion time" do
      expect(tour.deleted_at.class).to be(ActiveSupport::TimeWithZone)
    end
  end

  describe "#recover" do
    before do
      tour.soft_delete
      tour.recover
    end

    it "set deleted_at field as nil" do
      expect(tour.deleted_at).to be_nil
    end
  end
end
