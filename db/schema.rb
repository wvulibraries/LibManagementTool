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

ActiveRecord::Schema.define(version: 20170203201345) do

  create_table "departments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "description", limit: 65535
    t.integer  "library_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["library_id"], name: "index_departments_on_library_id", using: :btree
  end

  create_table "departments_library", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "library_id",    null: false
    t.integer "department_id", null: false
  end

  create_table "libraries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "normal_hours", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "resource_type"
    t.integer  "resource_id"
    t.integer  "day_of_week"
    t.datetime "open_time"
    t.datetime "close_time"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["resource_type", "resource_id"], name: "index_normal_hours_on_resource_type_and_resource_id", using: :btree
  end

  create_table "sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "session_id",               null: false
    t.string   "cas_ticket"
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["cas_ticket"], name: "index_sessions_on_cas_ticket", using: :btree
    t.index ["session_id"], name: "index_sessions_on_session_id", using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "special_hours", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "special_type"
    t.integer  "special_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "name"
    t.datetime "open_time"
    t.datetime "close_time"
    t.boolean  "open_24"
    t.boolean  "no_close_time"
    t.boolean  "no_open_time"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["special_type", "special_id"], name: "index_special_hours_on_special_type_and_special_id", using: :btree
  end

  create_table "user_permissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "departments", limit: 65535
    t.text     "libraries",   limit: 65535
    t.string   "username"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "username",                   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "admin",      default: false, null: false
    t.string   "firstname",                  null: false
    t.string   "lastname",                   null: false
  end

end
