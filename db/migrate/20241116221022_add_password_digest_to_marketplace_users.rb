class AddPasswordDigestToMarketplaceUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :marketplace_users, :password_digest, :string
  end
end
