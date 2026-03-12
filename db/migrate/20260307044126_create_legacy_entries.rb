class CreateLegacyEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :legacy_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :legacy_catalog_item, null: false, foreign_key: true
      t.string :value, null: false

      t.timestamps
    end

    add_index :legacy_entries, [ :user_id, :legacy_catalog_item_id ], unique: true
  end
end
