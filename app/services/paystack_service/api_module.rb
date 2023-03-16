module PaystackService::ApiModule
    extend ActiveSupport::Concern
  
    included do
      include HTTParty
      base_uri 'https://api.paystack.co'
  
      def self.headers
        secret_key = 'xxxxxxxxxx' # your paystack secret key
        {
          'Authorization' => "Bearer #{secret_key}",
          'Content-Type' => 'application/json'
        }
      end
    end
end