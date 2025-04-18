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

ActiveRecord::Schema[7.0].define(version: 2022_02_20_194832) do
  create_table "clinic_taxonomies", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "code", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clinic_taxonomy_edges", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "clinic_id", null: false
    t.integer "clinic_taxonomy_id", null: false
    t.boolean "primary"
    t.string "state"
    t.string "license"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id", "clinic_taxonomy_id", "state", "license"], name: "clinic_tax_edges_ids_index", unique: true
  end

  create_table "clinics", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "order", null: false
    t.integer "number", null: false
    t.string "organization_name"
    t.string "organizational_subpart"
    t.string "status"
    t.string "authorized_official_first_name"
    t.string "authorized_official_last_name"
    t.string "authorized_official_telephone_number"
    t.string "authorized_official_title_or_position"
    t.string "authorized_official_name_prefix"
    t.string "location_address_country_code"
    t.string "location_address_type"
    t.string "location_address_1"
    t.string "location_address_2"
    t.string "location_address_city"
    t.string "location_address_state"
    t.string "location_address_postal_code"
    t.string "location_address_telephone_number"
    t.string "location_address_fax_number"
    t.string "mailing_address_country_code"
    t.string "mailing_address_type"
    t.string "mailing_address_1"
    t.string "mailing_address_2"
    t.string "mailing_address_city"
    t.string "mailing_address_state"
    t.string "mailing_address_postal_code"
    t.string "mailing_address_telephone_number"
    t.string "mailing_address_fax_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_clinics_on_number", unique: true
    t.index ["order"], name: "index_clinics_on_order", unique: true
  end

  create_table "physician_taxonomies", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "code", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "physician_taxonomy_edges", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "physician_id", null: false
    t.integer "physician_taxonomy_id", null: false
    t.boolean "primary"
    t.string "state"
    t.string "license"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["physician_id", "physician_taxonomy_id", "state", "license"], name: "phys_tax_edges_ids_index", unique: true
  end

  create_table "physicians", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "order", null: false
    t.integer "number", null: false
    t.string "name_prefix"
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.string "credential"
    t.string "sole_proprietor"
    t.string "sex"
    t.string "status"
    t.string "location_address_country_code"
    t.string "location_address_type"
    t.string "location_address_1"
    t.string "location_address_2"
    t.string "location_address_city"
    t.string "location_address_state"
    t.string "location_address_postal_code"
    t.string "location_address_telephone_number"
    t.string "location_address_fax_number"
    t.string "mailing_address_country_code"
    t.string "mailing_address_type"
    t.string "mailing_address_1"
    t.string "mailing_address_2"
    t.string "mailing_address_city"
    t.string "mailing_address_state"
    t.string "mailing_address_postal_code"
    t.string "mailing_address_telephone_number"
    t.string "mailing_address_fax_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_physicians_on_number", unique: true
    t.index ["order"], name: "index_physicians_on_order", unique: true
  end

end
