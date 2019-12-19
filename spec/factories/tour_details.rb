require "faker"

FactoryGirl.define do
  factory :tour_detail do |f|
    f.start_time {Faker::Date.in_date_period(year: 2019, month: 2)}
    f.end_time {Faker::Date.in_date_period(year: 2019, month: 3)}
    f.price {Faker::Number.decimal(l_digits: 2)}
    f.people_number {Faker::Number.number(digits: 2)}
    tour
  end
end
