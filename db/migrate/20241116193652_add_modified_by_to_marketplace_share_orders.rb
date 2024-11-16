class AddModifiedByToMarketplaceShareOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :marketplace_share_orders, :modified_by, foreign_key: { to_table: :platform_users }
  end
end
