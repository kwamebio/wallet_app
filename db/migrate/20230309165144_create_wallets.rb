class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.belongs_to :user
      t.integer :settled_balance, unsigned: true, default: 0
      t.integer :status, limit: 1

      t.timestamps
    end
  end
end
