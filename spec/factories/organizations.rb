FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    total_shares_amount { Faker::Number.between(from: 10_000, to: 1_000_000) }
    available_shares_amount { Faker::Number.between(from: 1_000, to: 10_000) }
    blocked_shares_amount { Faker::Number.between(from: 0, to: 5_000) }
    created_at { Faker::Time.backward(days: 30) }
    updated_at { Faker::Time.backward(days: 15) }
  end
end
