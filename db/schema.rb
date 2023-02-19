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

ActiveRecord::Schema[7.0].define(version: 2023_02_19_042830) do
  create_table "app_configs", force: :cascade do |t|
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contracts", force: :cascade do |t|
    t.string "title"
    t.string "number"
    t.integer "entity_id"
    t.integer "program_id"
    t.integer "point_of_contact_id"
    t.integer "status"
    t.integer "vendor_id"
    t.integer "contract_type"
    t.string "description"
    t.string "key_words"
    t.float "amount_dollar"
    t.integer "amount_duration"
    t.datetime "start_date"
    t.string "initial_term_amount"
    t.string "initial_term_duration"
    t.datetime "end_date"
    t.integer "end_trigger"
    t.boolean "requires_rebid", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_contracts_on_entity_id"
    t.index ["point_of_contact_id"], name: "index_contracts_on_point_of_contact_id"
    t.index ["program_id"], name: "index_contracts_on_program_id"
    t.index ["vendor_id"], name: "index_contracts_on_vendor_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "file_name"
    t.string "path"
    t.integer "contract_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_documents_on_contract_id"
  end

  create_table "entities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.integer "program_id"
    t.boolean "program_manager", default: false
    t.boolean "status", default: false
    t.integer "redirect_user_id"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vendor_reviews", force: :cascade do |t|
    t.integer "rating"
    t.string "description"
    t.integer "vendor_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_vendor_reviews_on_user_id"
    t.index ["vendor_id"], name: "index_vendor_reviews_on_vendor_id"
  end

  create_table "vendors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
