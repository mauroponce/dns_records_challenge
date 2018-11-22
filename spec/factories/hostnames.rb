FactoryBot.define do
  factory :hostname do
    name { Faker::Internet.domain_name }
  end
end
