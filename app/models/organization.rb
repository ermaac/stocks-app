class Organization < ApplicationRecord
  has_many :share_orders, class_name: Marketplace::ShareOrder.name
  has_many :users, class_name: Platform::User.name
end
