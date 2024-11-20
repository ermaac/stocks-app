class Marketplace::PurchasedShare < ApplicationRecord
  belongs_to :user, class_name: Marketplace::User.name
  belongs_to :organization
  belongs_to :share_order, class_name: Marketplace::ShareOrder.name
end
