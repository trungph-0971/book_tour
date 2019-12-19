require "faker"

FactoryBot.define do
  factory :tour do |f|
    f.name {Faker::Name.name}
    f.description {Faker::Lorem.paragraphs}
    category
  end
end
