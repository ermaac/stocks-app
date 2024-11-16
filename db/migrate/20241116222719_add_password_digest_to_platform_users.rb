class AddPasswordDigestToPlatformUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :platform_users, :password_digest, :string
  end
end
