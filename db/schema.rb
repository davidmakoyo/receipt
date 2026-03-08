
ActiveRecord::Schema[8.1].define(version: 2026_03_07_044127) do
  create_table "friendships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "friend_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "supported_tests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "external_url"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_supported_tests_on_slug", unique: true
  end

  create_table "test_results", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "result_value", null: false
    t.integer "supported_test_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["supported_test_id"], name: "index_test_results_on_supported_test_id"
    t.index ["user_id", "supported_test_id"], name: "index_test_results_on_user_id_and_supported_test_id", unique: true
    t.index ["user_id"], name: "index_test_results_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
  add_foreign_key "test_results", "supported_tests"
  add_foreign_key "test_results", "users"
end
