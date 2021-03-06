# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_200_429_131_507) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'game_sets', force: :cascade do |t|
    t.string 'uid'
    t.datetime 'end_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'kingdoms', force: :cascade do |t|
    t.string 'name_en'
    t.string 'name_ru'
    t.string 'emblem_en'
    t.string 'emblem_ru'
    t.string 'leader_ru'
    t.string 'leader_en'
    t.string 'title_en', default: 'King'
    t.string 'title_ru', default: 'Король'
    t.string 'emblem_avatar'
    t.string 'leader_avatar'
    t.boolean 'ruler', default: false
    t.integer 'vassals_count', default: 0
    t.bigint 'sovereign_id'
    t.bigint 'game_set_id'
    t.bigint 'game_id'
    t.index ['game_id'], name: 'index_kingdoms_on_game_id'
    t.index ['game_set_id'], name: 'index_kingdoms_on_game_set_id'
    t.index ['sovereign_id'], name: 'index_kingdoms_on_sovereign_id'
  end

  create_table 'messages', force: :cascade do |t|
    t.text 'body'
    t.bigint 'sender_id'
    t.bigint 'receiver_id'
    t.index ['receiver_id'], name: 'index_messages_on_receiver_id'
    t.index %w[sender_id receiver_id], name: 'index_messages_on_sender_id_and_receiver_id'
    t.index ['sender_id'], name: 'index_messages_on_sender_id'
  end

  add_foreign_key 'messages', 'kingdoms', column: 'receiver_id'
  add_foreign_key 'messages', 'kingdoms', column: 'sender_id'
end
