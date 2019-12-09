class Picture < ApplicationRecord
  belongs_to :pictureable, polymorphic: true
  mount_uploader :link, ImageUploader
end
