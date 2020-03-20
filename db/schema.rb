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

ActiveRecord::Schema.define(version: 2020_03_20_140201) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clubs", force: :cascade do |t|
    t.string "name"
  end

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "start_date", null: false
    t.jsonb "participants", default: {}
    t.bigint "club_id"
    t.index ["club_id"], name: "index_events_on_club_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.integer "members_ids", default: [], array: true
    t.bigint "club_id"
    t.index ["club_id"], name: "index_groups_on_club_id"
  end

  create_table "members", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "club_id"
    t.string "roles", default: [], array: true
    t.index ["club_id"], name: "index_members_on_club_id"
    t.index ["user_id", "club_id"], name: "index_members_on_user_id_and_club_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "jwt_version", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
