class CreateTestResults < ActiveRecord::Migration[8.1]
  def change
    create_table :test_results do |t|
      t.references :user, null: false, foreign_key: true
      t.references :supported_test, null: false, foreign_key: true
      t.string :result_value, null: false

      t.timestamps
    end

    add_index :test_results, [ :user_id, :supported_test_id ], unique: true
  end
end
