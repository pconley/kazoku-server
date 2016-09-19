# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160919131336) do

  create_table "families", force: :cascade do |t|
    t.string   "name"
    t.string   "key"
    t.string   "husb_key"
    t.string   "wife_key"
    t.integer  "wife_id"
    t.integer  "husband_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "search_text"
  end

  create_table "memberships", force: :cascade do |t|
    t.string  "role"
    t.integer "person_id"
    t.integer "family_id"
    t.index ["family_id"], name: "index_memberships_on_family_id"
    t.index ["person_id"], name: "index_memberships_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "gender"
    t.string   "birth_place"
    t.string   "death_place"
    t.date     "buried_date"
    t.string   "buried_date_string"
    t.string   "buried_place"
    t.string   "key"
    t.string   "famc_key"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "birth_year"
    t.integer  "birth_month"
    t.integer  "birth_day"
    t.integer  "death_year"
    t.integer  "death_month"
    t.integer  "death_day"
    t.text     "rawtext"
    t.integer  "family_id"
    t.string   "fams_keys"
    t.text     "search_text"
    t.string   "middle_name"
    t.string   "common_name"
    t.index ["family_id"], name: "index_people_on_family_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "sub"
    t.datetime "first_access_at"
    t.datetime "last_access_at"
    t.integer  "access_count",           default: 0,  null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["sub"], name: "index_users_on_sub", unique: true
  end

  create_table "widgets", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "weight"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
