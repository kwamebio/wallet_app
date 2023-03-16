class PaystackService::Transfer
    include PaystackService::ApiModule
  
    def self.initiate(transaction:, source: 'balance', reason: '')
      body = {
        amount: transaction.amount * 100,
        source: source,
        reason: reason,
        reference: transaction.txn_ref,
        recipient: transaction.destination.recipient_code
      }
  
      self.post('/transfer', body: body.to_json, headers: headers).parsed_response
    end
end