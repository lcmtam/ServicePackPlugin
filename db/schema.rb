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

ActiveRecord::Schema.define(version: 6) do

  create_table "enumerations", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.integer "project_id"
    t.string "type"
    t.index ["project_id", "name"], name: "project_id_name_index", unique: true
    t.index ["project_id"], name: "index_enumerations_on_project_id"
  end

  create_table "module_assignments", force: :cascade do |t|
    t.integer "project_id"
    t.index ["project_id"], name: "index_module_assignments_on_project_id", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "identifier"
  end

  create_table "service_packs", force: :cascade do |t|
    t.string "name"
    t.float "capacity"
    t.float "used"
    t.date "activation_date"
    t.date "expiration_date"
    t.date "deactivation_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_service_packs_on_name", unique: true
  end

  create_table "sp_assign", force: :cascade do |t|
    t.integer "service_packs_id"
    t.integer "project_id"
    t.index ["project_id"], name: "index_sp_assign_on_project_id"
    t.index ["service_packs_id"], name: "index_sp_assign_on_service_packs_id"
  end

  create_table "sp_mappings", force: :cascade do |t|
    t.integer "enumerations_id"
    t.integer "service_packs_id"
    t.integer "rate"
    t.index ["enumerations_id"], name: "index_sp_mappings_on_enumerations_id"
    t.index ["service_packs_id"], name: "index_sp_mappings_on_service_packs_id"
  end

  create_table "time_entries", force: :cascade do |t|
    t.integer "activity_id"
    t.integer "project_id"
    t.float "hours"
    t.date "spent_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "comment", limit: 255
    t.index ["project_id"], name: "index_time_entries_on_project_id"
  end

end
