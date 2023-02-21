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

ActiveRecord::Schema[7.0].define(version: 2023_02_21_174315) do
  create_table "bvcog_configs", force: :cascade do |t|
    t.text "contracts_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contract_documents", force: :cascade do |t|
    t.text "file_name"
    t.text "full_path"
    t.integer "contract_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_contract_documents_on_contract_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.text "title"
    t.text "number"
    t.integer "entity_id", null: false
    t.integer "program_id", null: false
    t.integer "point_of_contact_id", null: false
    t.integer "vendor_id", null: false
    t.text "decription"
    t.text "key_words"
    t.float "amount_dollar"
    t.datetime "starts_at"
    t.integer "initial_term_amount"
    t.datetime "ends_at"
    t.boolean "requires_rebid"
    t.integer "contract_type"
    t.integer "contract_status"
    t.integer "amount_duration"
    t.integer "initial_term_duration"
    t.integer "end_trigger"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_contracts_on_entity_id"
    t.index ["point_of_contact_id"], name: "index_contracts_on_point_of_contact_id"
    t.index ["program_id"], name: "index_contracts_on_program_id"
    t.index ["vendor_id"], name: "index_contracts_on_vendor_id"
  end

  create_table "entities", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "programs", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.text "first_name"
    t.text "last_name"
    t.text "email"
    t.boolean "is_program_manager"
    t.boolean "is_active"
    t.integer "redirect_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["redirect_user_id"], name: "index_users_on_redirect_user_id"
  end

  create_table "vendor_reviews", force: :cascade do |t|
    t.float "rating"
    t.text "description"
    t.integer "user_id", null: false
    t.integer "vendor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_vendor_reviews_on_user_id"
    t.index ["vendor_id"], name: "index_vendor_reviews_on_vendor_id"
  end

  create_table "vendors", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "contract_documents", "contracts"
  add_foreign_key "contracts", "entities"
  add_foreign_key "contracts", "programs"
  add_foreign_key "contracts", "users", column: "point_of_contact_id"
  add_foreign_key "contracts", "vendors"
  add_foreign_key "users", "users", column: "redirect_user_id"
  add_foreign_key "vendor_reviews", "users"
  add_foreign_key "vendor_reviews", "vendors"
end
