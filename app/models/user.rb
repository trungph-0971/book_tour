class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  has_many :bookings, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :banks, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy,
              inverse_of: :commentable
  has_one :picture, as: :pictureable, dependent: :destroy,
            inverse_of: :pictureable
  has_secure_password
  validates :name, presence: true, length: {maximum: Settings.max_name}
  validates :email, presence: true, length: {maximum: Settings.max_email},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :phone_number, presence: true,
                           length: {maximum: Settings.max_phone_number}
  validates :password, presence: true, length: {minimum: Settings.min_password}
  before_save{email.downcase!}
  enum role: {user: 1, admin: 2}
end
