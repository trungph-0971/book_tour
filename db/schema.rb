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

ActiveRecord::Schema.define(version: 20191217040725) do

  create_table "bank_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "bank_name"
    t.string "account_number"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bank_accounts_on_user_id"
  end

  create_table "bookings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "status", default: 1
    t.float "price", limit: 24, default: 0.0
    t.integer "people_number"
    t.bigint "tour_detail_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.timestamp "deleted_at"
    t.text "notification_params"
    t.string "transaction_id"
    t.datetime "purchased_at"
    t.index ["tour_detail_id"], name: "index_bookings_on_tour_detail_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "content"
    t.string "commentable_type"
    t.integer "commentable_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "likes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "review_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["review_id"], name: "index_likes_on_review_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "pictures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "link"
    t.string "pictureable_type"
    t.integer "pictureable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "revenues", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.float "revenue", limit: 24, default: 0.0
    t.bigint "tour_detail_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tour_detail_id"], name: "index_revenues_on_tour_detail_id"
  end

  create_table "reviews", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "content"
    t.integer "rating"
    t.bigint "tour_detail_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tour_detail_id"], name: "index_reviews_on_tour_detail_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "tour_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date "start_time"
    t.date "end_time"
    t.float "price", limit: 24, default: 0.0
    t.integer "people_number"
    t.bigint "tour_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.timestamp "deleted_at"
    t.index ["tour_id"], name: "index_tour_details_on_tour_id"
  end

  create_table "tours", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "description"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.timestamp "deleted_at"
    t.index ["category_id"], name: "index_tours_on_category_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.integer "role", default: 1
    t.string "provider"
    t.string "uid"
    t.string "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.string "reset_sent_at"
    t.string "datetime"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "bank_accounts", "users"
  add_foreign_key "bookings", "tour_details"
  add_foreign_key "bookings", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "likes", "reviews"
  add_foreign_key "likes", "users"
  add_foreign_key "revenues", "tour_details"
  add_foreign_key "reviews", "tour_details"
  add_foreign_key "reviews", "users"
  add_foreign_key "tour_details", "tours"
  add_foreign_key "tours", "categories"
end
