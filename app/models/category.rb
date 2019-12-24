class Category < ApplicationRecord
  has_many :tours, dependent: :destroy
  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
