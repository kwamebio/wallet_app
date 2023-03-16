class CreateBankAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_accounts do |t|

      t.string :account_number, null: false
      t.string :bank_name, null: false
      t.string :bank_code, null: false
      t.string :account_name, null: false
      t.string :recipient_code, null: false


      t.timestamps
    end

    add_index :bank_accounts, [:account_number, :bank_code], unique: true
  end
end
