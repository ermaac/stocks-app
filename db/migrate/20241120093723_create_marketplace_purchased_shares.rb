class CreateMarketplacePurchasedShares < ActiveRecord::Migration[8.0]
  def change
    create_table :marketplace_purchased_shares do |t|
      t.references :user, null: false, foreign_key: { to_table: :marketplace_users }
      t.references :organization, null: false, foreign_key: true
      t.decimal :amount, null: false
      t.references :share_order, null: false, foreign_key: { to_table: :marketplace_share_orders }

      t.timestamps
    end
  end
end
