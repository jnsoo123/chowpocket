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

ActiveRecord::Schema.define(version: 20170726020853) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_ordered", default: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_carts_on_deleted_at"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "chatbot_users", force: :cascade do |t|
    t.string "name"
    t.string "contact_number"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "facebook_id"
  end

  create_table "clusters", force: :cascade do |t|
    t.integer "discount", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_created"
    t.bigint "menu_id"
    t.index ["menu_id"], name: "index_clusters_on_menu_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "menu_id"
    t.bigint "cart_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
    t.index ["menu_id"], name: "index_line_items_on_menu_id"
  end

  create_table "menu_clusters", force: :cascade do |t|
    t.bigint "menu_id"
    t.bigint "order_id"
    t.bigint "cluster_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cluster_id"], name: "index_menu_clusters_on_cluster_id"
    t.index ["menu_id"], name: "index_menu_clusters_on_menu_id"
    t.index ["order_id"], name: "index_menu_clusters_on_order_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.string "description"
    t.string "schedule"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "cart_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "status", default: "pending"
    t.index ["cart_id"], name: "index_orders_on_cart_id"
    t.index ["deleted_at"], name: "index_orders_on_deleted_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "user"
    t.string "provider"
    t.string "name"
    t.datetime "deleted_at"
    t.string "phone_number"
    t.bigint "building_id"
    t.string "floor"
    t.string "company_name"
    t.index ["building_id"], name: "index_users_on_building_id"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "carts", "users"
  add_foreign_key "clusters", "menus"
  add_foreign_key "line_items", "carts"
  add_foreign_key "line_items", "menus"
  add_foreign_key "menu_clusters", "clusters"
  add_foreign_key "menu_clusters", "menus"
  add_foreign_key "menu_clusters", "orders"
  add_foreign_key "orders", "carts"
  add_foreign_key "users", "buildings"
end
