class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: [:facebook, :twitter, :google_oauth2]
  has_many :bookings, dependent: :destroy
  has_many :identities, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy,
              inverse_of: :commentable
  has_one :picture, as: :pictureable, dependent: :destroy,
          inverse_of: :pictureable
  validates :name, presence: true, length: {maximum: Settings.max_name}
  validates :email, presence: true, length: {maximum: Settings.max_email},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :phone_number, length: {maximum: Settings.max_phone_number}
  validates :password, presence: true, length: {minimum: Settings.min_password},
            allow_nil: true
  before_save :downcase_email
  enum role: {user: 1, admin: 2}

  accepts_nested_attributes_for :picture,
                                reject_if:
                                proc{|attributes| attributes["link"].blank?}
  private

  # Converts email to all lower-case.
  def downcase_email
    return if email.present?

    email.downcase
  end
end
