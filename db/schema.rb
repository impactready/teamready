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

ActiveRecord::Schema.define(version: 20150804064107) do

  create_table "account_options", force: true do |t|
    t.string   "name"
    t.integer  "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users"
    t.integer  "groups"
  end

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_option_id"
    t.boolean  "payment_active",    default: false
    t.boolean  "active",            default: false
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.string   "geo_info_file_name"
    t.string   "geo_info_content_type"
    t.integer  "geo_info_file_size"
    t.datetime "geo_info_updated_at"
  end

  create_table "incivents", force: true do |t|
    t.string   "name"
    t.integer  "raised_user_id"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "priority_id"
    t.integer  "type_id"
    t.text     "description"
    t.integer  "group_id"
    t.integer  "status_id"
    t.string   "incivent_image_file_name"
    t.string   "incivent_image_content_type"
    t.integer  "incivent_image_file_size"
    t.datetime "incivent_image_updated_at"
    t.boolean  "archive",                     default: false
  end

  create_table "invitations", force: true do |t|
    t.integer  "account_id"
    t.string   "recipient_email"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "launch_interests", force: true do |t|
    t.string   "email_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.string   "subject"
  end

  create_table "measurements", force: true do |t|
    t.string   "description"
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "type_id"
    t.string   "location"
    t.float    "longitude"
    t.float    "latitude"
    t.boolean  "archive",                        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "measurement_image_file_name"
    t.string   "measurement_image_content_type"
    t.integer  "measurement_image_file_size"
    t.datetime "measurement_image_updated_at"
  end

  create_table "memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["user_id", "group_id"], name: "index_memberships_on_user_id_and_group_id", unique: true

  create_table "priorities", force: true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  create_table "sms_ios", force: true do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", force: true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  create_table "stories", force: true do |t|
    t.integer  "user_id"
    t.text     "description"
    t.integer  "group_id"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archive",                  default: false
    t.string   "story_image_file_name"
    t.string   "story_image_content_type"
    t.integer  "story_image_file_size"
    t.datetime "story_image_updated_at"
    t.integer  "type_id",                  default: 1
  end

  create_table "subscriptions", force: true do |t|
    t.string   "paypal_payer_token"
    t.string   "recurring_profile_token"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "account_id"
  end

  create_table "tasks", force: true do |t|
    t.text     "description"
    t.string   "location"
    t.integer  "group_id"
    t.integer  "assigned_user_id"
    t.integer  "priority_id"
    t.integer  "status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "raised_user_id"
    t.date     "due_date"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "complete",                default: false
    t.string   "task_image_file_name"
    t.string   "task_image_content_type"
    t.integer  "task_image_file_size"
    t.datetime "task_image_updated_at"
    t.boolean  "archive",                 default: false
  end

  create_table "types", force: true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.string   "usage",       default: "", null: false
  end

  create_table "updates", force: true do |t|
    t.integer  "group_id"
    t.string   "detail"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "update_type", default: "", null: false
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "master_user",            default: false
    t.integer  "account_id"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "admin_user",             default: false
    t.string   "phone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
