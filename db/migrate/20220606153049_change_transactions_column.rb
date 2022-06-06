class ChangeTransactionsColumn < ActiveRecord::Migration[6.0]
  def up
    rename_column :transactions, :order_id, :ab_id
  end

  def down
    rename_column :transactions, :ab_id, :order_id
  end
end
