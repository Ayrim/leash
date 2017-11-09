# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160318182653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "street"
    t.string   "number"
    t.string   "numberAddition"
    t.integer  "user_id"
    t.integer  "city_id"
    t.integer  "country_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "addresses", ["city_id"], name: "index_addresses_on_city_id", using: :btree
  add_index "addresses", ["country_id"], name: "index_addresses_on_country_id", using: :btree
  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "animals", force: :cascade do |t|
    t.string   "name"
    t.date     "birthdate"
    t.string   "breed"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "animals", ["user_id"], name: "index_animals_on_user_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.string   "postalcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "ISO"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plannings", force: :cascade do |t|
    t.date     "startDate"
    t.date     "endDate"
    t.string   "schedule"
    t.integer  "animal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "plannings", ["animal_id"], name: "index_plannings_on_animal_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "firstname",                         null: false
    t.string   "lastname"
    t.string   "email",                             null: false
    t.string   "crypted_password",                  null: false
    t.string   "salt",                              null: false
    t.string   "language"
    t.string   "nationality"
    t.date     "birthdate"
    t.string   "phone"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "description"
    t.string   "profile_picture"
    t.string   "banner_picture"
    t.integer  "number_of_walks"
    t.string   "walking_region"
    t.string   "skills"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "addresses", "cities"
  add_foreign_key "addresses", "countries"
  add_foreign_key "addresses", "users"
  add_foreign_key "animals", "users"
  add_foreign_key "plannings", "animals"
end
