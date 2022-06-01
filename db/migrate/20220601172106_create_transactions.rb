class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :client, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :order_id
      t.string :status, default: "New", null: false
      t.timestamps
    end
  end
end
