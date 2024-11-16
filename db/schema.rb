# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_11_16_191335) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "marketplace_share_orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.decimal "price_per_share"
    t.bigint "shares_amount", null: false
    t.string "state", null: false
    t.decimal "purchased_amount"
    t.string "order_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_marketplace_share_orders_on_organization_id"
    t.index ["user_id"], name: "index_marketplace_share_orders_on_user_id"
  end

  create_table "marketplace_users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.integer "total_shares_amount", null: false
    t.integer "available_shares_amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "platform_users", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "email", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_platform_users_on_organization_id"
  end

  add_foreign_key "marketplace_share_orders", "marketplace_users", column: "user_id"
  add_foreign_key "marketplace_share_orders", "organizations"
  add_foreign_key "platform_users", "organizations"
end
