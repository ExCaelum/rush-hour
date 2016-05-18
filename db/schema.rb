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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20160518021848) do
=======
ActiveRecord::Schema.define(version: 20160518045743) do
>>>>>>> iteration-1-parker-night

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_names", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payload_requests", force: :cascade do |t|
    t.datetime "requested_at"
    t.integer  "responded_in"
    t.string   "referred_by"
    t.string   "parameters"
    t.string   "ip"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "url_id"
    t.integer  "request_type_id"
    t.integer  "resolution_id"
    t.integer  "event_name_id"
    t.integer  "user_agent_id"
  end

  add_index "payload_requests", ["event_name_id"], name: "index_payload_requests_on_event_name_id", using: :btree
  add_index "payload_requests", ["request_type_id"], name: "index_payload_requests_on_request_type_id", using: :btree
  add_index "payload_requests", ["resolution_id"], name: "index_payload_requests_on_resolution_id", using: :btree
  add_index "payload_requests", ["url_id"], name: "index_payload_requests_on_url_id", using: :btree
  add_index "payload_requests", ["user_agent_id"], name: "index_payload_requests_on_user_agent_id", using: :btree

  create_table "request_types", force: :cascade do |t|
    t.string   "verb"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resolutions", force: :cascade do |t|
    t.string   "height"
    t.string   "width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "urls", force: :cascade do |t|
    t.string   "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_agents", force: :cascade do |t|
    t.string   "os"
    t.string   "browser"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
