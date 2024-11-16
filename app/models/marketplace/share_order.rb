class Marketplace::ShareOrder < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :organization

  ORDER_TYPES = %i[buy]
  ORDER_STATES = %i[created]

  enumerize :order_type, in: ORDER_TYPES, default: ORDER_TYPES.first
  enumerize :state, in: ORDER_STATES, default: ORDER_STATES.first
end
