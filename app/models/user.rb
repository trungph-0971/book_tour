class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  devise :omniauthable,
         omniauth_providers: [:facebook, :twitter, :google_oauth2]
  has_many :bookings, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :banks, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy,
              inverse_of: :commentable
  has_one :picture, as: :pictureable, dependent: :destroy,
            inverse_of: :pictureable
  has_secure_password
  attr_accessor :remember_token
  validates :name, presence: true, length: {maximum: Settings.max_name}
  validates :email, presence: true, length: {maximum: Settings.max_email},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :phone_number, presence: true,
                           length: {maximum: Settings.max_phone_number}
  validates :password, presence: true, length: {minimum: Settings.min_password}
  before_save{email.downcase!}
  enum role: {user: 1, admin: 2}

  class << self
    # Returns the hash digest of the given string.
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  # Returns true if the given token matches the digest.
  def authenticated? remember_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  # Forgets a user.
  def forget
    update remember_digest: nil
  end
end
