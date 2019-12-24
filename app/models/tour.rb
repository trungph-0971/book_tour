class Tour < ApplicationRecord
  belongs_to :category
  has_many :tour_details, dependent: :destroy
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :description, presence: true
  scope :not_deleted, ->{where("deleted_at IS NULL")}
  scope :deleted, ->{where("deleted_at IS NOT NULL")}

  def soft_delete
    update deleted_at: Time.zone.now
  end

  def recover
    update deleted_at: nil
  end
end
