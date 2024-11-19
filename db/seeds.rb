# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

def create_platform_user(organization, user_params = {})
  organization.users.create!(
    email: user_params.fetch(:email, Faker::Internet.unique.email),
    password: user_params.fetch(:password, Faker::Internet.password),
    first_name: user_params.fetch(:first_name, Faker::Name.first_name),
    last_name: user_params.fetch(:last_name, Faker::Name.last_name),
    role: user_params.fetch(:role, Platform::User::ROLES.first)
  )
end

def create_marketplace_user(user_params = {})
  Marketplace::User.create!(
    email: user_params.fetch(:email, Faker::Internet.unique.email),
    username: user_params.fetch(:username, Faker::Internet.username),
    password: user_params.fetch(:password, Faker::Internet.password)
  )
end

def create_organization(org_params = {})
  Organization.create!(
    name: org_params.fetch(:name, Faker::Company.unique.name),
    total_shares_amount: org_params.fetch(:total_shares_amount, Faker::Number.between(from: 10_000, to: 1_000_000)),
    available_shares_amount: org_params.fetch(:available_shares_amount, Faker::Number.between(from: 1_000, to: 10_000))
  )
end

3.times do |i|
  organization = create_organization
  create_platform_user(organization)
  create_marketplace_user
end
2.times do
  organization = create_organization(available_shares_amount: 0)
  create_platform_user(organization)
  create_marketplace_user
end

sample_organization = Organization.take
create_platform_user(sample_organization,  email: 'businessowner@test.com', password: 'password123')
create_marketplace_user(username: 'samplebuyer', password: 'password456')
