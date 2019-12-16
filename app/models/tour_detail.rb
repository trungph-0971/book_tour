class TourDetail < ApplicationRecord
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
  after_save :save_picture
  scope :not_deleted, ->{where("deleted_at IS NULL")}
  scope :deleted, ->{where("deleted_at IS NOT NULL")}
  scope :available, ->{where("people_number > 0")}

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

  def save_picture
    @picture = Picture.new
    @picture.pictureable_type = "TourDetail"
    @picture.pictureable_id = id
    @picture.link = link
    @picture.save
  end

  private

  def end_time_after_start_time?
    return unless end_time? && start_time?

    return unless end_time < start_time

    errors.add :end_time, "must be after start date"
  end
end
