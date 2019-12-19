require "faker"

FactoryBot.define do
  factory :revenue do |f|
    f.revenue {Faker::Number.decimal(l_digits: 2)}
    tour_detail
  end
end
