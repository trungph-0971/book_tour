class Picture < ApplicationRecord
  belongs_to :pictureable, polymorphic: true
end
