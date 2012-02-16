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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120202130037) do

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "games", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "loser_score", :default => 0
  end

  create_table "outcomes", :force => true do |t|
    t.integer  "player_id"
    t.integer  "game_id"
    t.boolean  "win"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "outcomes", ["game_id"], :name => "index_outcomes_on_game_id"
  add_index "outcomes", ["player_id"], :name => "index_outcomes_on_player_id"

  create_table "players", :force => true do |t|
    t.string   "email"
    t.integer  "rank"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doubles_rank"
  end

end
