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

ActiveRecord::Schema.define(version: 20170111174713) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.integer "space_id"
    t.string  "name"
  end

  create_table "resources", force: :cascade do |t|
    t.integer "category_id"
    t.integer "member_id"
    t.string  "name"
    t.string  "member_cobot_id"
    t.string  "member_name"
  end

  add_index "resources", ["category_id"], name: "index_resources_on_category_id", using: :btree
  add_index "resources", ["member_id"], name: "index_resources_on_member_id", using: :btree

  create_table "spaces", force: :cascade do |t|
    t.string "url"
    t.string "name"
    t.text   "admins"
  end

  add_index "spaces", ["name"], name: "index_spaces_on_name", using: :btree
  add_index "spaces", ["url"], name: "index_spaces_on_url", using: :btree

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "oauth_token"
    t.text   "admin_of"
  end

end
