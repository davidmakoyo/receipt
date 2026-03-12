class DropLegacyTables < ActiveRecord::Migration[8.1]
  def up
    drop_table :legacy_links, if_exists: true
    drop_table :legacy_entries, if_exists: true
    drop_table :legacy_catalog_items, if_exists: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Legacy tables were intentionally removed."
  end
end
