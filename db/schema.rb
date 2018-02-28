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

ActiveRecord::Schema.define(version: 20180228054839) do

  create_table "cards", force: :cascade do |t|
    t.integer "company_id", null: false
    t.string "name", limit: 31, null: false
    t.string "kana_name", limit: 63, null: false
    t.string "department"
    t.string "position"
    t.string "postcode", limit: 8
    t.string "address", limit: 255
    t.string "tel", limit: 15
    t.string "fax", limit: 15
    t.string "mail", limit: 255
    t.binary "front_image"
    t.binary "back_image"
    t.string "qualification", limit: 255
    t.string "note", limit: 255
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_cards_on_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "short_name", limit: 31, null: false
    t.string "kana_name", limit: 255, null: false
    t.string "en_name", limit: 255
    t.integer "category", limit: 2, null: false
    t.integer "category_position", limit: 1, null: false
    t.binary "logo_image_data"
    t.string "note", limit: 255
    t.string "web_site", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kana_name"], name: "index_companies_on_kana_name"
  end

end
