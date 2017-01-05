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

ActiveRecord::Schema.define(version: 20170105191133) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "commitments", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "meetup_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "commitments", ["meetup_id"], name: "index_commitments_on_meetup_id", using: :btree
  add_index "commitments", ["user_id", "meetup_id"], name: "index_commitments_on_user_id_and_meetup_id", unique: true, using: :btree
  add_index "commitments", ["user_id"], name: "index_commitments_on_user_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "locations", ["name", "address"], name: "index_locations_on_name_and_address", unique: true, using: :btree

  create_table "meetups", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description", null: false
    t.integer  "location_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "creator_id",  null: false
  end

  add_index "meetups", ["creator_id"], name: "index_meetups_on_creator_id", using: :btree
  add_index "meetups", ["location_id"], name: "index_meetups_on_location_id", using: :btree
  add_index "meetups", ["name", "location_id"], name: "index_meetups_on_name_and_location_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.string   "username",   null: false
    t.string   "email",      null: false
    t.string   "avatar_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

end
