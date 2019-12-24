require "faker"

FactoryBot.define do
  factory :review do |f|
    f.rating {Faker::Number.between(from: 1, to: 10)}
    f.content {Faker::Lorem.paragraphs}
    user
    tour_detail
  end
end
