class LikesController < ApplicationController
  before_action :find_review
  before_action :find_like, only: :destroy

  def create
    if already_liked?
      flash.now[:notice] = t ".like_more"
    else
      @review.likes.create user_id: current_user.id
    end
    respond_to do |format|
      format.html{redirect_back fallback_location: @tour_detail}
      format.js
    end
  end

  def destroy
    if !already_liked?
      flash.now[:notice] = t ".cannot_unlike"
    else
      @like.destroy
    end
    respond_to do |format|
      format.html{redirect_back fallback_location: @tour_detail}
      format.js
    end
  end

  private
  def find_review
    @review = Review.find params[:review_id]
  end

  def find_like
    @like = @review.likes.find params[:id]
  end

  def already_liked?
    Like.where(user_id: current_user.id, review_id:
    params[:review_id]).exists?
  end
end
