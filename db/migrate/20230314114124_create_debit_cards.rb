class CreateDebitCards < ActiveRecord::Migration[7.0]
  def change
    create_table :debit_cards do |t|

      t.string :authorization_code, null: false
      t.string :last4, null: false
      t.string :exp_month, null: false
      t.string :exp_year, null: false
      t.string :card_type, null: false
      t.string :bank, null: false
      t.belongs_to :user

      t.timestamps
    end
  end
end
