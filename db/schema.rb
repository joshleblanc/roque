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

ActiveRecord::Schema[8.0].define(version: 2025_06_07_212607) do
  create_table "connected_services", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_connected_services_on_user_id"
  end

  create_table "prompts", force: :cascade do |t|
    t.text "content"
    t.binary "embedding"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "retry_count", default: 0
    t.boolean "current"
  end

  create_table "responses", force: :cascade do |t|
    t.integer "prompt_id", null: false
    t.string "discord_uid"
    t.binary "embedding"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
    t.index ["discord_uid"], name: "index_responses_on_discord_uid"
    t.index ["prompt_id"], name: "index_responses_on_prompt_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time_zone"
    t.integer "notification_hour", default: 6
    t.integer "notification_minute", default: 0
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "connected_services", "users"
  add_foreign_key "responses", "prompts"
  add_foreign_key "sessions", "users"
end
