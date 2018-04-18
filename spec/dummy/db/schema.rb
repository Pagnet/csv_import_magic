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

ActiveRecord::Schema.define(version: 20170505100034) do

  create_table "companies", force: :cascade do |t|
    t.integer "user_id"
    t.string  "name"
    t.string  "street"
    t.string  "number"
    t.string  "neighborhood"
    t.string  "city"
    t.string  "state"
    t.string  "country"
    t.boolean "active"
    t.string  "one_additional_attribute"
    t.string  "other_additional_attribute"
  end

  create_table "importers", force: :cascade do |t|
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "attachment_error_file_name"
    t.string   "attachment_error_content_type"
    t.integer  "attachment_error_file_size"
    t.datetime "attachment_error_updated_at"
    t.string   "source"
    t.string   "parser"
    t.string   "columns"
    t.string   "message"
    t.string   "status",                        default: "pending"
    t.string   "importable_type"
    t.integer  "importable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "additional_data"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
  end

end
