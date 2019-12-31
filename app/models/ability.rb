# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize current_user
    current_user ||= User.new
    if current_user&.admin?
      can :manage, :all
    else
      can [:index, :show, :destroy], Booking,
          user_id: current_user.id
      can [:new, :create, :pay, :hook], Booking
      can [:new, :create], [Review, Comment, User]
      can :index, Review
      can :destroy, [Review, Comment], user_id: current_user.id
      can :create, Like
      can :destroy, Like, user_id: current_user.id
      can [:edit, :update], User, user_id: current_user.id
      can [:index, :show], [Category, TourDetail]
    end
  end
end
