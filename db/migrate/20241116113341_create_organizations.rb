class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.bigint :total_shares_amount, null: false
      t.bigint :available_shares_amount, null: false

      t.timestamps
    end
  end
end
