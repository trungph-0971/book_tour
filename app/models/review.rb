class Review < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy,
              inverse_of: :commentable
  has_many :likes, dependent: :destroy
  has_many :picture, as: :pictureable, dependent: :destroy,
             inverse_of: :pictureable
  belongs_to :user
  belongs_to :tour_detail
end
