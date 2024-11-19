FactoryBot.define do
  factory :platform_user, class: 'Platform::User' do
    association :organization
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    role { Platform::User.role.values.first }
    password { Faker::Internet.password(min_length: 8) }
    created_at { Faker::Time.backward(days: 30) }
    updated_at { Faker::Time.backward(days: 15) }
  end
end
