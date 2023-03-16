class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.float :amount, null: false
      t.integer :txn_type, limit: 1, null: false
      t.integer :status, limit: 1, null: false
      t.bigint :source_id, null: false
      t.string :source_type, null: false
      t.bigint :destination_id, null: false
      t.string :destination_type, null: false
      t.string :txn_ref, null: false

      t.timestamps
    end
    
    add_index :transactions, :txn_ref, unique: true
    add_index :transactions, [:source_id, :source_type]
    add_index :transactions, [:destination_id, :destination_type]
  end
end
