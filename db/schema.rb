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

ActiveRecord::Schema.define(version: 20170112182140) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer "flock"
    t.bigint "user_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "location"
    t.integer "payment"
    t.boolean "on_wall"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "number"
    t.string "numberAddition"
    t.float "latitude"
    t.float "longitude"
    t.bigint "user_id"
    t.bigint "city_id"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_addresses_on_city_id"
    t.index ["country_id"], name: "index_addresses_on_country_id"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "animals", force: :cascade do |t|
    t.string "name"
    t.date "birthdate"
    t.string "breed"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_animals_on_user_id"
  end

  create_table "api_keys", force: :cascade do |t|
    t.bigint "user_id"
    t.string "access_token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "availabilities", force: :cascade do |t|
    t.boolean "monday_morning"
    t.boolean "monday_midday"
    t.boolean "monday_evening"
    t.boolean "tuesday_morning"
    t.boolean "tuesday_midday"
    t.boolean "tuesday_evening"
    t.boolean "wednesday_morning"
    t.boolean "wednesday_midday"
    t.boolean "wednesday_evening"
    t.boolean "thursday_morning"
    t.boolean "thursday_midday"
    t.boolean "thursday_evening"
    t.boolean "friday_morning"
    t.boolean "friday_midday"
    t.boolean "friday_evening"
    t.boolean "saturday_morning"
    t.boolean "saturday_midday"
    t.boolean "saturday_evening"
    t.boolean "sunday_morning"
    t.boolean "sunday_midday"
    t.boolean "sunday_evening"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_availabilities_on_user_id"
  end

  create_table "blogs", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.string "content"
    t.integer "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_blogs_on_user_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.string "postalcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "ISO"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dogs", force: :cascade do |t|
    t.bigint "animal_id"
    t.string "breed"
    t.integer "maximum_walking_time"
    t.string "remarks"
    t.boolean "other_dogs"
    t.boolean "cats"
    t.boolean "children"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["animal_id"], name: "index_dogs_on_animal_id"
  end

  create_table "experiences", force: :cascade do |t|
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flocks", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "flock_id"
    t.bigint "animal_id"
    t.bigint "planning_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["animal_id"], name: "index_flocks_on_animal_id"
    t.index ["flock_id"], name: "index_flocks_on_flock_id"
    t.index ["planning_id"], name: "index_flocks_on_planning_id"
    t.index ["user_id"], name: "index_flocks_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.string "desription"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "from_user_id"
    t.integer "to_user_id"
    t.text "content"
    t.boolean "is_read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_id"], name: "index_messages_on_from_user_id"
    t.index ["to_user_id"], name: "index_messages_on_to_user_id"
  end

  create_table "photo_albums", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "description"
    t.bigint "visibility_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_photo_albums_on_user_id"
    t.index ["visibility_id"], name: "index_photo_albums_on_visibility_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "name"
    t.string "comment"
    t.integer "tag"
    t.string "url"
    t.bigint "photo_album_id"
    t.bigint "visibility_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["photo_album_id"], name: "index_pictures_on_photo_album_id"
    t.index ["visibility_id"], name: "index_pictures_on_visibility_id"
  end

  create_table "plannings", force: :cascade do |t|
    t.date "startDate"
    t.date "endDate"
    t.string "schedule"
    t.bigint "animal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["animal_id"], name: "index_plannings_on_animal_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.boolean "user_defined", default: false, null: false
    t.bigint "created_by_id"
    t.bigint "user_id"
    t.bigint "animal_id"
    t.bigint "activity_id"
    t.bigint "route_id"
    t.bigint "blog_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_tags_on_activity_id"
    t.index ["animal_id"], name: "index_tags_on_animal_id"
    t.index ["blog_id"], name: "index_tags_on_blog_id"
    t.index ["created_by_id"], name: "index_tags_on_created_by_id"
    t.index ["route_id"], name: "index_tags_on_route_id"
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "user_group_relations", force: :cascade do |t|
    t.integer "group"
    t.bigint "user_id"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_group_relations_on_user_id"
  end

  create_table "user_relation_animals", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "animal_id"
    t.boolean "is_owner"
    t.boolean "can_add_to_flock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["animal_id"], name: "index_user_relation_animals_on_animal_id"
    t.index ["user_id"], name: "index_user_relation_animals_on_user_id"
  end

  create_table "user_relations", force: :cascade do |t|
    t.integer "user_1_id"
    t.integer "user_2_id"
    t.string "name"
    t.date "start_date"
    t.boolean "is_pending", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_1_id"], name: "index_user_relations_on_user_1_id"
    t.index ["user_2_id"], name: "index_user_relations_on_user_2_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "firstname", null: false
    t.string "lastname"
    t.string "email", null: false
    t.string "crypted_password", null: false
    t.string "salt", null: false
    t.string "language"
    t.string "nationality"
    t.date "birthdate"
    t.string "phone"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "description"
    t.string "profile_picture"
    t.string "banner_picture"
    t.integer "number_of_walks"
    t.string "walking_region"
    t.string "skills"
    t.boolean "is_premium", default: false
    t.string "pricing"
    t.boolean "professional", default: false
    t.boolean "is_walker"
    t.bigint "preference_id"
    t.bigint "experience_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["experience_id"], name: "index_users_on_experience_id"
    t.index ["preference_id"], name: "index_users_on_preference_id"
  end

  create_table "visibilities", force: :cascade do |t|
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wallposts", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "picture"
    t.bigint "blog_id"
    t.integer "route"
    t.integer "tag"
    t.string "url"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_id"], name: "index_wallposts_on_blog_id"
    t.index ["user_id"], name: "index_wallposts_on_user_id"
  end

  add_foreign_key "activities", "users"
  add_foreign_key "addresses", "cities"
  add_foreign_key "addresses", "countries"
  add_foreign_key "addresses", "users"
  add_foreign_key "animals", "users"
  add_foreign_key "api_keys", "users"
  add_foreign_key "availabilities", "users"
  add_foreign_key "blogs", "users"
  add_foreign_key "dogs", "animals"
  add_foreign_key "flocks", "animals"
  add_foreign_key "flocks", "flocks"
  add_foreign_key "flocks", "plannings"
  add_foreign_key "flocks", "users"
  add_foreign_key "groups", "users"
  add_foreign_key "photo_albums", "users"
  add_foreign_key "photo_albums", "visibilities"
  add_foreign_key "pictures", "photo_albums"
  add_foreign_key "pictures", "visibilities"
  add_foreign_key "plannings", "animals"
  add_foreign_key "user_group_relations", "users"
  add_foreign_key "user_relation_animals", "animals"
  add_foreign_key "user_relation_animals", "users"
  add_foreign_key "users", "experiences"
  add_foreign_key "users", "preferences"
  add_foreign_key "wallposts", "blogs"
  add_foreign_key "wallposts", "users"
end
