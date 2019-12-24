require "rails_helper"

RSpec.describe Comment, type: :model do
  let!(:user) {FactoryBot.create :user}
  subject {user}

  let!(:review) {FactoryBot.create :review}
  subject {review}
  
  let!(:comment) {FactoryBot.create :comment,
                user: user, commentable_type: Review, commentable_id: review.id}
  subject {comment}

  context ".validate :" do
    before {comment.save}

    it "is valid with valid attributes" do
      expect(comment).to be_valid
    end

    it "is not valid without content" do
      comment.content = ""
      expect(comment).to_not be_valid
    end
  end

  context ".associations :" do
    it "belongs to review" do
      commentable = Review.new
      comment = Comment.new
      commentable.comments << comment
      expect(comment.commentable).to be commentable
    end

    it "belongs to another comment" do
        commentable = Comment.new
        comment = Comment.new
        commentable.comments << comment
        expect(comment.commentable).to be commentable
    end
  end
end
