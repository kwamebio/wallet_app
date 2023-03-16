class Api::WalletsController < ApiController
    include Api::DebitCards
  
    before_action :set_transaction, only: [:send_otp, :send_pin]
    before_action :authenticate
    before_action :find_or_create_wallet
    before_action :set_destination, only: [:transfer]
  
    def show
      render json: @wallet.api_output, status: :ok
    end
  
    def credit
      amount = params.require(:amount).to_i
      debit_card = @user.debit_cards.find(params.require(:debit_card_id))
  
      @transaction = @wallet.create_credit_transaction(amount, source: debit_card)
      response = PaystackService::DebitCard.charge(
        transaction: @transaction,
        authorization: { authorization_code: debit_card.authorization_code }
      )
  
      parse_paystack_response(response)
    end
  
    def transfer
      amount = params.require(:amount).to_i
      return render json: { message: 'Insufficient balance' }, status: :bad_request if amount > @wallet.settled_balance
      return render json: { message: 'Invalid destination' }, status: :bad_request if @wallet == @destination
  
      @transaction = @wallet.create_debit_transaction(amount, destination: @destination)
      
      PaystackService::Transfer.initiate(
        transaction: @transaction,
        reason: params[:reason] || ''
      )
  
      render json: { message: 'Your transaction is pending' }
    end
  
    def set_destination
      account_id = params[:account_id]
      case params[:account_type]
      when 'bank_account'
        @destination = BankAccount.find(account_id)
      when 'wallet'
        @destination = Wallet.find(account_id)
      end
  
      render json: { message: 'Destination does not exist' }, status: :not_found if @destination.blank?
    end
  
    def find_or_create_wallet
      return @wallet = @user.wallet if @user.wallet.present?
  
      @user.create_wallet
      @wallet = @user.wallet
    end
  
    def parse_paystack_response(response)
      if response['status'] == false
        @transaction.update!(status: :cancelled)
        raise StandardError, response['message']
      elsif response['data']['status'] == 'success'
        ActiveRecord::Base.transaction do
          @transaction.update!(status: :success)
          @wallet.settled_balance += @transaction.amount
          @wallet.save!
          return render json: {
            message: 'funding is successful',
            data: @wallet.api_output
          }
        end
      else
        return render json: response['data']
      end
    end
  
    def parse_paystack_transfer_response(response)
      if response['status'] == false
        @transaction.update!(status: :cancelled)
        raise StandardError, response['message']
      else
        return true
      end
    end
  
    def set_transaction
      @transaction = Transaction.find_by(txn_ref: params.require(:reference))
      render json: {message: 'transaction with reference does not exist' }, status: :not_found if @transaction.blank?
    end
end