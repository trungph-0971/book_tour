module Pictureable
  extend ActiveSupport::Concern
  def save_picture type
    picture = Picture.new
    picture.pictureable_type = type
    picture.pictureable_id = id
    picture.link = link
    picture.save
  end
end
