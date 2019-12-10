class Review < ApplicationRecord
  attr_accessor :link
  has_many :comments, as: :commentable, dependent: :destroy,
              inverse_of: :commentable
  has_many :likes, dependent: :destroy
  has_many :pictures, as: :pictureable, dependent: :destroy,
             inverse_of: :pictureable
  belongs_to :user
  belongs_to :tour_detail

  validates :content, presence: true
  validates :rating, presence: true

  after_save :save_picture

  accepts_nested_attributes_for :pictures,
                                reject_if:
                                proc{|attributes| attributes["link"].blank?}

  def save_picture
    @picture = Picture.new
    @picture.pictureable_type = "Review"
    @picture.pictureable_id = id
    @picture.link = link
    @picture.save
  end
end
