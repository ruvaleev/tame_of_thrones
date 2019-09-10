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

ActiveRecord::Schema.define(version: 2019_08_13_164154) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "kingdoms", force: :cascade do |t|
    t.string "name"
    t.string "emblem"
    t.string "king"
    t.string "emblem_avatar"
    t.string "king_avatar"
    t.boolean "ruler", default: false
    t.integer "vassals_count"
    t.bigint "sovereign_id"
    t.index ["emblem"], name: "index_kingdoms_on_emblem"
    t.index ["king"], name: "index_kingdoms_on_king"
    t.index ["name"], name: "index_kingdoms_on_name"
    t.index ["sovereign_id"], name: "index_kingdoms_on_sovereign_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id", "receiver_id"], name: "index_messages_on_sender_id_and_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  add_foreign_key "kingdoms", "kingdoms", column: "sovereign_id"
  add_foreign_key "messages", "kingdoms", column: "receiver_id"
  add_foreign_key "messages", "kingdoms", column: "sender_id"
end
