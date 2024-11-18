FactoryBot.define do
  factory :marketplace_user, class: 'Marketplace::User' do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password_digest { Faker::Internet.password(min_length: 8) }
    created_at { Faker::Time.backward(days: 30) }
    updated_at { Faker::Time.backward(days: 15) }
  end
end
