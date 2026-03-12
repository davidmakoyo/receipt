class CreateReceipts < ActiveRecord::Migration[8.1]
  def change
    create_table :receipts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :merchant, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.date :purchase_date, null: false
      t.string :category, null: false
      t.text :notes

      t.timestamps
    end

    add_index :receipts, :purchase_date
    add_index :receipts, :category
  end
end
