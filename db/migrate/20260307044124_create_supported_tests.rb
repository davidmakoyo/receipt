class CreateSupportedTests < ActiveRecord::Migration[8.1]
  def change
    create_table :supported_tests do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :external_url
      t.text :description

      t.timestamps
    end

    add_index :supported_tests, :slug, unique: true
  end
end
