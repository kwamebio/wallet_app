# == Schema Information
#
# Table name: bank_accounts
#
#  id             :bigint           not null, primary key
#  account_number :string           not null
#  bank_name      :string           not null
#  bank_code      :string           not null
#  account_name   :string           not null
#  recipient_code :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class BankAccount < ApplicationRecord
    has_many :transactions, as: :destination
  
    def api_output
      JSON(self.to_json).slice('id', 'bank_name', 'account_number', 'account_name', 'recipient_code')
    end
end
