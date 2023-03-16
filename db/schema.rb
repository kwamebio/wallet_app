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

ActiveRecord::Schema[7.0].define(version: 2023_03_15_173538) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_accounts", force: :cascade do |t|
    t.string "account_number", null: false
    t.string "bank_name", null: false
    t.string "bank_code", null: false
    t.string "account_name", null: false
    t.string "recipient_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_number", "bank_code"], name: "index_bank_accounts_on_account_number_and_bank_code", unique: true
  end

  create_table "debit_cards", force: :cascade do |t|
    t.string "authorization_code", null: false
    t.string "last4", null: false
    t.string "exp_month", null: false
    t.string "exp_year", null: false
    t.string "card_type", null: false
    t.string "bank", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_debit_cards_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.float "amount", null: false
    t.integer "txn_type", limit: 2, null: false
    t.integer "status", limit: 2, null: false
    t.bigint "source_id", null: false
    t.string "source_type", null: false
    t.bigint "destination_id", null: false
    t.string "destination_type", null: false
    t.string "txn_ref", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["destination_id", "destination_type"], name: "index_transactions_on_destination_id_and_destination_type"
    t.index ["source_id", "source_type"], name: "index_transactions_on_source_id_and_source_type"
    t.index ["txn_ref"], name: "index_transactions_on_txn_ref", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "auth_token"
    t.string "dob"
    t.string "address"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "settled_balance", default: 0
    t.integer "status", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

end
