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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110829122140) do

  create_table "categories", :force => true do |t|
    t.integer "space_id"
    t.string  "name"
  end

  create_table "resources", :force => true do |t|
    t.integer "category_id"
    t.integer "member_id"
    t.string  "name"
  end

  add_index "resources", ["category_id"], :name => "index_resources_on_category_id"
  add_index "resources", ["member_id"], :name => "index_resources_on_member_id"

  create_table "spaces", :force => true do |t|
    t.string "url"
    t.string "name"
  end

  add_index "spaces", ["name"], :name => "index_spaces_on_name"
  add_index "spaces", ["url"], :name => "index_spaces_on_url"

  create_table "users", :force => true do |t|
    t.string "login"
    t.string "email"
    t.string "oauth_token"
    t.string "admin_of"
  end

  add_index "users", ["login"], :name => "index_users_on_login"

end
