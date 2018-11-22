FactoryBot.define do
  factory :dns_record do
    ipv4_address { Faker::Internet.ip_v4_address }
    hostnames { [] }
  end
end
