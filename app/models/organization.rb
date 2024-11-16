class Organization < ApplicationRecord
  has_many :share_orders, class_name: Marketplace::ShareOrder.name
end
