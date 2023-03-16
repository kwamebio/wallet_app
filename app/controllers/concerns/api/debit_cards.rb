module Api::DebitCards
    extend ActiveSupport::Concern
  
    def send_pin
      response = PaystackService::DebitCard.submit_pin(
        transaction_ref: params.require(:reference), pin: params.require(:pin)
      )
      parse_paystack_response(response)
    end
  
    def send_otp
      response = PaystackService::DebitCard.submit_otp(
        transaction_ref: params.require(:reference), otp: params.require(:otp)
      )
      parse_paystack_response(response)
    end
  end
  