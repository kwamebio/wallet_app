class Api::BankAccountsController < ApiController
    before_action :authenticate
  
    def verify

      byebug
      bank_account = BankAccount.find_by(**account_params)
  
      if bank_account.blank?
        paystack_response = PaystackService::Utility.resolve_account_number(**account_params)
        account_name = parse_paystack_account_response(paystack_response)
        recipient_response = parse_paystack_recipient_response(
          PaystackService::Utility.transfer_recipient(account_name: account_name, **account_params)
        )
  
        bank_account = BankAccount.create!(**recipient_response)
      end
  
      render json: { message: "bank account successfully verified", data: bank_account.api_output }
    end
  
    def parse_paystack_recipient_response(response)
      if response['status'] == false
        raise StandardError, message: response['message']
      elsif response['status'] == true
        result = { recipient_code: response['data']['recipient_code'] }
        result.merge(response['data']['details'].slice('account_number', 'account_name', 'bank_code', 'bank_name'))
      end
    end
  
    def parse_paystack_account_response(response)
      if response['status'] == false
        raise StandardError, message: response['message']
      elsif response['status'] == true
        response['data']['account_name']
      end
    end
  
    def account_params
      {
        account_number: params.require(:account_number),
        bank_code: params.require(:bank_code)
      }
    end
end