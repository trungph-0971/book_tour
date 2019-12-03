class Tour < ApplicationRecord
  belongs_to :category
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :description, presence: true
end
