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

ActiveRecord::Schema.define(version: 20150813144316) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_options", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users"
    t.integer  "groups"
  end

  create_table "accounts", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_option_id"
    t.boolean  "payment_active",                default: false
    t.boolean  "active",                        default: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.string   "description",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.string   "geo_info_file_name",    limit: 255
    t.string   "geo_info_content_type", limit: 255
    t.integer  "geo_info_file_size"
    t.datetime "geo_info_updated_at"
  end

  create_table "incivents", force: :cascade do |t|
    t.integer  "raised_user_id"
    t.string   "location",                    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "priority_id"
    t.integer  "type_id"
    t.text     "description"
    t.integer  "group_id"
    t.integer  "status_id"
    t.string   "incivent_image_file_name",    limit: 255
    t.string   "incivent_image_content_type", limit: 255
    t.integer  "incivent_image_file_size"
    t.datetime "incivent_image_updated_at"
    t.boolean  "archive",                                 default: false
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "recipient_email", limit: 255
    t.string   "token",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "launch_interests", force: :cascade do |t|
    t.string   "email_address", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.string   "subject",       limit: 255
  end

  create_table "measurements", force: :cascade do |t|
    t.string   "description",                    limit: 255
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "type_id"
    t.string   "location",                       limit: 255
    t.float    "longitude"
    t.float    "latitude"
    t.boolean  "archive",                                    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "measurement_image_file_name",    limit: 255
    t.string   "measurement_image_content_type", limit: 255
    t.integer  "measurement_image_file_size"
    t.datetime "measurement_image_updated_at"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["user_id", "group_id"], name: "index_memberships_on_user_id_and_group_id", unique: true, using: :btree

  create_table "priorities", force: :cascade do |t|
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  create_table "sms_ios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  create_table "stories", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "description"
    t.integer  "group_id"
    t.string   "location",                 limit: 255
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archive",                              default: false
    t.string   "story_image_file_name",    limit: 255
    t.string   "story_image_content_type", limit: 255
    t.integer  "story_image_file_size"
    t.datetime "story_image_updated_at"
    t.integer  "type_id",                              default: 1
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string   "paypal_payer_token",      limit: 255
    t.string   "recurring_profile_token", limit: 255
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "account_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.text     "description"
    t.string   "location",                limit: 255
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
    t.boolean  "complete",                            default: false
    t.string   "task_image_file_name",    limit: 255
    t.string   "task_image_content_type", limit: 255
    t.integer  "task_image_file_size"
    t.datetime "task_image_updated_at"
    t.boolean  "archive",                             default: false
  end

  create_table "types", force: :cascade do |t|
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.string   "usage",       limit: 255, default: "", null: false
  end

  create_table "updates", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "detail",         limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "updatable_id",               null: false
    t.string   "updatable_type",             null: false
  end

  add_index "updates", ["updatable_id"], name: "updates_updatable_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "email",                  limit: 255
    t.string   "encrypted_password",     limit: 255
    t.string   "salt",                   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "master_user",                        default: false
    t.integer  "account_id"
    t.string   "auth_token",             limit: 255
    t.string   "password_reset_token",   limit: 255
    t.datetime "password_reset_sent_at"
    t.boolean  "admin_user",                         default: false
    t.string   "phone",                  limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
