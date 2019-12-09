class Review < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy,
              inverse_of: :commentable
  has_many :likes, dependent: :destroy
  has_many :picture, as: :pictureable, dependent: :destroy,
             inverse_of: :pictureable
  belongs_to :user
  belongs_to :tour_detail

  validates :content, presence: true
  validates :rating, presence: true

  accepts_nested_attributes_for :picture,
                                reject_if:
                                proc{|attributes| attributes["link"].blank?}
end
