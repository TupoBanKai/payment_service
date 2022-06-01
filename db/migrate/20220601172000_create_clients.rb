class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :username, null: false
      t.string :password, null: false
      t.timestamps
    end
  end
end
