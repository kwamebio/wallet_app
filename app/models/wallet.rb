# == Schema Information
#
# Table name: wallets
#
#  id              :bigint           not null, primary key
#  user_id         :bigint
#  settled_balance :integer          default(0)
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Wallet < ApplicationRecord
    belongs_to :user
  
    validates :status, presence: true
    before_validation :check_status
  
    has_many :debit_transactions, as: :source, class_name: :Transaction
    has_many :credit_transactions, as: :destination, class_name: :Transaction
  
    def transactions
      Transaction.where(source: self)
                 .or(Transaction.where(destination: self))
                 .order(updated_at: :desc)
    end
  
    enum status: {
      status_active: 0,
      status_inactive: 1,
    }
  
    def api_output
        JSON(self.to_json).merge({recent_transactions: self.transactions.limit(10)})
        .merge({ debit_cards: self.user.debit_cards&.map(&:api_output) || [] })
    end
  
    def check_status
      return if self.status.present?
  
      self.status = :status_active
    end
  
    def create_credit_transaction(amount, source: nil, status: :pending, save: true, skip_source: false)
      transaction = Transaction.new(
        amount: amount,
        source: source,
        destination: self,
        txn_type: :type_credit,
        status: status,
        skip_source: skip_source
      )
  
      transaction.save! if save
  
      transaction
    end
  
    def create_debit_transaction(amount, status: :pending, destination: nil)
      Transaction.create!(
        amount: amount,
        source: self,
        destination: destination,
        txn_type: :type_debit,
        status: status,
      )
    end
end
  
