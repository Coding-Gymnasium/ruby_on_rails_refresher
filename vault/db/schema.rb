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

ActiveRecord::Schema[8.1].define(version: 2026_08_31_223255) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bank_accounts", force: :cascade do |t|
    t.decimal "balance", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.bigint "customer_id", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_bank_accounts_on_customer_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount"
    t.bigint "bank_account_id", null: false
    t.datetime "created_at", null: false
    t.string "transaction_type"
    t.datetime "updated_at", null: false
    t.index ["bank_account_id"], name: "index_transactions_on_bank_account_id"
  end

  add_foreign_key "bank_accounts", "customers"
  add_foreign_key "transactions", "bank_accounts"
end
