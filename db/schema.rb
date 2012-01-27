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

ActiveRecord::Schema.define(:version => 20120127135257) do

  create_table "doubles_games", :force => true do |t|
    t.integer  "winner1_id"
    t.integer  "winner2_id"
    t.integer  "loser1_id"
    t.integer  "loser2_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "loser_score", :default => 0
  end

  add_index "doubles_games", ["loser1_id"], :name => "index_doubles_games_on_loser1_id"
  add_index "doubles_games", ["loser2_id"], :name => "index_doubles_games_on_loser2_id"
  add_index "doubles_games", ["winner1_id"], :name => "index_doubles_games_on_winner1_id"
  add_index "doubles_games", ["winner2_id"], :name => "index_doubles_games_on_winner2_id"

  create_table "games", :force => true do |t|
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "loser_score", :default => 0
  end

  create_table "players", :force => true do |t|
    t.string   "email"
    t.integer  "rank"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doubles_rank"
  end

end
