require "faker"

FactoryBot.define do
  factory :booking do |f|
    f.people_number {Faker::Number.between(from: 1, to: 10)}
    user
    tour_detail
  end
end
