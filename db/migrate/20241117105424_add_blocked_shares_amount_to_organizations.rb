class AddBlockedSharesAmountToOrganizations < ActiveRecord::Migration[8.0]
  def change
    add_column :organizations, :blocked_shares_amount, :bigint, null: false, default: 0
  end
end
