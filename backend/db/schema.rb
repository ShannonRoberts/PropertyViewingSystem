# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 6) do

  create_table "availability_slots", force: :cascade do |t|
    t.integer "property_id", null: false
    t.integer "property_manager_id", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "day_of_week"
    t.boolean "is_available", default: true, null: false
    t.index ["day_of_week"], name: "index_availability_slots_on_day_of_week"
    t.index ["end_time"], name: "index_availability_slots_on_end_time"
    t.index ["is_available"], name: "index_availability_slots_on_is_available"
    t.index ["property_id", "start_time"], name: "index_availability_slots_on_property_id_and_start_time"
    t.index ["property_id"], name: "index_availability_slots_on_property_id"
    t.index ["property_manager_id", "start_time"], name: "index_availability_slots_on_property_manager_id_and_start_time"
    t.index ["property_manager_id"], name: "index_availability_slots_on_property_manager_id"
    t.index ["start_time"], name: "index_availability_slots_on_start_time"
  end

  create_table "potential_tenants", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_potential_tenants_on_email", unique: true
  end

  create_table "properties", force: :cascade do |t|
    t.string "title", null: false
    t.string "property_type", null: false
    t.string "status", null: false
    t.string "street_address", null: false
    t.string "suburb", null: false
    t.string "city", null: false
    t.string "region", null: false
    t.string "zip_code", null: false
    t.string "country", null: false
    t.text "description", null: false
    t.integer "price", null: false
    t.integer "bedrooms", null: false
    t.integer "bathrooms", null: false
    t.integer "square_feet"
    t.integer "year_built"
    t.decimal "lot_size", precision: 8, scale: 2
    t.integer "property_manager_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city"], name: "index_properties_on_city"
    t.index ["price"], name: "index_properties_on_price"
    t.index ["property_manager_id"], name: "index_properties_on_property_manager_id"
    t.index ["property_type"], name: "index_properties_on_property_type"
    t.index ["region"], name: "index_properties_on_region"
    t.index ["status"], name: "index_properties_on_status"
    t.index ["suburb"], name: "index_properties_on_suburb"
    t.index ["zip_code"], name: "index_properties_on_zip_code"
  end

  create_table "property_managers", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "company_name"
    t.string "address"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_property_managers_on_email", unique: true
  end

  create_table "viewings", force: :cascade do |t|
    t.datetime "scheduled_at", null: false
    t.string "status", null: false
    t.text "notes"
    t.integer "property_id", null: false
    t.integer "potential_tenant_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["potential_tenant_id"], name: "index_viewings_on_potential_tenant_id"
    t.index ["property_id"], name: "index_viewings_on_property_id"
    t.index ["scheduled_at"], name: "index_viewings_on_scheduled_at"
    t.index ["status"], name: "index_viewings_on_status"
  end

  add_foreign_key "availability_slots", "properties"
  add_foreign_key "availability_slots", "property_managers"
  add_foreign_key "properties", "property_managers"
  add_foreign_key "viewings", "potential_tenants"
  add_foreign_key "viewings", "properties"
end
