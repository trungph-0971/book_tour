class PictureUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
  process resize_to_limit: [400, 400]

  version :standard do
    process resize_to_fill: [100, 150, :north]
  end

  version :thumbnail do
    resize_to_fit(50, 50)
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
