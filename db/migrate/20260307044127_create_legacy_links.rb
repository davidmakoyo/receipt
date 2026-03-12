class CreateLegacyLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :legacy_links do |t|
      t.references :user, null: false, foreign_key: true
      t.references :related_user, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :legacy_links, [ :user_id, :related_user_id ], unique: true
  end
end
