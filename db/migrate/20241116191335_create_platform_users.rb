class CreatePlatformUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :platform_users do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :email, null: false
      t.string :first_name, null: false, default: ''
      t.string :last_name, null: false, default: ''
      t.string :role, null: false

      t.timestamps
    end
  end
end
