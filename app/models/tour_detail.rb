class TourDetail < ApplicationRecord
  include Pictureable
  attr_accessor :link
  belongs_to :tour
  has_many :reviews, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_one :revenue, dependent: :destroy
  has_many :pictures, as: :pictureable, dependent: :destroy,
            inverse_of: :pictureable
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :price, presence: true
  validates :people_number, presence: true
  validate :end_time_after_start_time?
  after_save :add_picture
  scope :not_deleted, ->{where("deleted_at IS NULL")}
  scope :deleted, ->{where("deleted_at IS NOT NULL")}
  scope :available, ->{where("people_number > 0")}
  scope :top3, ->{where("people_number > 0 AND deleted_at IS NULL").limit(3)}

  accepts_nested_attributes_for :pictures,
                                reject_if:
                                proc{|attributes| attributes["link"].blank?}

  def self.search term
    if term
      joins(:tour).where("tours.name LIKE ?", "%#{term}%")
    else
      includes(:tour).all
    end
  end

  def soft_delete
    update deleted_at: Time.zone.now
  end

  def recover
    update deleted_at: nil
  end

  def add_picture
    save_picture "TourDetail"
  end

  private

  def end_time_after_start_time?
    return unless end_time? && start_time?

    return unless end_time < start_time

    errors.add :end_time, "must be after start date"
  end
end
