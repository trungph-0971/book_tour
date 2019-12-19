require "faker"

FactoryBot.define do
  factory :comment do |f|
    f.content {Faker::Lorem.paragraphs}
    user
  end
end
