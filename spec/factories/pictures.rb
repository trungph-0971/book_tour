require "faker"

FactoryBot.define do
  factory :picture do |f|
    f.link {Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/images/123.jpg'), 'image/jpeg')}
  end
end
