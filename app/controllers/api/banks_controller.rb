class Api::BanksController < ApiController
    before_action :authenticate
  
    def index
      paystack_bank_list = parse_paystack_response(PaystackService::Utility.banks)
      result = paystack_bank_list.map { |bank| bank.slice('name', 'slug', 'code') }
  
      render json: { data: result }
    end
  
    def parse_paystack_response(response)
      if response['status'] == false
        raise StandardError, message: response['message']
      elsif response['status'] == true
        return response['data']
      end
    end
end
  