class Picture < ApplicationRecord
  mount_uploader :link, PictureUploader
  belongs_to :pictureable, polymorphic: true
end
