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

ActiveRecord::Schema.define(version: 20160704122040) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "flock"
    t.integer  "user_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "location"
    t.integer  "payment"
    t.boolean  "on_wall"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

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

  create_table "availabilities", force: :cascade do |t|
    t.boolean  "monday_morning"
    t.boolean  "monday_midday"
    t.boolean  "monday_evening"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.boolean  "tuesday_morning"
    t.boolean  "tuesday_midday"
    t.boolean  "tuesday_evening"
    t.boolean  "wednesday_morning"
    t.boolean  "wednesday_midday"
    t.boolean  "wednesday_evening"
    t.boolean  "thursday_morning"
    t.boolean  "thursday_midday"
    t.boolean  "thursday_evening"
    t.boolean  "friday_morning"
    t.boolean  "friday_midday"
    t.boolean  "friday_evening"
    t.boolean  "saturday_morning"
    t.boolean  "saturday_midday"
    t.boolean  "saturday_evening"
    t.boolean  "sunday_morning"
    t.boolean  "sunday_midday"
    t.boolean  "sunday_evening"
  end

  add_index "availabilities", ["user_id"], name: "index_availabilities_on_user_id", using: :btree

  create_table "blogs", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "content"
    t.integer  "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "blogs", ["user_id"], name: "index_blogs_on_user_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.string   "postalcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "connections", force: :cascade do |t|
    t.integer  "user_1_id"
    t.integer  "user_2_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "ISO"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dogs", force: :cascade do |t|
    t.integer  "animal_id"
    t.string   "breed"
    t.integer  "maximum_walking_time"
    t.string   "remarks"
    t.boolean  "other_dogs"
    t.boolean  "cats"
    t.boolean  "children"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "dogs", ["animal_id"], name: "index_dogs_on_animal_id", using: :btree

  create_table "experiences", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flocks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "flock_id"
    t.integer  "animal_id"
    t.integer  "planning_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "flocks", ["animal_id"], name: "index_flocks_on_animal_id", using: :btree
  add_index "flocks", ["flock_id"], name: "index_flocks_on_flock_id", using: :btree
  add_index "flocks", ["planning_id"], name: "index_flocks_on_planning_id", using: :btree
  add_index "flocks", ["user_id"], name: "index_flocks_on_user_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "desription"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "groups", ["user_id"], name: "index_groups_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.text     "content"
    t.boolean  "is_read"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "messages", ["from_user_id"], name: "index_messages_on_from_user_id", using: :btree
  add_index "messages", ["to_user_id"], name: "index_messages_on_to_user_id", using: :btree

  create_table "pictures", force: :cascade do |t|
    t.string   "name"
    t.string   "comment"
    t.integer  "tag"
    t.string   "url"
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

  create_table "preferences", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_group_relations", force: :cascade do |t|
    t.integer  "group"
    t.integer  "user_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_group_relations", ["user_id"], name: "index_user_group_relations_on_user_id", using: :btree

  create_table "user_relation_animals", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "animal_id"
    t.boolean  "is_owner"
    t.boolean  "can_add_to_flock"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "user_relation_animals", ["animal_id"], name: "index_user_relation_animals_on_animal_id", using: :btree
  add_index "user_relation_animals", ["user_id"], name: "index_user_relation_animals_on_user_id", using: :btree

  create_table "user_relations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.date     "start_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_relations", ["user_id"], name: "index_user_relations_on_user_id", using: :btree

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
    t.boolean  "is_premium"
    t.string   "pricing"
    t.boolean  "professional"
    t.boolean  "is_walker"
    t.integer  "preference_id"
    t.integer  "experience_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["experience_id"], name: "index_users_on_experience_id", using: :btree
  add_index "users", ["preference_id"], name: "index_users_on_preference_id", using: :btree

  create_table "wallposts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "picture"
    t.integer  "blog_id"
    t.integer  "route"
    t.integer  "tag"
    t.string   "url"
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "wallposts", ["blog_id"], name: "index_wallposts_on_blog_id", using: :btree
  add_index "wallposts", ["user_id"], name: "index_wallposts_on_user_id", using: :btree

  add_foreign_key "activities", "users"
  add_foreign_key "addresses", "cities"
  add_foreign_key "addresses", "countries"
  add_foreign_key "addresses", "users"
  add_foreign_key "animals", "users"
  add_foreign_key "availabilities", "users"
  add_foreign_key "blogs", "users"
  add_foreign_key "dogs", "animals"
  add_foreign_key "flocks", "animals"
  add_foreign_key "flocks", "flocks"
  add_foreign_key "flocks", "plannings"
  add_foreign_key "flocks", "users"
  add_foreign_key "groups", "users"
  add_foreign_key "plannings", "animals"
  add_foreign_key "user_group_relations", "users"
  add_foreign_key "user_relation_animals", "animals"
  add_foreign_key "user_relation_animals", "users"
  add_foreign_key "user_relations", "users"
  add_foreign_key "users", "experiences"
  add_foreign_key "users", "preferences"
  add_foreign_key "wallposts", "blogs"
  add_foreign_key "wallposts", "users"
end
