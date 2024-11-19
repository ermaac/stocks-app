class Marketplace::ShareOrder < ApplicationRecord
  extend Enumerize

  belongs_to :user, class_name: Marketplace::User.name
  belongs_to :organization
  belongs_to :modified_by, class_name: Platform::User.name, optional: true

  ORDER_TYPES = %i[buy]
  ORDER_STATES = %i[pending registered accepted rejected completed closed]

  enumerize :order_type, in: ORDER_TYPES, default: ORDER_TYPES.first
  enumerize :state, in: ORDER_STATES, default: ORDER_STATES.first, scope: :shallow, predicates: true

  scope :recent, -> { order(created_at: :desc) }
  scope :buy_orders, -> { where(order_type: "buy") }
  scope :opened, -> { where.not(state: [ :completed, :closed ]) }
end
