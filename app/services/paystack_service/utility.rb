class PaystackService::Utility
    include PaystackService::ApiModule
  
    def self.banks
      self.get('/bank', headers: headers).parsed_response
    end
  
    def self.resolve_account_number(account_number:, bank_code:)
      query = {account_number: account_number, bank_code: bank_code}.to_query
      self.get("/bank/resolve?#{query}", headers: headers).parsed_response
    end
  
    def self.transfer_recipient(account_number:, bank_code:, account_name:, type: 'nuban')
      body = {
        type: type, currency: 'NGN', account_number: account_number, name: account_name,
        bank_code: bank_code, description: 'transfer recipient'
      }
  
      self.post('/transferrecipient', body: body.to_json, headers: headers).parsed_response
    end
end