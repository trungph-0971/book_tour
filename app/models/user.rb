class User < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :banks, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy,
              inverse_of: :commentable
  has_one :picture, as: :pictureable, dependent: :destroy,
            inverse_of: :pictureable
  enum role: {user: 1, admin: 2}
end
