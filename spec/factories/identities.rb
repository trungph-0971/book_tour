require "faker"

FactoryBot.define do
  factory :identity do |f|
    f.provider {Faker::Omniauth.google[:provider]}
    f.uid {Faker::Omniauth.google[:uid]}
    user
  end
end
