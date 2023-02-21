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

ActiveRecord::Schema[7.0].define(version: 2023_02_21_172950) do
  create_table "bvcog_configs", force: :cascade do |t|
    t.text "contracts_path"
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

  add_foreign_key "users", "users", column: "redirect_user_id"
  add_foreign_key "vendor_reviews", "users"
  add_foreign_key "vendor_reviews", "vendors"
end
