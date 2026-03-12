class DropLegacyCollageTables < ActiveRecord::Migration[8.1]
  def up
    drop_table :friendships, if_exists: true
    drop_table :test_results, if_exists: true
    drop_table :supported_tests, if_exists: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Legacy collage tables were intentionally removed."
  end
end
