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

ActiveRecord::Schema.define(version: 20121119150034) do

  create_table "colors", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "title",      null: false
    t.string   "frame",      null: false
    t.string   "text1",      null: false
    t.string   "text2",      null: false
    t.string   "bg1",        null: false
    t.string   "bg2",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "html_templates", force: :cascade do |t|
    t.string   "name",       null: false
    t.text     "contents",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string   "name",       null: false
    t.text     "contents1",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "contents2"
    t.text     "contents3"
    t.text     "contents4"
    t.text     "contents5"
    t.text     "contents6"
    t.text     "contents7"
    t.text     "contents8"
    t.text     "contents9"
  end

  create_table "text_templates", force: :cascade do |t|
    t.string   "name",       null: false
    t.text     "header"
    t.string   "col1_title"
    t.string   "col2_title"
    t.string   "col3_title"
    t.string   "col4_title"
    t.string   "col5_title"
    t.text     "col1_text"
    t.text     "col2_text"
    t.text     "col3_text"
    t.text     "col4_text"
    t.text     "col5_text"
    t.text     "footer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "is_admin",         default: false
  end

end
