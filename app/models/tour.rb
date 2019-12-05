class Tour < ApplicationRecord
  belongs_to :category
  has_many :tour_details, dependent: :destroy
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :description, presence: true
end
