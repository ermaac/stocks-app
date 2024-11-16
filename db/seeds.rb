# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
3.times do
  total_shares_amount = (rand(5) + 1) * 100_000_000
  Organization.create(
    name: Faker::Company.unique.name,
    total_shares_amount: total_shares_amount,
    available_shares_amount: rand * total_shares_amount
  )
end
2.times do
  total_shares_amount = (rand(5) + 1) * 100_000_000
  Organization.create(
    name: Faker::Company.unique.name,
    total_shares_amount: total_shares_amount,
    available_shares_amount: 0
  )
end
