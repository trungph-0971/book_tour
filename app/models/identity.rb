class Identity < ApplicationRecord
  validates :provider, presence: true
  validates :uid, presence: true
  belongs_to :user
end
