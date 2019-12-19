class Picture < ApplicationRecord
  mount_uploader :link, PictureUploader
  validates :link, presence: true
  belongs_to :pictureable, polymorphic: true
end
