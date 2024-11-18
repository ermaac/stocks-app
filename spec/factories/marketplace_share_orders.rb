FactoryBot.define do
  factory :marketplace_share_order, class: 'Marketplace::ShareOrder' do
    association :user, factory: :marketplace_user
    association :organization
    price_per_share { Faker::Commerce.price(range: 1..100) }
    shares_amount { Faker::Number.between(from: 1, to: 1000) }
    state { Marketplace::ShareOrder.state.default_value }
    purchased_amount { Faker::Commerce.price(range: 0..10_000) }
    order_type {  Marketplace::ShareOrder.order_type.default_value }
    created_at { Faker::Time.backward(days: 30) }
    updated_at { Faker::Time.backward(days: 15) }
    association :modified_by, factory: :platform_user
  end
end
