class Marketplace::ShareOrder < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :organization

  ORDER_TYPES = %i[buy]
  ORDER_STATES = %i[created completed]

  enumerize :order_type, in: ORDER_TYPES, default: ORDER_TYPES.first
  enumerize :state, in: ORDER_STATES, default: ORDER_STATES.first

  scope :completed, -> { where(state: :completed) }
  scope :recent, -> { order(created_at: :desc) }
  scope :buy_orders, -> { where(order_type: :buy) }
end
