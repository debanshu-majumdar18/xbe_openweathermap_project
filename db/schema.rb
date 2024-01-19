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

ActiveRecord::Schema[7.1].define(version: 2024_01_19_131501) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_call_logs", force: :cascade do |t|
    t.string "api_end_point"
    t.string "api_name"
    t.string "params"
    t.string "request_type"
    t.string "callback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "historic_data_records", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.jsonb "historic_air_pollution_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_historic_data_records_on_location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.string "state"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pollution_concentrations", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.float "pm25"
    t.float "pm10"
    t.float "co"
    t.float "o3"
    t.float "so2"
    t.float "no2"
    t.float "aqi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_pollution_concentrations_on_location_id"
  end

  add_foreign_key "historic_data_records", "locations"
  add_foreign_key "pollution_concentrations", "locations"
end
