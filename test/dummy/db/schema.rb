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

ActiveRecord::Schema[8.0].define(version: 2025_01_28_043706) do
  create_table "flex_subs_featurables", force: :cascade do |t|
    t.integer "feature_id", null: false
    t.string "featurable_type", null: false
    t.integer "featurable_id", null: false
    t.decimal "consumption_limit"
    t.decimal "consumption_recurrence_value"
    t.string "consumption_recurrence_unit"
    t.boolean "over_consumption_allowed"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.decimal "units_per_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["featurable_type", "featurable_id"], name: "index_flex_subs_featurables_on_featurable"
    t.index ["feature_id"], name: "index_flex_subs_featurables_on_feature_id"
  end

  create_table "flex_subs_features", force: :cascade do |t|
    t.string "name"
    t.boolean "consumable", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flex_subs_plans", force: :cascade do |t|
    t.string "name"
    t.decimal "grace_period_value"
    t.string "grace_period_unit"
    t.decimal "recurrence_value"
    t.string "recurrence_unit"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flex_subs_subscription_feature_consumptions", force: :cascade do |t|
    t.integer "subscription_id", null: false
    t.integer "feature_id", null: false
    t.string "consumer_type"
    t.integer "consumer_id"
    t.decimal "amount"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consumer_type", "consumer_id"], name: "idx_on_consumer_type_and_consumer_id_8a48f601ec"
    t.index ["feature_id"], name: "idx_on_feature_id_8a48f601ec"
    t.index ["subscription_id"], name: "idx_on_subscription_id_41594400cd"
  end

  create_table "flex_subs_subscription_renewals", force: :cascade do |t|
    t.integer "subscription_id", null: false
    t.datetime "subscription_ends_at"
    t.datetime "subscription_grace_period_ends_at"
    t.datetime "renewed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id"], name: "idx_on_subscription_id_351581098b"
  end

  create_table "flex_subs_subscriptions", force: :cascade do |t|
    t.integer "plan_id", null: false
    t.string "subscriber_type"
    t.integer "subscriber_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "canceled_at"
    t.datetime "suppressed_at"
    t.datetime "grace_period_ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_flex_subs_subscriptions_on_plan_id"
    t.index ["subscriber_type", "subscriber_id"], name: "index_flex_subs_subscriptions_on_subscriber"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workspaces", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "flex_subs_featurables", "flex_subs_features", column: "feature_id"
  add_foreign_key "flex_subs_subscription_feature_consumptions", "flex_subs_features", column: "feature_id"
  add_foreign_key "flex_subs_subscription_feature_consumptions", "flex_subs_subscriptions", column: "subscription_id"
  add_foreign_key "flex_subs_subscription_renewals", "flex_subs_subscriptions", column: "subscription_id"
  add_foreign_key "flex_subs_subscriptions", "flex_subs_plans", column: "plan_id"
end
