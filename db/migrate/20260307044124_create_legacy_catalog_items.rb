class CreateLegacyCatalog < ActiveRecord::Migration[8.1]
  def change
    create_table :legacy_catalog_items do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.text :details

      t.timestamps
    end

    add_index :legacy_catalog_items, :code, unique: true
  end
end
