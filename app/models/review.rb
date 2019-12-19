class Review < ApplicationRecord
  include Pictureable
  attr_accessor :link
  has_many :comments, as: :commentable, dependent: :destroy,
              inverse_of: :commentable
  has_many :likes, dependent: :destroy
  has_many :pictures, as: :pictureable, dependent: :destroy,
             inverse_of: :pictureable
  belongs_to :user
  belongs_to :tour_detail

  validates :content, presence: true
  validates :rating, presence: true,
                     numericality: {greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 10}

  after_save :add_picture

  accepts_nested_attributes_for :pictures,
                                reject_if:
                                proc{|attributes| attributes["link"].blank?}

  def add_picture
    save_picture "Review"
  end
end
