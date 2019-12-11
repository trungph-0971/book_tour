class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  devise :omniauthable,
         omniauth_providers: [:facebook, :twitter, :google_oauth2]
  has_many :bookings, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :bank_accounts, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy,
              inverse_of: :commentable
  has_one :picture, as: :pictureable, dependent: :destroy,
          inverse_of: :pictureable
  has_secure_password
  attr_accessor :remember_token, :activation_token, :reset_token
  validates :name, presence: true, length: {maximum: Settings.max_name}
  validates :email, presence: true, length: {maximum: Settings.max_email},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :phone_number, length: {maximum: Settings.max_phone_number}
  validates :password, presence: true, length: {minimum: Settings.min_password},
            allow_nil: true
  before_create :create_activation_digest
  before_save :downcase_email
  enum role: {user: 1, admin: 2}

  accepts_nested_attributes_for :picture,
                                reject_if:
                                proc{|attributes| attributes["link"].blank?}

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
  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password? token
  end

  # Forgets a user.
  def forget
    update remember_digest: nil
  end

  # Activates an account.
  def activate
    update activated: true
    update activated_at: Time.zone.now
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update reset_digest: User.digest(reset_token)
    update reset_sent_at: Time.zone.now
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  # Converts email to all lower-case.
  def downcase_email
    return if email.present?

    email.downcase
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
