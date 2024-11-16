class CreateMarketplaceShareOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :marketplace_share_orders do |t|
      t.references :user, null: false, foreign_key: { to_table: :marketplace_users }
      t.references :organization, null: false, foreign_key: true
      t.decimal :price_per_share
      t.bigint :shares_amount, null: false
      t.string :state, null: false
      t.decimal :purchased_amount
      t.string :order_type, null: false

      t.timestamps
    end
  end
end
