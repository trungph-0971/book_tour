class Category < ApplicationRecord
  has_many :tours, dependent: :destroy
end
